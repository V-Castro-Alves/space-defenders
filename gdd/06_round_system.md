# SPACE DEFENDERS
## 06. Round System
**Version 0.5 | Prototype Phase**

---

## 6.1 Spawning Rules & Composition

Space Defenders is balanced over a fixed **10-Round Campaign**. 

- **Spawning Pacing Rule**: Within any individual round group, asteroids spawn with a **"small clusters first, big finishers last"** structure. This forces the players to deal with swift, splitting groups before handling heavy, slow-moving boss-level threats.
- **Dynamic Speed Scales**: Asteroids spawn at rates determined by the active round settings.
- **Active State Lock**: Spawning is locked to the round's preset speed. The HUD's "Launch Round" button remains disabled until every single asteroid and splitting fragment has been fully neutralized or leaked.

---

## 6.2 The 10-Round Balance Table

| Round | Spawn Composition | Spawn Spurt Order / Distribution | Spawn Interval | Perfect Clear Bonus |
|------|-------------------|----------------------------------|----------------|---------------------|
| **1** | 30 Pebbles | 30P (Continuous Swarm) | 0.5s | +5 Minerals |
| **2** | 25 Pebbles + 10 Boulders | 2P → 1B (Staggered Swarm) | 0.4s | +10 Minerals |
| **3** | 40 Pebbles + 20 Boulders | 2P → 1B (Heavy Swarm) | 0.4s | +15 Minerals |
| **4** | 35 Boulders | 35B (with Hard Crust armor debut) | 0.3s | +20 Minerals |
| **5** | 20 Boulders + 8 Meteors | 20B → 8M (with Magnetic/Ice/Lava) | 0.3s | +25 Minerals |
| **6** | 40 Boulders + 15 Meteors | 40B → 15M (with Ring Belt/Mixed Swarm) | 0.2s | +30 Minerals |
| **7** | 20 Meteors + 5 Giants | 20M (with Blinding/Elements) → 5G | 0.2s | +35 Minerals |
| **8** | 30 Meteors + 10 Giants | 30M → 10G (Ring Belt/Hard Crust) | 0.2s | +40 Minerals |
| **9** | 15 Giants + 2 Planet Chunks | 15G (Magnetic/Ice) → 2PC (Ring Belt) | 0.1s | +45 Minerals |
| **10** | 10 Giants + 5 Planet Chunks | 10G (Lava) → 5PC (Magnetic/Ice/Ring Belt) | 0.1s | +50 Minerals |

*Spawn Legend: **P** = Pebble (T1), **B** = Boulder (T2), **M** = Meteor (T3), **G** = Giant (T4), **PC** = Planet Chunk (T5).*

### Total Income Architecture
With the High-Stakes Economy overhaul, the player has a massive cascade of mineral drops from splitting asteroid pieces, but must deploy expensive tactical investments. Perfect Clear bonuses offer a substantial incentive for flawless lanes.

---

## 6.3 Economy & Purchase Pacing

The game's high-stakes economy is balanced around tactical investments:

```
                  ROUNDS 1-3                          ROUNDS 4-6                         ROUNDS 7-10
             [Opening Setup Phase]               [Mid-Game Expansion]                [Late-Game Siege]
           - Start Minerals: 200             - Income: Swarm payouts            - Income: Behemoth payouts
           - Focus: Basic choke coverage     - Focus: AoE & Upgrades            - Focus: Behemoth counters
           - Recommended: 2x Scouts          - Recommended: Laser Frigate,      - Recommended: Ion Cannons,
             or 1x Laser Frigate               Missile Cruiser, Pulse Beams,      Drone Carriers, Gravity Wells,
                                               Hot/Cold Laser Upgrades            Laser Spec Upgrades
```

### Stage Breakdown

#### 1. Rounds 1–3: The Opening Setup
- **Financial Status**: Starting capital of **200 minerals**.
- **Tactical Strategy**: Relies on placing high-value investments (e.g. Laser Frigates for 150 minerals, or Scouts for 75 minerals). Build early coverage near the entry/U-turn corridors to handle the swift Pebble cascades.

#### 2. Rounds 4–6: The Fleet Expands
- **Financial Status**: Strong. Swarm clear rates yield high payouts from boulder splits.
- **Tactical Strategy**: Deploy Missile Cruisers (220 minerals) and Pulse Beams (300 minerals) to handle high-density armored swarms. Purchase **Hot/Cold Laser upgrades** on active Scouts to prepare for elemental threats.

#### 3. Rounds 7–10: High Orbit Defenses
- **Financial Status**: Peak economy. Large mineral cascades.
- **Tactical Strategy**: Deploy the ultimate single-target **Ion Cannons** (450 minerals) to melt Giants. Build **Gravity Wells** (600 minerals) at corridor bends. Purchase **Optical Targeting** upgrades on Scouts to counter Blinding Tails.
