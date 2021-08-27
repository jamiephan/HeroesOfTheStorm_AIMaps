# HeroesOfTheStorm_AIMaps
Maps from the jamiephan/HeroesOfTheStorm_S2MA repo patched with AI included!

## Running the maps

If you would like to run the map in ./maps, please refer to https://jamiephan.github.io/HeroesOfTheStorm_TryMode2.0/install.html

## Directories

- [./maps](./maps)
  - [1v1](./maps/1v1)
  - [1v2](./maps/1v2)
  - [1v3](./maps/1v3)
  - [1v4](./maps/1v4)
  - [1v5](./maps/1v5)
  - [2v1](./maps/2v1)
  - [2v2](./maps/2v2)
  - [3v1](./maps/3v1)
  - [3v3](./maps/3v3)
  - [4v1](./maps/4v1)
  - [4v4](./maps/4v4)
  - [5v1](./maps/5v1)
  - [5v5](./maps/5v5)
  - [spectator](./maps/spectator)



## Generate yourself

Windows: 

- Simply run `powershell -File patchAI.ps1` and wait for all the maps generated!

## Modification

Right now, only the AI configuration present in [./maps](./maps) are set.

However, you can add or remove configurations in the [patchAI.ps1](./patchAI.ps1).

For example: 

`PatchAI $mapPath "./maps/4v4/$mapFile" "2,3,4,6,7,8,9"`

Means that it will generate AI for Player 2,3,4,6,7,8,9, Note that Player 1 is yourself, so if you add AI to it, you will become spectator mode.

- Player 1 - 5 = Blue team (your team)
- Player 6 - 10 = Red team (enemy team)

You can change any configuration you like, e.g 

``PatchAI $mapPath "./maps/3v4/$mapFile" "2,3,6,7,8,9"``

Then run the [patchAI.ps1](./patchAI.ps1) again!

## S2MA

The Maps in this repo are based on the repo [jamiephan/HeroesOfTheStorm_S2MA](https://github.com/jamiephan/HeroesOfTheStorm_S2MA) and simply modified the files to add AI into the maps.



