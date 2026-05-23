# Space Defenders — Game Design Document Index

Welcome to the **Space Defenders** Game Design Document (GDD). To keep our documentation clean, maintainable, and modular, the GDD is split into separate specialized files. This allows us to update specific gameplay systems (like adding new ship types or updating asteroid variants) without bloating a single file or causing git merge conflicts.

Below is the directory map of the modular GDD:

---

## GDD Directory Map

### 📖 [01. Game Overview](01_game_overview.md)
*Core high-level summary, pitch, and player loop.*
- High-Level Summary
- Core Loop & Win/Loss Conditions

### ⚙️ [02. Core Mechanics](02_core_mechanics.md)
*High-level match rules, player health, and global economy.*
- **Lives System**: Penalties on leak
- **Economy**: Minerals earnings, costs, and wave bonuses
- **Wave Control**: Launch mechanisms

### ☄️ [03. Asteroids & Threat Registry](03_asteroids.md)
*The physical division, armor, and elementals of our targets.*
- **Asteroid Splitting System**: Tier-based HP and physical deconstruction scales
- **Asteroid Variants**: Blinding Tail, Hard Crust, Magnetic Core, Ring Belt resistances
- **Elemental Sub-Types**: Ice & Lava thermal/freezing laser physics and chain reactions

### 🛸 [04. Spaceships & Towers](04_spaceships.md)
*Player arsenal, placement rules, balance metrics, and shot categories.*
- Placement, Repositioning, and Selling Mechanics
- Targeting Priority Modes (First, Last, Strongest, Closest)
- Detailed Ship Registry (7 Ship types: Scout, Laser Frigate, Missile Cruiser, Ion Cannon, Drone Carrier, Pulse Beam, Gravity Well)
- Hot/Cold Laser Upgrades
- Special Kinetic Blast Interactions
- Gravitational Support & Mass-scaled Freeze Rules

### 🗺️ [05. Map Design](05_map.md)
*Grid layout, path, waypoints, and tactical layout.*
- Prototype Grid (32x18 tiles, 64px)
- Z-Path with Loop Layout & Choke Points
- Tile Classification (`PATH`, `BUILDABLE`, `BLOCKED`)

### 🌊 [06. Wave System](06_wave_system.md)
*Wave configurations, pacing, and mineral payouts.*
- Wave-by-Wave Composition Table (Waves 1-10)
- Economic Pacing & Balanced Budgeting

### 🖥️ [07. UI & Input](07_ui_input.md)
*User interface layouts and interaction flows.*
- HUD Specifications
- Ghost Placement & Verification feedback loops
- Ship Management Panel (Targeting, upgrading, selling, moving)
- Game Speed controls (1x/2x speed toggle)

### 🏗️ [08. Technical Architecture](08_technical_architecture.md)
*Engine implementation plans, directories, autoloads, resources, and signals.*
- Godot 4 & GDScript integration
- Project Directory Tree
- Autoload Managers (`GameManager`, `WaveManager`, `EconomyManager`)
- Signal Map & Event-driven Architecture
- Core Data Resources (`ShipData`, `AsteroidData`, `WaveData` GDScript templates)

### 🧪 [09. TDD Test Plan](09_tdd_test_plan.md)
*Godot Unit Test (GUT) specs for both units and full wave integrations.*
- Asteroid Splitting & Regeneration tests
- Variant Blockage & Pierce counters tests
- Elemental Laser / Kinetic Chain reaction tests
- Economy, Selling, and Repositioning fee tests
- Targeting modes & Drone distribution tests
- Pulse Beam cluster auto-rotation and Kinetic tests
- Gravity Well freeze durations, support rules, and variant bypass tests
- Wave Progression & Integration simulations

### 🚀 [10. Roadmap & Questions](10_roadmap_and_questions.md)
*Development lifecycle phases, open questions, and future expansion scope.*
- Phase 1 to Phase 7 Development Roadmap
- Open Questions & TBD parameters
- Future Scope (comets, asteroid belts, boss variants, extra maps)

---

## Document Meta
- **Game Title**: Space Defenders
- **Development Phase**: Prototype Phase
- **Current Spec Version**: v0.5
- **Engine Target**: Godot 4 (GDScript)
