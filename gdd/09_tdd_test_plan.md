# SPACE DEFENDERS
## 09. TDD Test Plan
**Version 0.5 | Prototype Phase**

---

This document outlines the Test-Driven Development (TDD) plan for Space Defenders, using the **GUT (Godot Unit Test)** framework. Tests are structured into individual suites to verify mechanics in isolation before running integration tests.

---

## 9.1 Unit Tests

### 🧪 `test_asteroid_splitting.gd` (Asteroid Division & Core HP Physics)
- [ ] Hitting a Pebble (1 hit) destroys it and emits the `asteroid_destroyed` signal.
- [ ] Hitting a Boulder (requires 2 hits) reduces it to 0 HP, then splits it into 2 Pebbles.
- [ ] Hitting a Meteor (requires 3 hits) reduces it to 0 HP, then splits it into 2 Boulders.
- [ ] Hitting a Giant (requires 4 hits) reduces it to 0 HP, then splits it into 2 Meteors.
- [ ] Hitting a Planet Chunk (requires 5 hits) reduces it to 0 HP, then splits it into 2 Giants.
- [ ] Split asteroids inherit the correct speed for their tier (e.g., Pebbles move at 180 px/s, Boulders at 130 px/s).
- [ ] Split asteroids continue along the path starting from their parent's exact position at the moment of splitting.
- [ ] A Magnetic Core asteroid regenerates HP at a rate of 0.5 hits/second between hits.
- [ ] A Magnetic Core asteroid fully restores its health to max after 4.0 seconds of taking no damage.

### 🧪 `test_asteroid_variants.gd` (Resistance Mechanics)
- [ ] A Hard Crust asteroid takes full damage from pierce shots (Laser Frigate).
- [ ] A Hard Crust asteroid takes full damage from heavy shots (Ion Cannon).
- [ ] A Hard Crust asteroid takes 0 damage from weak shots (Scout, Missile Cruiser, Drone Carrier).
- [ ] A Ring Belt asteroid takes 0 damage from splash/AoE shots (Missile Cruiser splash).
- [ ] A Ring Belt asteroid takes 0 damage from drone shots.
- [ ] A Ring Belt asteroid takes full damage from pierce shots (Laser Frigate).
- [ ] A Ring Belt asteroid takes full damage from direct shots (Scout, Ion Cannon).
- [ ] A Blinding Tail asteroid prevents standard ships (Scout, Missile Cruiser, Drone Carrier) from targeting it when within 3 tiles.
- [ ] A Blinding Tail asteroid does not affect targeting systems of Laser Frigates or Ion Cannons.
- [ ] A Scout equipped with the **Optical Targeting** upgrade targets a Blinding Tail asteroid normally.

### 🧪 `test_elemental_interactions.gd` (Thermal & Crystallization Reactions)
- [ ] A Hot Laser hitting an Ice asteroid causes a clean clear (standard tier damage, no chains or special debris).
- [ ] A Cold Laser hitting an Ice asteroid triggers **The Shatter** (standard damage to target + 1 tier of damage to all asteroids within 2 tiles).
- [ ] Cold Laser shrapnel hits from a Shatter do not trigger secondary shatters on other Ice asteroids.
- [ ] A Cold Laser hitting a Lava asteroid triggers **The Solidify** (0 damage, converts the Lava asteroid into a standard neutral rock of the same tier).
- [ ] A Hot Laser hitting a Lava asteroid triggers **The Overload** (standard damage + a massive explosion dealing 1 tier of damage to all asteroids within its blast radius).
- [ ] An Overload explosion deals damage but does not cause chained explosions on other Lava asteroids.
- [ ] The Overload blast radius scales correctly by tier: 2.0 tiles for Pebble/Boulder, 2.5 tiles for Meteor, 3.0 tiles for Giant, 3.5 tiles for Planet Chunk.
- [ ] A neutral/non-laser shot on an Ice or Lava asteroid deals standard 1-tier damage with no special thermal effects.
- [ ] Non-laser ships (Missile Cruiser, Ion Cannon, Drone Carrier) deal standard damage to elemental asteroids with no special reactions.

### 🧪 `test_economy.gd` (Minerals, Refunds, & Bonuses)
- [ ] The player starts the game with exactly **50 minerals**.
- [ ] Destroying a Pebble adds exactly **1 mineral** to the player's wallet.
- [ ] Destroying a Boulder fully (clearing all splits) awards exactly **4 minerals** total.
- [ ] Placing a Scout deducts exactly **20 minerals**.
- [ ] Placing a ship is prevented if the player's mineral balance is insufficient.
- [ ] Selling a Scout with no upgrades returns exactly **14 minerals** (70% of 20, rounded down).
- [ ] Selling a Scout with 20 minerals in upgrades purchased returns exactly **28 minerals** (70% of 40).
- [ ] Repositioning a Scout costs exactly **3 minerals** (15% of 20, rounded up).
- [ ] Perfect Wave Clear (no-leak) bonus on Wave 4 awards exactly **20 minerals**.
- [ ] Perfect Wave Clear (no-leak) bonus on Wave 10 awards exactly **50 minerals**.

