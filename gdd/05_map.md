# SPACE DEFENDERS
## 05. Map Design
**Version 0.5 | Prototype Phase**

---

## 5.1 Grid Specifications

The map runs on a 2D tile layout optimized for clean coordinate math and clear visual indicators.

- **Grid Dimensions**: **32 tiles wide × 18 tiles high**.
- **Tile Scale**: **64 × 64 pixels** per grid unit.
- **Canvas Resolution**: **2048 × 1152 pixels** total canvas size, scaling cleanly to standard 16:9 widescreen formats.

---

## 5.2 Grid Layout — The Z-Path with Central Loop

The prototype map features a structured path stretching from the top-left to the bottom-right of the viewport. It shapes a "Z" with an orbital loop in the center:

```
 ┌────────────────────────────────────────────────────────┐
 │ ★ [0, 1] ══════════════════════════════════╗           │
 │                                            ║           │
 │                                      ╔═════╝           │
 │                                      ║                 │
 │                                 ┌────╜                 │
 │                                 │   [Loop Area]        │
 │                                 └────╖                 │
 │                                      ║                 │
 │                                      ╚═════════════ ■  │
 │                                                 [31, 16]│
 └────────────────────────────────────────────────────────┘
  ★ = Asteroid Entry Spawner (Top-Left)    ■ = Space Station Exit (Bottom-Right)
```

### Tactical Choke Point
The central loop acts as the primary focal point of the defense system. Ships placed near or inside the loop area possess overlapping coverages, allowing them to target incoming asteroids twice: once as they enter the loop, and again as they round the bend and exit. This represents the highest value real estate on the map.

---

## 5.3 Tile Classifications

All grid tiles must be explicitly flagged in the game engine to govern movement and placement logic.

| Tile Type | Color Under Cursor | Placement Rules | Movement Behavior |
|-----------|--------------------|-----------------|-------------------|
| **`PATH`** | 🔴 Red Highlight | **Placement Blocked**: Ships cannot be built or moved here. | **Asteroids only**: Asteroid entities traverse path nodes. |
| **`BUILDABLE`** | 🟢 Green Highlight | **Placement Allowed**: Available for building ships, upgrades, and repositioning. | Blocked for asteroid movement. |
| **`BLOCKED`** | 🔴 Red Highlight | **Placement Blocked**: Decorative environment tiles (nebulae, space debris, station hulls). | Blocked for asteroid movement. |

---

## 5.4 Waypoints Array (GDScript Reference)

The exact coordinates of the path nodes will be loaded into the `WaveManager` as an array of 2D coordinates.

```gdscript
# WaveManager path coordinate array (to be finalized in Phase 2)
var path_waypoints: Array[Vector2] = [
	Vector2(0, 1),    # Start at top-left
	Vector2(24, 1),   # First turn down
	Vector2(24, 5),   # Left turn
	Vector2(16, 5),   # Loop entrance
	# ... (Loop coordinates) ...
	Vector2(31, 16)   # Space station exit at bottom-right
]
```
