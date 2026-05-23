# Space Defenders 🚀👾

[![Godot Engine](https://img.shields.io/badge/Engine-Godot_4-478cbf?logo=godot-engine&logoColor=white)](https://godotengine.org/)
[![Language](https://img.shields.io/badge/Language-GDScript-3c7f99?logo=godot-engine&logoColor=white)](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_basics.html)
[![Testing Framework](https://img.shields.io/badge/Tests-GUT-2d7f3e?logo=pytest&logoColor=white)](https://github.com/bitwes/Gut)
[![Current Version](https://img.shields.io/badge/Spec_Version-0.5-orange)](gdd/README.md)
[![Status](https://img.shields.io/badge/Phase-1__Prototype_Design-blue)](gdd/10_roadmap_and_questions.md)

Welcome to **Space Defenders**, a premium, tactical tower defense game built from the ground up in **Godot 4** using **GDScript**. 

In Space Defenders, you deploy high-tech defense spaceships to protect a vital deep-space station from cascading waves of incoming asteroids. The game features a unique, physics-themed **asteroid deconstruction splitting system** where an asteroid's size *is* its health. Shooting larger asteroids splits them into smaller, faster-moving chunks, initiating chaotic and satisfying chain reactions that require tactical planning to survive.

---

## 🌌 Core Features

- **Size-as-HP Splitting System**: Large asteroids divide into two smaller debris elements when destroyed, cascading from massive *Planet Chunks* down to swift *Pebbles*.
- **Tactical Fleet Composition**: Deploy 7 distinct spaceship hulls, including focused laser beam ships, long-range heavy artillery, spatial drone swarms, cone-based kinetic blasters, and gravity wells.
- **Armor & Visual Counter-Plays**: Overcome complex asteroid variants like *Blinding Tails* that disrupt ship sensors, *Hard Crusts* that resist light fire, *Magnetic Cores* that regenerate, and *Ring Belts* that block splash damage.
- **Thermal Elemental Mechanics**: Upgrade your laser fleet to fire specialized *Hot* or *Cold* lasers to trigger chemical chain reactions in elements like *Ice* and *Lava* asteroids, melting, solidifying, or exploding clusters in a chain reaction.
- **Test-Driven Design**: The entire game is built using a Test-Driven Development (TDD) model, fully verified by a comprehensive **Godot Unit Test (GUT)** plan.

---

## 📁 Project & Document Architecture

Our project separates documentation specifications, engine scenes, and script structures into logical modules:

```
space_defenders/
├── gdd/                       # Modular Game Design Specification Folder
│   ├── README.md              # 📖 GDD Folder Index Directory
│   ├── 01_game_overview.md    # 🛸 Core loop, Win/Loss conditions
│   ├── 02_core_mechanics.md   # ⚙️ Lives, economy, and wave triggers
│   ├── 03_asteroids.md        # ☄️ Splitting, variants, and elementals
│   ├── 04_spaceships.md       # 🛸 Placement, stats, 7 ship types
│   ├── 05_map.md              # 🗺️ 32x18 Grid, Z-Path Loop layout
│   ├── 06_wave_system.md      # 🌊 Waves 1-10 balance & progression
│   ├── 07_ui_input.md         # 🖥️ HUD, preview clicks, management panel
│   ├── 08_technical_architecture.md # 🏗️ Autoloads, Resource, Signal map
│   ├── 09_tdd_test_plan.md    # 🧪 GUT Unit & Integration specs
│   └── 10_roadmap_and_questions.md # 🚀 Phases 1-7, TBD items, future scope
├── scenes/                    # Godot 4 .tscn Node Hierarchies
│   ├── game.tscn              # Root gameplay scene
│   ├── map/                   # Map & tile layouts
│   ├── entities/              # Ship and Asteroid actors
│   └── ui/                    # HUD and upgrade panel scenes
├── scripts/                   # GDScript Implementation scripts
│   ├── managers/              # Singletons (Game, Wave, Economy)
│   ├── entities/              # Ship, variant, and elemental controllers
│   └── ui/                    # Interface controllers
├── resources/                 # Custom Resource (.tres) Inspector DBs
├── tests/                     # GUT Test Suites
│   ├── unit/                  # System tests in isolation
│   └── integration/           # Wave and campaign run tests
├── project.godot              # Godot 4 Project file
└── README.md                  # 🚀 Main Project Entrypoint (this file)
```

---

## 📖 Design Specification Index

We have broken down our comprehensive v0.5 Game Design Document (GDD) into modular chapters. This makes the documentation highly maintainable, preventing merge conflicts and keeping updates clean:

1. **[01. Game Overview](gdd/01_game_overview.md)**: Conceptual pitch, win/loss rules, and player loop.
2. **[02. Core Mechanics](gdd/02_core_mechanics.md)**: Lives parameters, transaction systems, and manual wave triggers.
3. **[03. Asteroids & Threat Registry](gdd/03_asteroids.md)**: Splitting physics, HP tiers, variants (Blinding/Crust/Regen/Rings), and elementals (Ice/Lava) reactions.
4. **[04. Spaceships & Towers](gdd/04_spaceships.md)**: Tower registries, placement, repositioning costs, targeting systems, and advanced supports.
5. **[05. Map Design](gdd/05_map.md)**: Coordinates, grid definitions, tile flags, and choke points.
6. **[06. Wave System](gdd/06_wave_system.md)**: Wave-by-wave composition configs (Waves 1-10) and pacing rules.
7. **[07. UI & Input](gdd/07_ui_input.md)**: Head-up display layout, ghost previews, ship controls, and speed settings.
8. **[08. Technical Architecture](gdd/08_technical_architecture.md)**: Singletons, event maps, signal listeners, and Resource GDScript definitions.
9. **[09. TDD Test Plan](gdd/09_tdd_test_plan.md)**: Comprehensive spec guidelines for GUT test coverage.
10. **[10. Roadmap & Questions](gdd/10_roadmap_and_questions.md)**: Chronological project stages, current TBD parameters, and future roadmap.

---

## 🛠️ Local Setup & Play

To run and edit this project locally:

1. **Install Godot 4**: Download the latest stable version of [Godot Engine 4](https://godotengine.org/).
2. **Clone the Repository**: Put the project folder in your desired directory.
3. **Open the Project**:
   - Open the Godot Project Manager.
   - Click **Import** and select the `project.godot` file in the root of this project.
   - Click **Import & Edit**.
4. **Play the Game**:
   - Press **F5** in the Godot Editor or click the **Play** button in the top-right corner to run the `scenes/game.tscn` root scene.

---

## 🧪 Testing with GUT (Godot Unit Test)

This project relies on the **GUT plugin** to run unit and integration tests.

### Running Tests in the Editor
1. In the Godot Editor, locate the **GUT tab** in the bottom panel (or activate the GUT plugin under *Project Settings -> Plugins* if not already enabled).
2. Configure the directory paths:
   - **Unit Tests Directory**: `res://tests/unit/`
   - **Integration Tests Directory**: `res://tests/integration/`
3. Click **Run All** in the GUT panel to execute the entire test suite.

### Running Tests from the Command Line
To execute tests via CLI (perfect for automation or CI pipelines), run the following command from your terminal:

```bash
# General Command
godot --path . -s res://addons/gut/gut_cmdline.gd

# Command to run specific test groups
godot --path . -s res://addons/gut/gut_cmdline.gd -gdir=res://tests/unit/
```
*(Ensure `godot` is added to your environment variables, or replace it with the absolute path to your Godot executable).*
