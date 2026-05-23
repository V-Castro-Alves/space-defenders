# SPACE DEFENDERS
## 06. Wave System
**Version 0.5 | Prototype Phase**

---

## 6.1 Spawning Rules & Composition

Space Defenders is balanced over a fixed **10-Wave Campaign**. 

- **Spawning Pacing Rule**: Within any individual wave group, asteroids spawn with a **"small clusters first, big finishers last"** structure. This forces the players to deal with swift, splitting groups before handling heavy, slow-moving boss-level threats.
- **Dynamic Speed Scales**: Asteroids spawn at rates determined by the active wave settings.
- **Active State Lock**: Spawning is locked to the wave's preset speed. The HUD's "Launch Wave" button remains disabled until every single asteroid and splitting fragment has been fully neutralized or leaked.

---

## 6.2 The 10-Wave Balance Table

| Wave | Spawn Composition | Spawn Spurt Order | Spawn Interval | Minerals Available (Clear) | Perfect Clear Bonus |
|------|-------------------|-------------------|----------------|---------------------------|---------------------|
| **1** | 10 Pebbles | 10P | 1.0s | 10 Minerals | +5 Minerals |
| **2** | 8 Pebbles + 2 Boulders | 4P → 4P → 2B | 1.0s | 16 Minerals | +10 Minerals |
| **3** | 6 Pebbles + 4 Boulders | 3P → 3P → 2B → 2B | 1.0s | 22 Minerals | +15 Minerals |
| **4** | 10 Boulders | 3B → 3B → 4B | 1.0s | 40 Minerals | +20 Minerals |
| **5** | 6 Boulders + 2 Meteors | 3B → 3B → 2M | 1.0s | 40 Minerals | +25 Minerals |
| **6** | 8 Boulders + 3 Meteors | 4B → 4B → 3M | 0.9s | 56 Minerals | +30 Minerals |
| **7** | 5 Boulders + 5 Meteors | 3B → 2B → 3M → 2M | 0.8s | 60 Minerals | +35 Minerals |
| **8** | 8 Meteors + 1 Giant | 4M → 4M → 1G | 0.8s | 80 Minerals | +40 Minerals |
| **9** | 5 Meteors + 3 Giants | 3M → 2M → 2G → 1G | 0.7s | 88 Minerals | +45 Minerals |
| **10** | 4 Giants + 1 Planet Chunk | 2G → 2G → 1PC | 0.6s | 96 Minerals | +50 Minerals |

*Spawn Legend: **P** = Pebble (T1), **B** = Boulder (T2), **M** = Meteor (T3), **G** = Giant (T4), **PC** = Planet Chunk (T5).*

### Total Income Architecture
- **Cumulative Base Mineral Payout**: **508 Minerals**
- **Perfect Clear (No-Leak) Bonus Potential**: **+275 Minerals**
- **Theoretical Maximum Possible Income**: **783 Minerals**

---

## 6.3 Economy & Purchase Pacing

The game's difficulty scales to require optimized purchases at every stage of the campaign.

```
                  WAVES 1-3                          WAVES 4-6                         WAVES 7-10
             [Tight Early Game]                 [Mid-Game Expansion]                [Late-Game Siege]
           - Start Minerals: 50              - Income: ~40-56 / wave            - Income: ~60-96 / wave
           - Focus: Basic coverage           - Focus: AoE & Upgrades            - Focus: Behemoth counters
           - Recommended: 2x Scouts          - Recommended: Laser Frigate,      - Recommended: Ion Cannons,
                                               Missile Cruiser, Pulse Beams,      Drone Carriers, Gravity Wells,
                                               Hot/Cold Laser Upgrades            Laser Spec Upgrades
```

### Stage Breakdown

#### 1. Waves 1–3: The Starting Squeeze
- **Financial Status**: Extremely tight. Reliance on starting **50 minerals**.
- **Tactical Strategy**: Place basic Scout ships (20 minerals each) near the entry points. Keep a small mineral buffer for early splitting response.

#### 2. Waves 4–6: The Fleet Expands
- **Financial Status**: Moderate. Mineral availability scales to **40–56 minerals** per wave.
- **Tactical Strategy**: Deploy Laser Frigates (35 minerals) and Missile Cruisers (45 minerals) to manage the boulder clusters. Purchase early **Hot/Cold Laser upgrades** on active Scouts to prepare for elemental threats.

#### 3. Waves 7–10: High Orbit Defenses
- **Financial Status**: Flush. Heavy earnings of **60–96 minerals** per wave.
- **Tactical Strategy**: Deploy the ultimate single-target **Ion Cannons** (60 minerals) to break Giants. Build **Gravity Wells** (80 minerals) at the central choke loop. Purchase **Optical Targeting** upgrades on Scouts to counter Blinding Tails.
