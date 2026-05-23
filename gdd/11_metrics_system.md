# GDD v0.5 v3: Automated Playthrough Metrics Engine

To facilitate precise game balancing, difficulty pacing analysis, and strategic validation, the Space Defenders core is equipped with an automated **Telemetry & Playthrough Metrics Logging Engine**. 

Every playthrough dynamically compiles performance records, and saves structured data at the end of the session.

---

## 📊 Telemetry Data Model

The metrics engine aggregates three distinct vectors of telemetry data:

### 1. Round-by-Round Breakdown
For every individual round, the engine registers:
- `round_number` (int): Identifies the round index (1 to 10).
- `clear_time_seconds` (float): Duration from clicking the "START ROUND" button to the death of the final spawned fragment.
- `starting_minerals` (int): Minerals in bank at round start (helps track saving/purchasing timing).
- `ending_minerals` (int): Minerals in bank at round clear.
- `spent_this_round` (int): Total minerals spent on new tower placements and upgrades during this round's span.
- `lives_remaining` (int): Core Space Station health remaining at round clear.
- `leaks_this_round` (int): Count of asteroids that breached the perimeter.

### 2. Tower Combat Efficiencies
Tracks tactical investments per Starship Class (`Scout`, `Frigate`, etc.) across the full playthrough:
- `placed` (int): Total times this tower type was purchased and built.
- `sold` (int): Total times this tower type was dismantled for a 70% refund.
- `damage` (int): Total integer damage hits registered on asteroids (tracks upgrade thermal and pierce output accurately).
- `kills` (int): Total lethal blows dealt (final splitting hits).

### 3. Elemental Combat Chemistry
Logs total instances of reactions triggered:
- `Shatter` (Ice + Cold Laser / Kinetic)
- `Melt` (Ice + Hot Laser)
- `Solidify` (Lava + Cold Laser)
- `Overload` (Lava + Hot Laser)

---

## 💾 Storage & Serialization

Whenever the playthrough ends in either **Victory** (`current_phase == GamePhase.GAME_WON`) or **Defeat** (`current_phase == GamePhase.GAME_OVER`), the engine creates a directory at `res://metrics/` and serializes two reports:

### 1. Structured JSON Report
**File Path**: `res://metrics/playthrough_report_YYYYMMDD_HHMMSS.json`  
Designed for automated analytical processing, graphing, and spreadsheet import:
```json
{
	"timestamp": "20260523_192530",
	"total_play_time_seconds": 320,
	"victory": true,
	"starting_capital": 200,
	"rounds_summary": [
		{
			"round_number": 1,
			"clear_time_seconds": 18.5,
			"starting_minerals": 200,
			"ending_minerals": 85,
			"spent_this_round": 150,
			"lives_remaining": 20,
			"leaks_this_round": 0
		}
	],
	"tower_efficiencies": {
		"Scout": {
			"placed": 2,
			"sold": 0,
			"damage": 84,
			"kills": 30
		}
	},
	"elemental_reactions": {
		"Shatter": 0,
		"Melt": 0,
		"Solidify": 0,
		"Overload": 0
	}
}
```

### 2. Markdown Performance Report
**File Path**: `res://metrics/playthrough_report_YYYYMMDD_HHMMSS.md`  
Designed for direct human inspection inside any text editor. Renders clean, tabular summaries of round clear pacing, tower purchase/refund ratios, and weapon damage outputs.
