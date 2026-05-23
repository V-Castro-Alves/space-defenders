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

## 5.2 Grid Layout — The Split-Stream Corridor (Switchback)

The map features a triple-corridor snaking switchback layout designed to establish isolated localized combat zones and prevent global coverage overlap:

```
 Entry (left) -> Corridor A (Right to U-Turn 1) -> Corridor B (Left to U-Turn 2) -> Corridor C (Right to Space Station Exit)
```

### Tactical localized zones
By forcing tight 180° turns and snaking lanes that segment the grid vertically, this layout restricts long-range cross-lane firing. Defensive structures must be placed tactically in local zones to target local corridors, creating distinct high-value kill zones at each U-turn corridor bend.

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

The exact coordinates of the path nodes loaded in the `main.gd` filegoverns asteroid path-following:

```gdscript
# Main.gd path coordinate array for snaking Switchback layout
var waypoints = [
	Vector2(-64, 160),   # Spawner Start (left offscreen)
	Vector2(1600, 160),  # Corridor A end / turn down
	Vector2(1600, 480),  # U-Turn 1 down
	Vector2(192, 480),   # Corridor B end / turn down
	Vector2(192, 800),   # U-Turn 2 down
	Vector2(1600, 800),  # Corridor C end / turn down
	Vector2(1600, 960),  # Final Exit turn down
	Vector2(1728, 960)   # Space Station Exit (Right sidebar boundary)
]
```
