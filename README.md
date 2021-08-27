# HeroesOfTheStorm_AIMaps
Maps from the jamiephan/HeroesOfTheStorm_S2MA repo patched with AI included!

## Running the maps

If you would like to run the map in [./maps](./maps), please refer to https://jamiephan.github.io/HeroesOfTheStorm_TryMode2.0/install.html

## Directories

This repo will cover the AI compositions as below:

- [./maps](./maps)
  - [spectator](./maps/spectator): (**5 AI** vs **5 AI**)
  - [1v1](./maps/1v1): (You + **0 AI** vs **1 AI**)
  - [1v2](./maps/1v2): (You + **0 AI** vs **2 AI**)
  - [1v3](./maps/1v3): (You + **0 AI** vs **3 AI**)
  - [1v4](./maps/1v4): (You + **0 AI** vs **4 AI**)
  - [1v5](./maps/1v5): (You + **0 AI** vs **5 AI**)
  - [2v1](./maps/2v1): (You + **1 AI** vs **1 AI**)
  - [2v2](./maps/2v2): (You + **1 AI** vs **2 AI**)
  - [2v3](./maps/2v3): (You + **1 AI** vs **3 AI**)
  - [2v4](./maps/2v4): (You + **1 AI** vs **4 AI**)
  - [2v5](./maps/2v5): (You + **1 AI** vs **5 AI**)
  - [3v1](./maps/3v1): (You + **2 AI** vs **1 AI**)
  - [3v2](./maps/3v2): (You + **2 AI** vs **2 AI**)
  - [3v3](./maps/3v3): (You + **2 AI** vs **3 AI**)
  - [3v4](./maps/3v4): (You + **2 AI** vs **4 AI**)
  - [3v5](./maps/3v5): (You + **2 AI** vs **5 AI**)
  - [4v1](./maps/4v1): (You + **3 AI** vs **1 AI**)
  - [4v2](./maps/4v2): (You + **3 AI** vs **2 AI**)
  - [4v3](./maps/4v3): (You + **3 AI** vs **3 AI**)
  - [4v4](./maps/4v4): (You + **3 AI** vs **4 AI**)
  - [4v5](./maps/4v5): (You + **3 AI** vs **5 AI**)
  - [5v1](./maps/5v1): (You + **4 AI** vs **1 AI**)
  - [5v2](./maps/5v2): (You + **4 AI** vs **2 AI**)
  - [5v3](./maps/5v3): (You + **4 AI** vs **3 AI**)
  - [5v4](./maps/5v4): (You + **4 AI** vs **4 AI**)
  - [5v5](./maps/5v5): (You + **4 AI** vs **5 AI**)



## Generate yourself

Windows: 

- Simply run `powershell -File patchAI.ps1` and wait for all the maps generated!

## Modification

Right now, only the AI configuration present in [./maps](./maps) are set. However, you can add configurations in the [patchAI.ps1](./patchAI.ps1).

>All non-spectator combinations should have created. The modification below applies to if you want to be spectator mode and watch any combination number of AI vs AI.


### Players ID:


- Player 1 = Yourself (Blue Team)
- Player 2 - 5 = Blue team (your team)
- Player 6 - 10 = Red team (enemy team)

>Note: If you replace yourself with AI, you will become spectator mode.

### Example 1:

**Configuration:**

- You: Spectator
- Blue Team: 1 AI
- Red Team: 5 AI

**Outcome:**

You become spectator mode, watching AI 1v5.

**Code:**

`PatchAI $mapPath "./maps/spectator-1v5/$mapFile" "1,6,7,8,9,10"`

This means that it will generate AI for Player **1,6,7,8,9,10**


### Example 2:

**Configuration:**

- You: Spectator
- Blue Team: 3 AI
- Red Team: 4 AI

**Outcome:**

You become spectator mode, watching AI 3v4.

**Code:**

`PatchAI $mapPath "./maps/spectator-3v4/$mapFile" "1,2,3,6,7,8,9"`

This means that it will generate AI for Player **1,2,3,6,7,8,9**


### Finishing Up

After you setup all the configurations, run the [patchAI.ps1](./patchAI.ps1) again!

## S2MA

The Maps in this repo are based on the repo [jamiephan/HeroesOfTheStorm_S2MA](https://github.com/jamiephan/HeroesOfTheStorm_S2MA) and simply modified the files to add AI into the maps.



