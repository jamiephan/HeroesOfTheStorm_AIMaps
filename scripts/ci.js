import { execSync, spawnSync } from 'child_process';
import fs from 'fs';
import path from 'path';
import http from 'http';
import https from 'https';
import os from 'os';

import { Archive, MPQ_FILE_REPLACEEXISTING } from '@jamiephan/stormlib';

const S2MA_REPO_URL = 'https://github.com/jamiephan/HeroesOfTheStorm_S2MA';

const SKIP_MAPS = new Set([
  'Try Me Mode.stormmap',
  'Tutorial.stormmap',
  'Tutorial Map Mechanics.stormmap',
  'Heroes of the Storm Veteran Challenges.stormmap',
]);


/**
 * Find and replace the first occurrence of `pattern` in `buf` with `replacement`.
 * Both must be arrays of the same length.
 */
function patchBytes(buf, pattern, replacement) {
  outer:
  for (let i = 0; i <= buf.length - pattern.length; i++) {
    for (let j = 0; j < pattern.length; j++) {
      if (buf[i + j] !== pattern[j]) continue outer;
    }
    for (let j = 0; j < replacement.length; j++) {
      buf[i + j] = replacement[j];
    }
    return; // replace only the first match, matching PS regex behaviour
  }
}

/**
 * Patch the MapInfo file inside a stormmap to set the given players as AI-controlled,
 * then save the result to savePath.
 *
 * @param {string} mapPath    - Source .stormmap file
 * @param {string} savePath   - Destination .stormmap file
 * @param {number[]} aiPlayers - Player slots (1-10) to convert to AI
 */
function patchAI(mapPath, savePath, aiPlayers) {


  // Copy to save path first
  fs.mkdirSync(path.dirname(savePath), { recursive: true });
  fs.copyFileSync(mapPath, savePath);

  const archive = new Archive();
  archive.open(savePath);
  
  // Read the MapInfo file from the archive
  const mapInfoFile = archive.openFile('MapInfo');
  const content = mapInfoFile.readAll();
  mapInfoFile.close();

  for (const i of aiPlayers) {
    // Players 1-5 are team 1 (team byte = 0x02); players 6-10 are team 2 (team byte = 0x06).
    // The MapInfo binary layout for a player slot:
    //   [playerIndex, controlType, 0, 0, 0, teamByte, 0, 0, 0, 0x50, 0x72, 0x6F, 0x74, 0, 0, 0, 0, 0]
    // controlType: 1 = human, 2 = AI.  We replace 1 -> 2.
    const teamByte = i <= 5 ? 0x02 : 0x06;
    patchBytes(
      content,
      [i, 1, 0, 0, 0, teamByte, 0, 0, 0, 0x50, 0x72, 0x6F, 0x74, 0, 0, 0, 0, 0],
      [i, 2, 0, 0, 0, teamByte, 0, 0, 0, 0x50, 0x72, 0x6F, 0x74, 0, 0, 0, 0, 0]
    );
  }


  // Create a temporary file to write the modified MapInfo content
  const tempFile = path.resolve(os.tmpdir(), path.basename(savePath) + '.MapInfo');
  fs.writeFileSync(tempFile, content);

  // Replace the MapInfo file in the archive with the modified version
  archive.addFile(tempFile, 'MapInfo', {
    flags: MPQ_FILE_REPLACEEXISTING,
  });
  
  // Clean up the temporary file
  fs.unlinkSync(tempFile);


  // Save and close the archive
  archive.close();
}

async function main() {
  // Clone the S2MA repo
  console.log(`Cloning S2MA repo from ${S2MA_REPO_URL}...`);
  execSync(`git clone --depth 1 "${S2MA_REPO_URL}" ./_s2ma_repo`, { stdio: 'inherit' });
  console.log('Clone complete.');

  // Process every map
  const mapsDir = './_s2ma_repo/maps';
  const mapFiles = fs.readdirSync(mapsDir);
  const mapsToProcess = mapFiles.filter(f => !SKIP_MAPS.has(f));
  const skipped = mapFiles.filter(f => SKIP_MAPS.has(f));

  console.log(`Found ${mapFiles.length} map(s): ${mapsToProcess.length} to process, ${skipped.length} skipped (${skipped.map(f => path.basename(f, path.extname(f))).join(', ')}).`);

  let mapIndex = 0;
  for (const mapFile of mapFiles) {
    if (SKIP_MAPS.has(mapFile)) {
      console.log(`Skipping: ${path.basename(mapFile, path.extname(mapFile))}`);
      continue;
    }
    mapIndex++;
    const mapName = path.basename(mapFile, path.extname(mapFile));
    console.log(`\n[${mapIndex}/${mapsToProcess.length}] Processing: ${mapName}`);

    const mapPath = path.resolve(mapsDir, mapFile);

    // Generate all NvM compositions (1v1 … 5v5).
    // Team 1: player 1 is always the human; slots 2..t1 are AI.
    // Team 2: slots 6..t2+5 are AI.
    for (let t1 = 1; t1 <= 5; t1++) {
      const t1Players = [];
      for (let t1n = 2; t1n <= t1; t1n++) {
        t1Players.push(t1n);
      }

      for (let t2 = 1; t2 <= 5; t2++) {
        const t2Players = [];
        for (let t2n = 1; t2n <= t2; t2n++) {
          t2Players.push(t2n + 5);
        }

        const versesString = `${t1}v${t2}`;
        const aiPlayers = [...t1Players, ...t2Players];

        console.log(`  Patching ${versesString} (AI slots: [${aiPlayers.join(', ')}])`);
        patchAI(mapPath, `./maps/${versesString}/${mapFile}`, aiPlayers);
      }
    }

    // Spectator mode: all 10 player slots set to AI
    console.log(`  Patching spectator (all slots AI)`);
    patchAI(mapPath, `./maps/spectator/${mapFile}`, [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);
  }

  console.log(`\nAll maps processed. Cleaning up cloned repo...`);
  fs.rmSync('./_s2ma_repo', { recursive: true, force: true });
  console.log('Done.');
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});
