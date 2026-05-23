# SPACE DEFENDERS
## 04. Spaceships & Towers
**Version 0.5 | Prototype Phase**

---

## 4.1 Placement Rules

- Ships are placed **freely** on any buildable grid tile.
- **Placement Flow**: Click a ship in the HUD shop bar (or click-and-drag it) → a ghost preview showing the ship and its circular range boundaries follows the cursor → hover over a tile → click to place.
- **Visual Feedback**: Buildable tiles highlight **green** under the preview. Invalid tiles (path tiles, occupied tiles, out-of-bounds) highlight **red**.
- Range boundaries are drawn as a clean, translucent range circle whenever a placed ship is hovered over or selected.
- Ship placement can be canceled at any time by pressing **Escape** or right-clicking.

---

## 4.2 Repositioning

Placed ships can be dynamically relocated to any valid tile at any time.

- **Cost**: **15% of the ship's base cost** (rounded up, upgrade costs are not included in this calculation).
- Repositioning is fully available during waves as well as during planning phases.

### Repositioning Fee Sheet

| Ship Type | Base Cost | Reposition Fee (15% Ceil) |
|-----------|-----------|---------------------------|
| **Scout** | 20 | 3 minerals |
| **Laser Frigate** | 35 | 6 minerals |
| **Missile Cruiser** | 45 | 7 minerals |
| **Pulse Beam** | 55 | 9 minerals |
| **Ion Cannon** | 60 | 9 minerals |
| **Drone Carrier** | 75 | 12 minerals |
| **Gravity Well** | 80 | 12 minerals |

---

## 4.3 Selling

- Clicking a placed ship opens its **Ship Management Panel**.
- Pressing the **Sell** button yields a refund equal to **70% of total ship value** (base cost + all purchased upgrades), rounded down.
- Selling can be performed during active waves or planning phases.

---

## 4.4 Targeting Modes

Each active offensive ship can be configured to one of four targeting priorities via its dropdown menu.

| Targeting Mode | Selection Behavior | Strategic Use Case |
|----------------|--------------------|---------------------|
| 🎯 **First** | Targets the asteroid with the highest path progress (closest to exit). | Prevent leaks; default fallback mode. |
| 🔄 **Last** | Targets the asteroid with the lowest path progress (closest to entry). | Cleaning up lagging stragglers. |
| 💪 **Strongest** | Targets the highest asteroid tier currently in range. | Bursting massive threats down first. |
| 📍 **Closest** | Targets the asteroid nearest to the ship's physical position. | Maximizing DPS; reduces projectile travel time. |

---

## 4.5 Ship Registry

### Shot Type Classifications
- **Weak Shot**: Scout, Missile Cruiser splash, Drone Carrier drones. Blocked by Hard Crust and Ring Belt.
- **Pierce Shot**: Laser Frigate. Penetrates Ring Belt; breaks Hard Crust.
- **Heavy Shot**: Ion Cannon. Breaks Hard Crust; ignores Blinding Tail; outruns Magnetic Core regeneration.
- **Kinetic Blast**: Pulse Beam. Breaks Hard Crust; blocked by Ring Belt; pauses Magnetic Core regeneration; triggers mini elementals.
- **Gravitational Field**: Gravity Well. Freeze effect; bypasses Ring Belt and Hard Crust; halves Magnetic Core regeneration.

### Ship Balance Matrix

| Ship | Cost | Range (tiles) | Damage | Fire Rate | Shot Type | Special / Role |
|------|------|---------------|--------|-----------|-----------|----------------|
| **Scout** | 20 | 2.0 | 1 tier / shot | 1.0 shot/s | Weak | Cheap early defense. Upgradable to Hot/Cold Lasers and Optical Targeting. |
| **Laser Frigate** | 35 | 5.0 | 2 tiers / shot | 1.0 shot/s | Pierce | Pierces all path targets in a straight line. Immune to Blinding Tail. Upgradable to Hot/Cold Lasers. |
| **Missile Cruiser** | 45 | 4.0 | 1 tier + splash | 0.8 shot/s | Weak | 1.5 tile splash damage radius. Blocked by Ring Belt and Hard Crust. |
| **Ion Cannon** | 60 | 5.0 | 3 tiers / shot | 0.5 shot/s | Heavy | Ultimate single-target chunk killer. Breaks Hard Crust. Immune to Blinding Tail. |
| **Drone Carrier** | 75 | 4.0 | 1 tier / drone | 0.8 shot/s per drone | Weak | Spawns 3 orbiting drones that independently target separate asteroids. Drones deal 0 damage on Meteor tier and above. |
| **Pulse Beam** | 55 | 3.5 | 1 tier in cone | 0.5 shot/s | Kinetic | 90° cone blast. Auto-rotates to target the densest cluster. Breaks Hard Crust. Pauses Magnetic regen. |
| **Gravity Well** | 80 | 4.0 | 0 (No damage) | 6s recharge | Gravitational | Fires a field that freezes all asteroids in range. Freeze duration scales inverse to asteroid mass. Support ship. |

---

### Detailed Operational Rules

#### 🐝 Drone Carrier Rules
- Spawns **3 independent drones** that hover around the carrier.
- **Target Distribution**: Each drone automatically selects a **different** target inside the carrier's range circle. No two drones will focus on the same target simultaneously.
- **Armor Lockout**: Drones fire weak shots. In addition to being blocked by Hard Crust and Ring Belt variants, **drones deal 0 damage to any base asteroid of Meteor tier (tier 3) or above** due to natural crust density.
- **Strategic Placement**: Best deployed near the exit of paths to clean up small, split Pebbles/Boulders that survived heavy ships.

