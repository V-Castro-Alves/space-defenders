# SPACE DEFENDERS
## 01. Game Overview
**Version 0.5 | Prototype Phase**

---

Space Defenders is a premium, action-tactical tower defense game built in Godot 4. The player deconstructs and destroys incoming waves of asteroids before they can reach the space station at the end of the path. 

Unlike traditional tower defense games where enemies have simple health bars, Space Defenders features a **physics-themed deconstruction system**: **an asteroid's size is its health**. Shooting an asteroid breaks it into smaller fragments, triggering chain reactions and dividing debris that cascades down the path.

---

## The Core Loop

1. **Strategic Setup**: The player analyzes the upcoming wave profile and places spaceships on buildable tiles using minerals in the ship shop.
2. **Dynamic Deployment**: During active waves, the player continues to place, reposition, sell, and upgrade spaceships in real time.
3. **Automated Defense**: Spaceships automatically lock onto and fire at asteroids within their circular ranges, utilizing distinct shot types (weak, heavy, pierce, kinetic, gravitational).
4. **Deconstruction and Collection**: Asteroids break into smaller chunks. The smallest tier (Pebbles) drops valuable minerals upon destruction.
5. **Economy Management**: Collected minerals are immediately reinvested into buying stronger ships, upgrading laser profiles, or moving existing ships to optimize the defensive perimeter.
6. **Wave Control**: After fully clearing a wave, the player gathers a no-leak bonus (if achieved) and manually launches the next wave when ready.

---

## Win & Loss Conditions

- **Win Condition**: Successfully survive and clear all **10 waves** of incoming asteroid clusters and variant behemoths with at least **1 life** remaining.
- **Loss Condition**: Lose all **20 lives**. Lives are depleted when asteroids leak past the final waypoint and strike the space station. Larger asteroid tiers consume larger chunks of lives (equivalent to their total pebble composition).
