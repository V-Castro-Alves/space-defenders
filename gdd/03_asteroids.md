# SPACE DEFENDERS
## 03. Asteroids & Threat Registry
**Version 0.5 | Prototype Phase**

---

This document details the incoming threats, including the physics-based size-splitting system, variant behaviors, and thermal elemental reactions.

---

## 3.1 Asteroid Splitting System

Asteroids do not use traditional visual health bars. Instead, **their physical size represents their health**. When an asteroid's structural integrity (represented by Hits to Split) is depleted to 0, it fragments into smaller chunks.

- A **Pebble (Tier 1)** is fully destroyed and cleared from the board on taking its final hit.
- **Tiers 2 through 5** split into **two separate asteroids of the tier immediately below** when their HP is reduced to 0.

### Splitting and HP Balance Table

| Tier | Name | Hits to Split (HP) | Splits Into | Speed (px/s) | Lives Lost if Leaked |
|------|------|--------------------|-------------|--------------|----------------------|
| **5** | Planet Chunk | 5 | 2x Giant | 40 | 32 |
| **4** | Giant | 4 | 2x Meteor | 60 | 16 |
| **3** | Meteor | 3 | 2x Boulder | 90 | 8 |
| **2** | Boulder | 2 | 2x Pebble | 130 | 4 |
| **1** | Pebble | 1 | Destroyed | 180 | 1 |

### Total Hits to Fully Clear a Spawning Chain
Due to cascading splits, a single high-tier asteroid requires numerous cumulative shots to completely clear:
- **Pebble**: 1 hit
- **Boulder**: 2 (base) + 2(1) = **6 hits** to fully destroy
- **Meteor**: 3 (base) + 2(6) = **15 hits** to fully destroy
- **Giant**: 4 (base) + 2(15) = **34 hits** to fully destroy
- **Planet Chunk**: 5 (base) + 2(34) = **73 hits** to fully destroy

*Note: The split entities spawn at the exact position of the parent's destruction and inherit the standard speed for their new tier, immediately continuing along the path.*

---

## 3.2 Asteroid Variants

Variants are modifiers stacked on top of an asteroid's base tier (e.g., a Meteor can be a normal Meteor or a Magnetic Meteor). Variants introduce specific resistances that counter certain ship types, forcing the player to deploy a diversified fleet rather than spamming a single high-tier ship.

*Neutral asteroids dominate early waves. Variants begin appearing in Wave 5 and scale in frequency through Wave 10.*

### Variant Profiles

#### ☄️ Blinding Tail
Streaks a bright, comet-like tail. 
- **Effect**: Standard visual-seeking ships (**Scout, Missile Cruiser, Drone Carrier**) are blinded when this asteroid is within **3 tiles** of them. Blinded ships cease targeting the asteroid completely.
- **Counter**: The **Optical Targeting** upgrade (available on Scouts) restores vision. **Laser Frigates** and **Ion Cannons** utilize optical spectrum/radiation tracking and are unaffected by default.
- **Appears on**: Meteor tier and above.

#### 🪨 Hard Crust
A high-density metamorphic space rock.
- **Effect**: Absorbs all weak shots entirely, taking **0 damage**. Weak shots include those from Scouts, Missile Cruiser splash damage, and Drone Carrier drones.
- **Counter**: **Ion Cannon** (heavy shots), **Laser Frigate** (pierce shots, 2+ tiers), and **Pulse Beam** (kinetic blast).
- **Appears on**: Boulder tier and above.

#### 🧲 Magnetic Core
Generates a powerful, localized magnetic shield.
- **Effect**: Regenerates HP at a rate of **0.5 hits/second**. A single Scout firing at 1.0 shot/s will barely progress past regeneration. If left undamaged for **4.0 seconds**, it fully heals back to its max HP tier.
- **Counter**: Focus-firing multiple ships, high-damage burst (**Ion Cannon**), pierce shots (**Laser Frigate**), or **Pulse Beam** kinetic hits (which disable regeneration for 2.0s).
- **Appears on**: Meteor tier and above.

#### 🪐 Ring Belt
Surrounded by an orbital belt of orbiting sand, gravel, and ice debris.
- **Effect**: Deflects all area-of-effect and splash damage. **Missile Cruiser** splash and **Drone Carrier** drone strikes deal 0 damage.
- **Counter**: Straight-line pierce shots that pass through the belt (**Laser Frigate**), high-speed heavy projectiles (**Ion Cannon**), and point-blank focused direct fire (**Scout**).
- **Appears on**: Giant tier and above.

---

## 3.3 Elemental Asteroid Sub-Types

Ice and Lava are rare elemental subtypes that stack on top of a tier and a variant. They do **not** affect player ships. Instead, they interact dynamically with **Hot Lasers** and **Cold Lasers** (upgrades available on Scouts and Laser Frigates).

*Elemental asteroids begin appearing in Wave 5. Non-laser ships deal standard damage with no special interactions.*

### ❄️ Ice Asteroids
Visually distinguished by a pale blue color and frosted surface cracks.

| Laser Type | Outcome | Name | Mechanic Description |
|------------|---------|------|----------------------|
| **Hot Laser** | Clean Clear | **The Melt** | Intense heat vaporizes the ice instantly. The asteroid takes normal tier damage and experiences standard splitting, but **no elemental debris or special chains occur**. The cleanest, most resource-efficient way to clear Ice. |
| **Cold Laser** | AoE Chain | **The Shatter** | Extreme cold instantly freezes and fractures the crystal structure. The target takes normal tier reduction, then releases a shrapnel burst hitting **all asteroids within 2 tiles for 1 tier of damage**. Shrapnel hits do not chain or trigger secondary shatters. |
| **Neutral Shot** | Standard | — | Regular 1-tier reduction with no special properties. |

### 🌋 Lava Asteroids
Visually distinguished by a glowing orange-red molten crust and flowing surface cracks.

| Laser Type | Outcome | Name | Mechanic Description |
|------------|---------|------|----------------------|
| **Cold Laser** | Type Conversion | **The Solidify** | The cold beam cools the molten exterior, forming a solid basalt shell. **The shot is consumed strictly on conversion (dealing 0 damage)**, and the asteroid turns into a standard neutral rock of the same tier. This neutral rock is now fully vulnerable to Missile Cruiser splash and Drones. |
| **Hot Laser** | AoE Chain | **The Overload** | Injecting thermal energy into a pressurized magma core triggers an explosion. The primary target suffers standard tier reduction, then explodes, **dealing 1 tier of damage to all asteroids within the explosion radius**. The explosion does not chain. |
| **Neutral Shot** | Standard | — | Regular 1-tier reduction with no special properties. |

### Overload Blast Radius by Tier
The explosion size scales with the amount of volcanic fuel stored in the asteroid:

| Tier | Name | Blast Radius |
|------|------|--------------|
| **1 / 2** | Pebble / Boulder | 2.0 tiles |
| **3** | Meteor | 2.5 tiles |
| **4** | Giant | 3.0 tiles |
| **5** | Planet Chunk | 3.5 tiles |