#### 📐 Pulse Beam Rules
- Fires a **90° cone burst** dealing 1 tier of damage to every single asteroid inside the arc simultaneously.
- **Auto-Rotation**: Before firing, the cone automatically sweeps and rotates to face the **densest cluster of asteroids** currently in range.
- **Locked Blast**: Once the rotation locks and the weapon fires, the blast path is fixed. Asteroids moving into the arc mid-burst are unaffected; asteroids moving out are also unaffected once registered.
- Uses a **2.0s recharge** cycle (0.5 shots/second). Excellent against clustered swarms; weaker against isolated targets.

#### 🕳️ Gravity Well Rules
- Support-class vessel with **zero damage output**.
- On cycle completion, pulses a gravitational field that freezes **all asteroids in range simultaneously** in their current position.
- **Mass-scaled Duration**: Freeze duration is determined entirely by an asteroid's tier (mass). The quantity of asteroids does not dilute the freeze duration.
- During the freeze, target asteroids are stationary, allowing all other ships in range to fire with maximum accuracy.
- Enters a strict **6.0-second recharge** after firing, during which it is completely inactive.

**Freeze Duration Formula**:
$$\text{Freeze Duration} = \frac{\text{Base Freeze (2.0s)}}{\text{Tier Weight}}$$

*Tier Weights reflect physical mass (Newton's Second Law): Pebble (0.5), Boulder (0.75), Meteor (1.0), Giant (1.5), Planet Chunk (2.5).*

| Tier | Asteroid Name | Mass Weight | Final Freeze Duration |
|------|---------------|-------------|-----------------------|
| **1** | Pebble | 0.50 | **4.0 seconds** |
| **2** | Boulder | 0.75 | **3.0 seconds** |
| **3** | Meteor | 1.00 | **2.0 seconds** |
| **4** | Giant | 1.50 | **1.5 seconds** |
| **5** | Planet Chunk | 2.50 | **1.0 second** |

*In a mixed cluster, each asteroid thaws at its own individual time based on its tier.*

---

## 4.6 Upgrades

- Players click on a placed ship to access its upgrade tree inside the Management Panel, using Minerals.
- Purchased upgrades add to the ship's cumulative net worth for sell calculations.
- *Full upgrade trees are scheduled for Phase 4.*

---

## 4.7 Hot / Cold Laser Upgrades

Scouts and Laser Frigates can purchase a specialized laser upgrade path. This is a **permanent, per-ship choice** made via the panel (cannot be swapped; requires selling and rebuilding).

*Only Scouts and Laser Frigates are eligible (projectile, missile, kinetic, and gravitational ships are excluded).*

| Laser Upgrade | Neutral Target | ❄️ Ice Asteroids | 🌋 Lava Asteroids |
|---------------|----------------|------------------|-------------------|
| 🔥 **Hot Laser** | Normal damage | **The Melt**: Clean tier reduction; no chains/debris. | **The Overload**: Normal damage + massive fiery explosion (AoE). |
| ❄️ **Cold Laser** | Normal damage | **The Shatter**: Normal damage + 2-tile shrapnel burst (AoE). | **The Solidify**: Molten exterior cools. 0 damage; converts to neutral rock. |
| 🚫 **No Laser Upgrade** | Normal damage | Normal damage; no special effects. | Normal damage; no special effects. |

---

## 4.8 Kinetic Blast Interactions (Pulse Beam)

The Pulse Beam's kinetic blast interacts uniquely with variants and elementals, providing a middle-ground physical impact.

### Variant Interactions

| Variant | Kinetic Blast Interaction | Physical Explanation |
|---------|---------------------------|----------------------|
| **Hard Crust** | ✅ **Full Damage** | Shearing physical force shatters high-density rock. |
| **Ring Belt** | ❌ **Blocked (0 Damage)** | Orbiting debris dispersion absorbs and diffuses kinetic energy. |
| **Magnetic Core** | ✅ **Damage + 2s Regen Pause** | Impact shock waves disrupt the local magnetic field briefly. |
| **Blinding Tail** | ✅ **Unaffected** | Operates via spatial density scanning, not optical tracking. |

### Elemental Interactions

- **Ice Asteroids**: Triggers a **Mini-Shatter**. Normal 1-tier damage to the target + a small shrapnel burst hitting adjacent asteroids in a **1.0-tile radius** for 1 tier of damage (smaller than the cold laser's 2.0-tile radius).
- **Lava Asteroids**: Triggers a **Mini-Overload**. Normal 1-tier damage + a pressure-release explosion hitting adjacent asteroids in a **1.0-tile radius** for 1 tier of damage (smaller than the hot laser's 2.0–3.5 tile radius).

---

## 4.9 Gravity Well Variant Interactions

The Gravity Well manipulates gravity directly rather than launching projectiles. It is unaffected by typical physical blockages.

| Variant | Gravity Well Interaction | Functional Behavior |
|---------|--------------------------|---------------------|
| **Hard Crust** | ✅ **Bypassed** | Gravitational forces act on mass; dense shells do not block gravity. |
| **Ring Belt** | ✅ **Bypassed** | Orbiting dust and rocks are pulled along with the core; no deflection. |
| **Magnetic Core** | ✅ **Regen Halved** | The gravity field warps electromagnetic flows, **halving regeneration to 0.25 HP/s** while frozen. |
| **Blinding Tail** | ✅ **Bypassed** | Targets mass signatures, bypassing blinding tails. *Note: Other ships still cannot target the frozen Blinding Tail without Optical Targeting.* |
