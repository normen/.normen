# NetHack
#### Notes
- Dwarf don't eat gnome!
- Dwavish Mattock (broad pick)
- Aklys (thonged club)

## Skills
#### Archeologist skills
- Basic	
  - Weapons: dagger, knife, short sword, dart
  - Combat: two weapon combat, riding
  - Spells: attack, healing, matter
- Skilled	
  - Weapons: scimitar, club, quarterstaff, sling, unicorn horn
- Expert	
  - Weapons: pick-axe, saber, boomerang, whip
  - Combat: bare hands
  - Spells: divination

#### Strats
- Floating Eye
  - Looking glass (mirror)

#### Wand ID
Engraving with a wand uses up one charge (possibly wresting the last), but if the wand is nondirectional, it performs its usual effect.

1. "The engraving on the <floor> vanishes!"
- cancellation
- teleportation (the engraving is moved elsewhere in the level)
- make invisible
- cold (if the existing engraving is a burned one)

no message if no existing engraving

1. "- A few ice cubes drop from the wand."
- cold	

1. "The bugs on the <floor> stop moving!"
- sleep
- death	

1. "This <wand> is a wand of digging!"
2. "Gravel flies up from the floor!"
- digging	wand self-identifies

1. "This <wand> is a wand of fire!"	fire	wand self-identifies
2. "Lightning arcs from the wand. You are blinded by the flash!"
3. "This <wand> is a wand of lightning!"
- lightning	wand self-identifies

1. "The <floor> is riddled by bullet holes!"
- magic missile	

1. "The engraving now reads: <random message>"
- polymorph	no message if no existing engraving

1. "The bugs on the <floor> slow down!"
- slow monster	

1. "The bugs on the <floor> speed up!"
- speed monster	

1. "The wand unsuccessfully fights your attempt to write!"
- striking	

1. "The wand is too worn out to engrave."
-  wand is exhausted (x:0)	

1. No message or effect
- locking
- opening
- probing
- undead turning
- nothing
- secret door detection (self-identifies if secrets are detected)
- wand is cancelled (x:-1)
