extends Node

var playthrough_start_time: float = 0.0
var round_metrics: Array = [] # List of dictionaries

# Tower statistics: { type: { "placed": int, "sold": int, "damage": int, "kills": int } }
var tower_stats: Dictionary = {}

# Elemental reactions: { "Shatter": int, "Melt": int, "Solidify": int, "Overload": int }
var reaction_stats: Dictionary = {
	"Shatter": 0,
	"Melt": 0,
	"Solidify": 0,
	"Overload": 0
}

# Current round logging helper
var current_round_start_time: float = 0.0
var current_round_start_minerals: int = 0
var current_round_placements_cost: int = 0

var ship_types: Array = ["Scout", "Laser Frigate", "Missile Cruiser", "Pulse Beam", "Ion Cannon", "Drone Carrier", "Gravity Well"]

func _ready():
	reset_metrics()

func reset_metrics():
	playthrough_start_time = Time.get_unix_time_from_system()
	round_metrics.clear()
	tower_stats.clear()
	for type in ship_types:
		tower_stats[type] = {
			"placed": 0,
			"sold": 0,
			"damage": 0,
			"kills": 0
		}
	reaction_stats = {
		"Shatter": 0,
		"Melt": 0,
		"Solidify": 0,
		"Overload": 0
	}
	current_round_start_time = 0.0
	current_round_start_minerals = 0
	current_round_placements_cost = 0

func start_round(round_num: int):
	current_round_start_time = Time.get_unix_time_from_system()
	current_round_start_minerals = EconomyManager.minerals
	current_round_placements_cost = 0

func end_round(round_num: int, leaks: int):
	var elapsed = Time.get_unix_time_from_system() - current_round_start_time
	var ending_minerals = EconomyManager.minerals
	
	var round_data = {
		"round_number": round_num,
		"clear_time_seconds": elapsed,
		"starting_minerals": current_round_start_minerals,
		"ending_minerals": ending_minerals,
		"spent_this_round": current_round_placements_cost,
		"lives_remaining": GameManager.lives,
		"leaks_this_round": leaks
	}
	round_metrics.append(round_data)

func record_tower_placement(type: String, cost: int):
	if tower_stats.has(type):
		tower_stats[type]["placed"] += 1
	current_round_placements_cost += cost

func record_tower_sell(type: String):
	if tower_stats.has(type):
		tower_stats[type]["sold"] += 1

func record_damage(type: String, amount: int):
	if tower_stats.has(type):
		tower_stats[type]["damage"] += amount

func record_kill(type: String):
	if tower_stats.has(type):
		tower_stats[type]["kills"] += 1

func record_reaction(reaction_type: String):
	if reaction_stats.has(reaction_type):
		reaction_stats[reaction_type] += 1

func save_playthrough_report():
	# Ensure the directory exists
	var dir = DirAccess.open("res://")
	if dir and not dir.dir_exists("res://metrics"):
		dir.make_dir("res://metrics")
		
	# Timestamp formatting
	var datetime = Time.get_datetime_dict_from_system()
	var timestamp = "%04d%02d%02d_%02d%02d%02d" % [
		datetime["year"], datetime["month"], datetime["day"],
		datetime["hour"], datetime["minute"], datetime["second"]
	]
	
	# 1. Save JSON Report
	var json_data = {
		"timestamp": timestamp,
		"total_play_time_seconds": Time.get_unix_time_from_system() - playthrough_start_time,
		"victory": GameManager.current_phase == GameManager.GamePhase.GAME_WON,
		"starting_capital": 200,
		"rounds_summary": round_metrics,
		"tower_efficiencies": tower_stats,
		"elemental_reactions": reaction_stats
	}
	
	var json_path = "res://metrics/playthrough_report_" + timestamp + ".json"
	var file = FileAccess.open(json_path, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(json_data, "\t"))
		file.close()
		
	# 2. Save Markdown Report
	var md_path = "res://metrics/playthrough_report_" + timestamp + ".md"
	var md_file = FileAccess.open(md_path, FileAccess.WRITE)
	if md_file:
		var md_content = generate_markdown_report(json_data)
		md_file.store_string(md_content)
		md_file.close()

func generate_markdown_report(data: Dictionary) -> String:
	var result = "# 📊 Playthrough Telemetry & Balance Report\n\n"
	result += "Generated: `%s`  \n" % data["timestamp"]
	result += "Outcome: **%s**  \n" % ("VICTORY (All 10 Rounds Cleared) ✅" if data["victory"] else "DEFEAT (Space Station Lost) ❌")
	result += "Total Playtime: `%d seconds`  \n\n" % data["total_play_time_seconds"]
	
	result += "## 🏁 Round-by-Round Breakdown\n\n"
	result += "| Round | Clear Time (s) | Start Minerals | End Minerals | Spent (💎) | Lives | Leaks |\n"
	result += "|---|---|---|---|---|---|---|\n"
	for r in data["rounds_summary"]:
		result += "| %d | %.1f | %d | %d | %d | %d | %d |\n" % [
			r["round_number"], r["clear_time_seconds"],
			r["starting_minerals"], r["ending_minerals"],
			r["spent_this_round"], r["lives_remaining"], r["leaks_this_round"]
		]
		
	result += "\n## 🚀 Starfleet Tower Combat Efficiencies\n\n"
	result += "| Tower Class | Placed | Sold | Total Damage Dealt | Lethal Kills |\n"
	result += "|---|---|---|---|---|\n"
	for t in ship_types:
		var stat = data["tower_efficiencies"][t]
		result += "| %s | %d | %d | %d | %d |\n" % [
			t, stat["placed"], stat["sold"], stat["damage"], stat["kills"]
		]
		
	result += "\n## 🌀 Elemental Reactions Triggered\n\n"
	result += "| Reaction Type | Occurrences |\n"
	result += "|---|---|\n"
	for reaction in data["elemental_reactions"].keys():
		result += "| %s | %d |\n" % [reaction, data["elemental_reactions"][reaction]]
		
	result += "\n---\n*Space Defenders Telemetry Engine - Data Logged for Balance Optimization.* 🌌"
	return result
