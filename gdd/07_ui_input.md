# SPACE DEFENDERS
## 07. UI & Input
**Version 0.5 | Prototype Phase**

---

## 7.1 HUD Layout

The game's HUD is permanently visible, framing the game viewport.

```
 ┌────────────────────────────────────────────────────────┐
 │ ❤️ Lives: 20/20          💎 Minerals: 50      🌊 Wave: 3/10 │
 │                                            ⚡ Speed: [1x] │
 │                                                        │
 │                                                        │
 │                                                        │
 │                                                        │
 │ ┌──────────────────────────────────────────────────┐   │
 │ │ 🚀 Scout(20)  Laser(35)  Missile(45)  Pulse(55)...│ 🟢│
 │ └──────────────────────────────────────────────────┘ ╚═╝
 │                  [ Ship Shop Bar ]               [Launch]
 └────────────────────────────────────────────────────────┘
```

### HUD Elements Specifications

- **❤️ Lives Counter** (Top-Left): Displays current/max lives remaining (e.g., `20 / 20`).
- **💎 Mineral Counter** (Top-Center): Displays the player's current mineral balance (e.g., `💎 50`). Updates dynamically on purchases, sales, and Pebble destructions.
- **🌊 Wave Counter** (Top-Right): Displays active wave status (e.g., `Wave 3 / 10`).
- **⚡ Speed Toggle** (Top-Right, below wave): Button to adjust active simulation speed. Cycles between `1x` and `2x` speed.
- **🚀 Ship Shop Bar** (Bottom-Center): Horizontal strip displaying available ships with their mineral prices. Hovering displays basic stats (range, damage, shot type).
- **🟢 Launch Wave Button** (Bottom-Right): Starts the wave. Highlights green when ready, and turns gray/disabled during active wave spawning.

---

## 7.2 Ship Placement Flow

To ensure precise construction, the game features a reactive feedback loop for placing ships:

1. **Selection**: The player clicks on a ship button in the bottom shop bar (or clicks and drags it onto the play area).
2. **Ghost Preview**: The cursor updates to a semi-transparent **ghost preview** of the selected ship sprite. A translucent circular boundary represents its range.
3. **Validation**:
   - Hovering over a valid `BUILDABLE` tile turns the range circle and tile boundaries **green**.
   - Hovering over an invalid `PATH`, `BLOCKED`, or occupied tile turns the boundaries **red**.
4. **Finalization**:
   - **Clicking** a green-highlighted tile deducts minerals and spawns the ship.
   - Pressing **Escape** or **Right-Clicking** cancels placement, returning the cursor to normal.

---

## 7.3 Ship Management Panel

Selecting a placed ship on the grid triggers the **Ship Management Panel**, sliding in from the side or appearing at the bottom.

- **Ship Information**: Displays the ship's name, profile icon, and current attributes (damage, speed, range).
- **🎯 Targeting Priority Dropdown**: Allows players to cycle the ship's targeting mode:
  - `First` (Default)
  - `Last`
  - `Strongest`
  - `Closest`
- **🔄 Reposition Button**: Relocates the ship.
  - Clicking this enters Reposition Mode. The cursor becomes a ghost preview of the ship.
  - Clicking a new buildable tile completes the move, deducting the 15% base cost repositioning fee.
  - Pressing Escape cancels and returns the ship to its original tile.
- **💰 Sell Button**: Sells the ship.
  - Displays the refund amount (70% of total ship value, rounded down).
  - Clicking prompts a short confirmation before removing the ship and adding the minerals to the player's wallet.
- **🔥 Upgrades Selection**: Displays available upgrades, including specialized upgrades like Hot/Cold Lasers and Optical Targeting.

---

## 7.4 Game Speed Control

- **Speed Modifiers**: Supports standard speed (**`1x`**) and turbo speed (**`2x`**).
- **System Impact**: Modifiers scale delta times, increasing asteroid movement, ship recharge, fire rates, and project lifetimes symmetrically. Physics behaviors and tests must remain consistent at both speeds.
- **Availability**: Speed can be toggled at any time.
