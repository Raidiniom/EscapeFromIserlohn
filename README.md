# EscapeFromIserlohn
## Elevator Pitch / Hook 
In Escape From Iserlohn, a 3D third-person roguelike, you battle through escalating waves inside the Iserlohn Fortress, collect seeds from fallen enemies, then grow those seeds between runs to gain powerful buffs. Each failed escape makes your home base farm stronger, turning long‑term planning and crop choices into the key to finally breaking out.	

## Game Overview & Concept
Genre: 3D third-person roguelike with survival-wave combat and light farming meta-progression.
Target Audience: Teens and adults who enjoy action roguelikes and comfy farming/meta systems; playable by most ages, with minimal graphic violence.
Unique Selling Point (USP): Between runs, you plant seeds dropped by fortress enemies in your base farm; grown crops permanently enhance your next escape attempt (stats, abilities, or utilities).
Core Theme / Mood / Art Style: Fantasy siege and escape vibe, slightly stylized 3D low‑poly characters and environments, moody fortress interiors contrasted with a cozy, growing base garden.
High-level Story / Setting: You are a prisoner trapped inside the massive space stronghold “Iserlohn Fortress,” forced to fight through 10 increasingly dangerous combat rounds to reach an escape corridor. After each failed or successful attempt, you retreat to a hidden base where you plant seeds harvested from enemies, slowly transforming a sterile corner of the fortress into a living farm that empowers your next run.

## Core Gameplay & Mechanics
Core Loop: Fight waves of enemies in an arena inside Iserlohn, survive or clear a set of 10 rounds with rising difficulty, collect seeds and resources from enemies and chests, return to your base to plant seeds, harvest previous crops, and choose buffs, start a new escape attempt with improved stats or abilities, aiming to finally clear all 10 rounds.

Key Mechanics (list 4–6 main ones):
Wave-based combat: Third-person movement, dodging, and basic attacks against mobs that steadily increase in number and complexity each round.
Seed drops: Enemies have a chance to drop different seed types, each tied to a specific buff category (health, damage, movement, utility, etc.).
Base farming: Between runs, you plant seeds in limited farm plots at your starting base; crops grow only when a full run (10 rounds or death) is completed.\

Crop buffs: Harvested crops convert into persistent modifiers for the next run (e.g., +max HP, faster movement, cooldown reduction, or new passive effects).
Simple build choices: Before starting a run, you choose which harvested crops to “equip” as active buffs, allowing some build experimentation without complex menus.

##  Scope & Feasibility
Core Features:
 - Third-person player controller (movement, basic camera, attack, dodge, hit/health system).
 - Wave-based combat in 1–2 fortress arenas (enemy spawners, difficulty scaling across 10 rounds).
 - Basic enemy types with simple AI (melee chaser, ranged shooter, maybe one elite variant).
 - Seed drop and farming system (seed item drops, limited farm plots, growth per run, harvest to buff stats).
 - Base hub scene with planting/harvesting, run start, and basic progression feedback UI.
 - Core UI/HUD (health bar, wave counter, basic buff indicators, pause menu).
 - Sound effects and simple background music (combat, planting, UI feedback) and export to PC + Web.

Stretch Goals (nice-to-have, only if time allows): 
 - Additional enemy types and one simple mini‑boss wave.
 - More crop types with unique passive effects (e.g., lifesteal, thorns, small AoE).
 - Simple meta‑unlock system (new seed types or base decorations unlocked after X completed runs).
 - Cosmetic base upgrades that reflect your progression (more plants, lights, props).

Risks & Mitigation: 
 - Risk 1: Third-person controller and camera feel janky or take too long to polish. → Mitigation: Start from a known Godot 4 third-person controller pattern or plugin and keep movement simple (no advanced parkour) for this project.
 - Risk 2: Farming system becomes too complex for the timeframe. → Mitigation: Limit crops to 3–4 clear buff types and only 1–2 growth stages; focus on clarity over depth.
 - Risk 3: Balancing 10 waves is hard. → Mitigation: Create 3 difficulty curves and pick the most fun from playtesting; expose key values (HP, damage, spawn count) as easily tweakable variables.

Phased Timeline (from now to May 15):
 - Weeks 1–2: Core player controller + camera, basic combat prototype in a greybox arena, GitHub repo with initial Godot project.
 - Weeks 3–5: Implement enemy types, wave system, and full 10‑wave run logic; basic “return to base” flow.
 - Weeks 6–8: Farming system (planting, growth between runs, buff application), base hub art pass, initial UI for buffs and waves.
 - Weeks 9–10: Art and animation polish, sound and music integration, performance passes; refine wave balancing.

Final week: Playtesting and bug fixing, build for PC + Web, capture trailer footage, finalize documentation and pitch.

## Technical & Godot Plan
Key Godot Features Planned:
    Nodes/Scenes: CharacterBody3D (player and enemies), Camera3D with SpringArm3D for third-person camera, StaticBody3D for environment, Area3D for pickups and triggers, separate scenes for Player, Enemy, Seed, Crop, WaveManager, and BaseHub.

    Signals & Scripts: Custom signals for player death, wave cleared, seed dropped/picked up, crop grown/harvested; simple state machine scripts for enemies (idle → chase → attack).

    Other: Timers for wave pacing and crop growth, basic Navigation3D if needed for enemy pathing, AudioStreamPlayer3D for spatial SFX, AnimationPlayer/AnimationTree for character animations.

    Current Progress
    Early prototype goals: Greybox arena, a single enemy type, and a basic seed pickup to demonstrate the “kill → drop → pick up” flow.

Object-Oriented Approach
 - A base Entity3D script for shared health, damage, and hit logic, inherited by Player and Enemy scenes.
 - Enemy variants share a base Enemy script with overridable properties (speed, attack, HP).
 - A Seed resource or scriptable data object defining buff type and strength, used by Seed items and Crop plots.
 - A central GameManager/WaveManager node that coordinates waves, player death, and transitions back to the base hub.
