# SPACE DEFENDERS
## 10. Roadmap & Questions
**Version 0.5 | Prototype Phase**

---

## 10.1 Development Roadmap

The development of Space Defenders is structured into seven distinct phases to ensure systems are fully verified before proceeding.

```
┌─────────────────────────────────────────────────────────────────────────┐
│ PHASE 1: Game Design Spec (Modular GDD)                           [✅]  │
├─────────────────────────────────────────────────────────────────────────┤
│ PHASE 2: Godot 4 Prototype (Basic map, spawner, Scout, Pebble)    [⏳]  │
├─────────────────────────────────────────────────────────────────────────┤
│ PHASE 3: Core Systems (All ships/tiers, economy, waves, GUT tests)[⏳]  │
├─────────────────────────────────────────────────────────────────────────┤
│ PHASE 4: Content Balancing (Upgrade trees, laser pricing, tuning) [⏳]  │
├─────────────────────────────────────────────────────────────────────────┤
│ PHASE 5: Art & SFX Polish (VFX, sprites, audio, UI transitions)   [⏳]  │
├─────────────────────────────────────────────────────────────────────────┤
│ PHASE 6: Playtesting & Balancing                                  [⏳]  │
├─────────────────────────────────────────────────────────────────────────┤
│ PHASE 7: Gold Release (Deployment and exports)                    [⏳]  │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## 10.2 Open Questions & TBD Parameters

These items are currently open and scheduled to be resolved in upcoming development phases.

| Subsystem | Open Question / Parameter | Target Resolution Phase |
|-----------|---------------------------|-------------------------|
| 🗺️ **Map** | Exact grid waypoint coordinates array for the Z-path loop. | **Phase 2** (Prototype) |
| 🗺️ **Map** | Final dimensions of buildable vs blocked background tiles in the editor. | **Phase 2** (Prototype) |
| 🛸 **Ships** | Design and pricing of full upgrade trees for the 7 ship types. | **Phase 4** (Content) |
| 🛸 **Ships** | Mineral cost for Hot and Cold laser upgrades. | **Phase 4** (Content) |
| 🛸 **Ships** | Mineral cost for the Scout's Optical Targeting upgrade. | **Phase 4** (Content) |
| 🛸 **Ships** | Projectile speed parameters for Scout, Missile, and Ion Cannons. | **Phase 3** (Core) |
| 🛸 **Ships** | Minimum buffer distance rules (can ships be built directly adjacent?). | **Phase 3** (Core) |
| 🛸 **Ships** | Gravity Well recharge HUD display (should the timer be visible on the ship?). | **Phase 3** (Core) |
| 🛸 **Ships** | Pulse Beam targeting preview (should the cone direction show on selection?). | **Phase 3** (Core) |
| 🌊 **Waves** | Precise delay timings between different spawn cohorts vs intra-cohort intervals. | **Phase 3** (Core) |
| 🌊 **Waves** | Variant and elemental spawning percentages per wave (exact spawn chances). | **Phase 4** (Content) |
| ☄️ **Variants** | Visual designs and shaders for variants (comet tail VFX, ring belt sprites). | **Phase 5** (Art) |
| ❄️ **Elementals**| Ice shrapnel burst visual effects (does it affect ships visually?). | **Phase 5** (Art) |

---

## 10.3 Future Scope & Expansion Ideas

The following concepts are planned for post-prototype development:

- **Additional Maps**: Interactive environmental hazards (e.g., black holes that warp projectiles, solar storms that temporarily disable ships).
- **Special Wave Types**:
  - **Comet Showers**: Ultra-fast, low-HP streaks that bypass standard path targeting.
  - **Asteroid Belts**: Inundations of small debris that swarm and overwhelm single-target setups.
  - **Boss Behemoths**: Asteroids with unique behaviors, such as spawning smaller asteroids as shields or split-immune structures.
- **Advanced Upgrade Systems**: Hybrid laser setups, drone modifications (e.g., repair drones, shield disruptors), and defensive shield grids for buildable zones.