### 🧪 `test_targeting.gd` (Target Selection Logic)
- [ ] Ships set to **First** target the asteroid with the highest path progress.
- [ ] Ships set to **Last** target the asteroid with the lowest path progress.
- [ ] Ships set to **Strongest** target the asteroid with the highest tier in range.
- [ ] Ships set to **Closest** target the asteroid physically nearest to the ship.
- [ ] Ship targeting systems ignore all asteroids outside their range circle.
- [ ] Targeting updates instantly when the currently locked target leaves the range circle.
- [ ] Ships do not fire when their range circle is completely empty.
- [ ] Drone Carrier assigns each of its 3 drones to a **different** target; no two drones share a target in range.
- [ ] Drone Carrier drones ignore and do not fire at asteroids of Meteor tier (tier 3) or above.

### 🧪 `test_pulse_beam.gd` (Rotational Cone Mechanics)
- [ ] A Pulse Beam's cone burst deals 1 tier of damage to all asteroids within 3.5 tiles and inside its 90° arc simultaneously.
- [ ] The cone burst does not damage asteroids outside the 90° arc, even if they are within the 3.5-tile range.
- [ ] The cone automatically sweeps and rotates to face the densest cluster of asteroids before firing.
- [ ] The Pulse Beam's kinetic blast breaks Hard Crust, dealing full damage.
- [ ] The Pulse Beam's kinetic blast is blocked by Ring Belts, dealing 0 damage.
- [ ] The Pulse Beam's kinetic blast on a Magnetic Core asteroid pauses its regeneration for exactly **2.0 seconds**.
- [ ] Magnetic Core regeneration resumes normally after the 2.0-second kinetic pause expires.
- [ ] The Pulse Beam targets and fires at Blinding Tail asteroids normally with no targeting penalty.
- [ ] A kinetic blast hitting an Ice asteroid deals standard damage + a mini shrapnel burst within a **1.0-tile radius** (1 tier of damage, smaller than the Cold Laser Shatter).
- [ ] A kinetic blast hitting a Lava asteroid deals standard damage + a mini pressure-release explosion within a **1.0-tile radius** (1 tier of damage, smaller than the Hot Laser Overload).

### 🧪 `test_gravity_well.gd` (Gravitational Physics & Freeze Fields)
- [ ] The Gravity Well freezes all asteroids inside its range circle on activation.
- [ ] The freeze duration scales by tier: Pebbles (4.0s), Boulders (3.0s), Meteors (2.0s), Giants (1.5s), Planet Chunks (1.0s).
- [ ] Frozen asteroids resume normal movement as soon as their individual freeze timers expire.
- [ ] In a mixed wave, each frozen asteroid thaws independently at its own tier-based time.
- [ ] The Gravity Well deals **0 damage** to all targets.
- [ ] The Gravity Well enters a **6.0-second recharge** after firing, during which it is completely inactive.
- [ ] The gravitational freeze bypasses Hard Crust and freezes targets normally.
- [ ] The gravitational freeze bypasses Ring Belts and freezes targets normally.
- [ ] A Magnetic Core asteroid has its regeneration rate halved to **0.25 HP/s** while frozen by the Gravity Well.
- [ ] A Blinding Tail asteroid is frozen normally. Other ships still cannot target it unless equipped with Optical Targeting.

### 🧪 `test_wave_manager.gd` (Cohort Timeline Control)
- [ ] Wave 1 spawns exactly 10 Pebbles at 1.0-second intervals.
- [ ] Wave 2 spawns 8 Pebbles, then 2 Boulders (small first, big last) at 1.0-second intervals.
- [ ] Wave 10 spawns Giants before spawning the Planet Chunk.
- [ ] Spawner intervals match wave-specific speeds (0.6s to 1.0s).
- [ ] The `wave_completed` signal is emitted only after all spawned asteroids and split fragments are cleared.
- [ ] The `wave_completed` signal's payload contains the correct `no_leak` boolean value.
- [ ] The Launch Wave button is re-enabled in the HUD as soon as a wave is fully cleared.

---

## 9.2 Integration Tests

### 🧪 `test_wave_run.gd` (Active Simulation Loop)
- [ ] **Perfect Wave 1 Simulation**: Spawns and destroys 10 Pebbles. Awards 10 minerals mid-wave + a perfect clear bonus. Fires `wave_completed(1, true)`.
- [ ] **Wave 1 Leak Simulation**: Spawns 10 Pebbles. 9 are destroyed, 1 leaks. Lives decrease by 1, wave completes, and no bonus minerals are awarded. Fires `wave_completed(1, false)`.
- [ ] **Perfect Wave 4 Simulation**: Spawns and destroys 10 Boulders. Awards exactly 40 minerals total upon full cleanup.
- [ ] **Planet Chunk Leak Simulation (Wave 10)**: Allowing a Planet Chunk to leak reduces lives by 32, triggering a `game_over` state (since 32 lives lost > 20 starting lives).

### 🧪 `test_full_game.gd` (Campaign Run)
- [ ] Completing all 10 waves with at least 1 life remaining triggers the `game_won` signal.
- [ ] Lives reaching 0 mid-wave halts spawning and triggers the `game_over` signal.
- [ ] A perfect campaign (completing all 10 waves with zero leaks) awards exactly **783 minerals** total (508 base + 275 bonus minerals).
