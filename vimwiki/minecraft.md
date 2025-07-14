# Minecraft JS
## Set up Behavior Pack project
### manifest / folders
- manifest.json
- /scripts/main.js
```json
{
  "format_version": 2,
  "header": {
    "name": "pack.name",
    "description": "pack.description",
    "uuid": "4af4324f-5785-47d5-bfe4-dba8599b897c",
    "version": [1, 0, 0],
    "min_engine_version": [1, 16, 0]
  },
  "modules": [
    {
      "type": "data",
      "uuid": "cd167912-1a87-4c17-b992-f21dfc624e3d",
      "version": [1, 0, 0]
    },
    {
      "uuid": "9c2791a9-6b9b-4aa7-a551-b6b2be532a6b",
      "version": [1, 0, 0],
      "type": "script",
      "language": "javascript",
      "entry": "scripts/main.js"
    }
  ],
  "capabilities": ["script_eval"],
  "dependencies": [
    {
      "module_name": "@minecraft/server",
      "version": "1.16.0"
    },
    {
      "module_name": "@minecraft/server-ui",
      "version": "1.3.0"
    }
  ]
}
```
### NodeJS
```bash
npm init
npm install @minecraft/server
npm install @minecraft/server-ui
npm install @minecraft/server-net
npm install @minecraft/server-gametest
```
### Beta APIs
- Editor: https://offroaders123.github.io/Dovetail/
- Options:
  - experiments:
    - experiments_every_used: 1b
    - saved_with_toggled_experiments: 1b
    - data_driven_items: 1b
    - gametest: 1b
    - upcoming_creator_features: 1b
- data/config/default/permissions.json
  - add `@minecraft/server-net` to the list
