# SPACE DEFENDERS
## 08. Technical Architecture
**Version 0.5 | Prototype Phase**

---

## 8.1 Engine & Specifications

- **Engine Target**: Godot Engine 4 (latest stable).
- **Programming Language**: GDScript (statically typed for stability).
- **Testing Framework**: Godot Unit Test (GUT) plugin.
- **Reference Resolution**: 2048 × 1152 pixels (16:9 Aspect Ratio). Widescreen scaling and layout anchoring are configured via the engine's Project Settings (`canvas_items` stretch mode).

---

## 8.2 Project Directory Tree

```
space_defenders/
├── scenes/
│   ├── game.tscn               # Root scene coordinating HUD, Map, and Managers
│   ├── map/
│   │   └── map.tscn            # Grid2D, Path2D nodes, and tile layouts
│   ├── entities/
│   │   ├── asteroids/
│   │   │   ├── asteroid.tscn   # Base asteroid scene
│   │   │   └── asteroid.gd     # Unified asteroid physics and splitting
│   │   └── ships/
│   │       ├── ship.tscn       # Base ship scene
│   │       ├── scout.tscn
│   │       ├── laser_frigate.tscn
│   │       ├── missile_cruiser.tscn
│   │       ├── pulse_beam.tscn
│   │       ├── ion_cannon.tscn
│   │       ├── drone_carrier.tscn
│   │       └── gravity_well.tscn
│   └── ui/
│       ├── hud.tscn            # Main head-up display
│       ├── ship_panel.tscn     # Detailed selection menu (sell/move/upgrade)
│       └── shop_bar.tscn       # Ship purchase strip
├── scripts/
│   ├── managers/
│   │   ├── game_manager.gd     # Global game state coordinator (Autoload)
│   │   ├── wave_manager.gd     # Wave spawn timelines and states (Autoload)
│   │   └── economy_manager.gd  # Resource, life, and transaction manager (Autoload)
│   ├── entities/
│   │   ├── asteroid_base.gd
│   │   ├── asteroid_variant.gd # Variant traits: blinding, crust, magnetic, rings
│   │   ├── asteroid_elemental.gd # Ice / Lava states and chains
│   │   ├── ship_base.gd
│   │   ├── gravity_well.gd      # Area gravity controls and recharge states
│   │   └── pulse_beam.gd        # Sector scan and rotational blast
│   └── ui/
│       ├── hud.gd
│       └── ship_panel.gd
├── resources/
│   ├── ship_data.tres          # Tres database defining ship baseline parameters
│   └── wave_data.tres          # Tres database defining waves 1-10 configs
├── assets/
│   ├── sprites/                # 2D raster sprites
│   └── sounds/                 # Sound effects
└── tests/
    ├── unit/
    │   ├── test_asteroid_splitting.gd
    │   ├── test_asteroid_variants.gd
    │   ├── test_elemental_interactions.gd
    │   ├── test_economy.gd
    │   ├── test_targeting.gd
    │   └── test_wave_manager.gd
    └── integration/
        ├── test_wave_run.gd
        └── test_full_game.gd
```

---

## 8.3 Autoload Managers (Singletons)

We employ three singletons to manage high-level game states, allowing entities to remain decoupled and modular.

| Manager | Script Reference | Direct Responsibilities |
|---------|------------------|-------------------------|
| **`GameManager`** | `game_manager.gd` | Tracks core states (PLANNING, WAVE_ACTIVE, GAME_OVER, VICTORY); handles life totals and matches. |
| **`WaveManager`** | `wave_manager.gd` | Spawns wave cohorts based on loaded `WaveData` configurations; monitors path progression. |
| **`EconomyManager`** | `economy_manager.gd` | Balances wallets, checks affordability, handles reposition fees, upgrades, and sell transactions. |

---

## 8.4 Global Signal Map

To prevent tightly coupled dependencies, communication between systems is handled through Godot signals.

| Signal Name | Emitted By | Listened By | Payload parameters |
|-------------|------------|-------------|--------------------|
| `asteroid_leaked` | `Asteroid` | `GameManager`, `EconomyManager` | `tier: int` |
| `asteroid_destroyed` | `Asteroid` | `EconomyManager` | `tier: int, pos: Vector2` |
| `asteroid_chain_reaction` | `Asteroid` | `Asteroid` (AoE checks) | `type: String, pos: Vector2, radius: float` |
| `asteroid_converted` | `Asteroid` | UI, Visual effects | `pos: Vector2` |
| `gravity_well_activated` | `GravityWell` | `Asteroid` (Status checks) | `pos: Vector2, range: float` |
| `gravity_well_released` | `GravityWell` | `Asteroid` | — |
| `mineral_earned` | `EconomyManager` | `HUD` | `amount: int` |
| `mineral_spent` | `EconomyManager` | `HUD` | `amount: int` |
| `life_lost` | `GameManager` | `HUD` | `amount: int` |
| `wave_started` | `WaveManager` | `HUD`, `GameManager` | `wave_number: int` |
| `wave_completed` | `WaveManager` | `EconomyManager`, `HUD` | `wave_number: int, no_leak: bool` |
| `game_over` | `GameManager` | UI overlay | — |
| `game_won` | `GameManager` | UI overlay | — |
| `ship_placed` | Placement System | `EconomyManager`, `Map` | `ship_type: String, pos: Vector2` |
| `ship_sold` | `Ship` | `EconomyManager` | `refund: int` |
| `ship_repositioned` | `Ship` | `EconomyManager` | `cost: int` |
| `ship_upgraded` | `Ship` | `EconomyManager` | `type: String, upgrade_id: String, cost: int` |

---

## 8.5 Core Data Resources (GDScript Templates)

Using resources allows us to customize ship and wave parameters inside the Godot Inspector without touching code.

### `ShipData` Resource (`scripts/resources/ship_data.gd`)
```gdscript
class_name ShipData
extends Resource

@export var id: String
@export var display_name: String
@export var base_cost: int
@export var range_tiles: float
@export var damage_tiers: int
@export var fire_rate: float            # Shots per second
@export var shot_type: String           # "weak", "pierce", "heavy", "kinetic", "gravitational"
@export var is_piercing: bool
@export var is_splash: bool
@export var splash_radius: float
@export var is_cone: bool               # Set true for Pulse Beam
@export var cone_angle: float           # Set to 90.0 for Pulse Beam
@export var is_gravity_well: bool       # Set true for Gravity Well
@export var recharge_time: float        # Recharge duration in seconds (Gravity Well/Pulse Beam)
@export var laser_type: String          # "", "hot", or "cold" (set via upgrades)
@export var default_targeting: String   # "First", "Last", "Strongest", "Closest"
@export var scene_path: String
```

### `AsteroidData` Resource (`scripts/resources/asteroid_data.gd`)
```gdscript
class_name AsteroidData
extends Resource

@export var tier: int
@export var display_name: String
@export var speed: float                # Pixels per second
@export var hits_to_split: int          # Target HP before splitting
@export var lives_on_leak: int          # Lives lost if leaked
@export var minerals_on_destroy: int      # Drops when fully destroyed
@export var variant: String             # "", "blinding", "hard_crust", "magnetic", "ring_belt"
@export var elemental: String           # "", "ice", "lava"
```

### `WaveData` Resource (`scripts/resources/wave_data.gd`)
```gdscript
class_name WaveData
extends Resource

@export var wave_number: int
@export var spawn_groups: Array         # Array of Dictionaries: [{"type": "Pebble", "count": 10}]
@export var spawn_interval: float       # Time between spawns
@export var no_leak_bonus: int          # wave_number * 5
```
