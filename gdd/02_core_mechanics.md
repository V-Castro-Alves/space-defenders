# SPACE DEFENDERS
## 02. Core Mechanics
**Version 0.5 | Prototype Phase**

---

This document outlines the high-level game rules governing match state, player survival parameters, the economy currency, and control phases.

---

## 2.1 Lives System

The Lives System represents the player's core health state and determines the defeat condition.

- **Starting Budget**: The player begins the game with **20 lives**.
- **Leak Penalty**: Lives are lost when incoming asteroids successfully reach the end of the path and strike the space station.
- **Scale-based Loss**: Asteroids do not cost a flat 1 life. Instead, their leak penalty is equivalent to their total pebble composition (mass).
  - A leaked **Pebble (Tier 1)** costs **1 life**.
  - A leaked **Boulder (Tier 2)** costs **4 lives**.
  - A leaked **Meteor (Tier 3)** costs **8 lives**.
  - A leaked **Giant (Tier 4)** costs **16 lives**.
  - A leaked **Planet Chunk (Tier 5)** costs **32 lives**.
- **Defeat Condition**: The game immediately terminates in a **Game Over** state if the live counter reaches **0 or below**.

> ⚠️ **Important:** Since the player starts with 20 lives, letting a single Planet Chunk (32 lives) leak through triggers an instant game over. Massive targets must be prioritized aggressively.

---

## 2.2 Economy — Minerals

Minerals represent the sole currency of Space Defenders, governing all ship construction, relocation, and upgrades.

- **Mid-wave drops**: Minerals are harvested dynamically during waves. **1 Pebble fully destroyed = 1 Mineral**.
- **Debris Payouts**: Because larger asteroids split into pebbles, clearing them yields higher total payouts.
  - **Pebble**: 1 mineral
  - **Boulder**: 4 minerals total
  - **Meteor**: 8 minerals total
  - **Giant**: 16 minerals total
  - **Planet Chunk**: 32 minerals total
- **Starting Capital**: The player starts Wave 1 with **50 Minerals**.
- **Global Payout**: The total base minerals available across all 10 waves is **508 Minerals**.
- **No-Leak Wave Bonus**: If a player completes a wave with **zero leaks**, they receive a performance bonus calculated as:
  $$\text{Bonus Minerals} = \text{Wave Number} \times 5$$
  *(For example, finishing Wave 4 perfectly awards a +20 Mineral bonus).*
- **Target Spend**: The player's expected spend across a full run is **300–350 minerals** (~60–70% of total), allowing a buffer for repositioning fees and laser conversions.

---

## 2.3 Wave Control

Wave progression is fully controlled by the player rather than automatic timers.

- **Planning Phase**: Between waves, there is no time limit. The game is in a planning state, allowing the player to place, sell, or reposition ships at leisure.
- **Launch Trigger**: The player manually starts the spawning timeline by pressing the **"Launch Wave"** button in the HUD.
- **Active State Lock**: Once spawned, the Launch Wave button is disabled. It remains locked until every single spawned asteroid and split fragment has been fully cleared or leaked.
- **Speed Toggle**: During active waves, the player can freely toggle the game speed between `1x` and `2x` without affecting wave state locks.
