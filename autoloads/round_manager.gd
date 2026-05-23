extends Node

signal round_changed(current_round)
signal round_started(current_round)
signal round_completed(current_round, no_leak)

const TOTAL_ROUNDS: int = 10

var current_round: int = 0 : set = set_round
var round_active: bool = false
var spawn_timer: Timer
var spawn_list: Array = []
var spawn_interval: float = 1.0

var active_asteroids: int = 0
var leaks_this_round: int = 0

# Round structures mapping round number to details: [spawn_list, interval]
var round_definitions: Dictionary = {}

func _ready():
	spawn_timer = Timer.new()
	spawn_timer.one_shot = true
	spawn_timer.timeout.connect(_spawn_next)
	add_child(spawn_timer)
	_build_round_definitions()
	reset_rounds()

func _build_round_definitions():
	round_definitions = {}
	
	# Round 1: 30 Pebbles (interval 0.5s)
	var r1_spawns = []
	for i in range(30):
		r1_spawns.append(1)
	round_definitions[1] = { "spawns": r1_spawns, "interval": 0.5 }
	
	# Round 2: 25 Pebbles, 10 Boulders (interval 0.4s)
	var r2_spawns = []
	for i in range(10):
		r2_spawns.append(1)
		r2_spawns.append(1)
		r2_spawns.append(2)
	for i in range(5):
		r2_spawns.append(1)
	round_definitions[2] = { "spawns": r2_spawns, "interval": 0.4 }
	
	# Round 3: 40 Pebbles, 20 Boulders (interval 0.4s)
	var r3_spawns = []
	for i in range(20):
		r3_spawns.append(1)
		r3_spawns.append(1)
		r3_spawns.append(2)
	round_definitions[3] = { "spawns": r3_spawns, "interval": 0.4 }
	
	# Round 4: 35 Boulders (some Hard Crust bottleneck) (interval 0.3s)
	var r4_spawns = []
	for i in range(35):
		if i % 7 == 0:
			r4_spawns.append({"tier": 2, "variant": "Hard Crust"})
		else:
			r4_spawns.append(2)
	round_definitions[4] = { "spawns": r4_spawns, "interval": 0.3 }
	
	# Round 5: 20 Boulders, 8 Meteors (Variants/Elementals debut) (interval 0.3s)
	var r5_spawns = []
	for i in range(20):
		r5_spawns.append(2)
	r5_spawns.append({"tier": 3, "variant": "Magnetic Core"})
	r5_spawns.append({"tier": 3, "elemental": "Ice"})
	r5_spawns.append({"tier": 3, "elemental": "Lava"})
	r5_spawns.append({"tier": 3, "variant": "Blinding Tail"})
	r5_spawns.append(3)
	r5_spawns.append({"tier": 3, "elemental": "Ice"})
	r5_spawns.append({"tier": 3, "elemental": "Lava"})
	r5_spawns.append(3)
	round_definitions[5] = { "spawns": r5_spawns, "interval": 0.3 }
	
	# Round 6: 40 Boulders, 15 Meteors [Mixed Swarm] (interval 0.2s)
	var r6_spawns = []
	for i in range(40):
		if i % 10 == 0:
			r6_spawns.append({"tier": 2, "variant": "Hard Crust"})
		else:
			r6_spawns.append(2)
	for i in range(15):
		if i % 4 == 0:
			r6_spawns.append({"tier": 3, "variant": "Magnetic Core"})
		elif i % 4 == 1:
			r6_spawns.append({"tier": 3, "elemental": "Ice"})
		elif i % 4 == 2:
			r6_spawns.append({"tier": 3, "elemental": "Lava"})
		else:
			r6_spawns.append({"tier": 3, "variant": "Ring Belt"})
	round_definitions[6] = { "spawns": r6_spawns, "interval": 0.2 }
	
	# Round 7: 20 Meteors, 5 Giants (interval 0.2s)
	var r7_spawns = []
	for i in range(20):
		if i % 5 == 0:
			r7_spawns.append({"tier": 3, "variant": "Blinding Tail"})
		elif i % 5 == 1:
			r7_spawns.append({"tier": 3, "elemental": "Ice"})
		elif i % 5 == 2:
			r7_spawns.append({"tier": 3, "elemental": "Lava"})
		else:
			r7_spawns.append(3)
	for i in range(5):
		r7_spawns.append({"tier": 4, "variant": "Magnetic Core"})
	round_definitions[7] = { "spawns": r7_spawns, "interval": 0.2 }
	
	# Round 8: 30 Meteors, 10 Giants (interval 0.2s)
	var r8_spawns = []
	for i in range(30):
		if i % 6 == 0:
			r8_spawns.append({"tier": 3, "elemental": "Ice"})
		elif i % 6 == 1:
			r8_spawns.append({"tier": 3, "elemental": "Lava"})
		elif i % 6 == 2:
			r8_spawns.append({"tier": 3, "variant": "Ring Belt"})
		else:
			r8_spawns.append(3)
	for i in range(10):
		if i % 3 == 0:
			r8_spawns.append({"tier": 4, "variant": "Hard Crust"})
		elif i % 3 == 1:
			r8_spawns.append({"tier": 4, "variant": "Ring Belt"})
		else:
			r8_spawns.append(4)
	round_definitions[8] = { "spawns": r8_spawns, "interval": 0.2 }
	
	# Round 9: 15 Giants, 2 Planet Chunks (interval 0.1s)
	var r9_spawns = []
	for i in range(15):
		if i % 3 == 0:
			r9_spawns.append({"tier": 4, "variant": "Magnetic Core"})
		elif i % 3 == 1:
			r9_spawns.append({"tier": 4, "elemental": "Ice"})
		else:
			r9_spawns.append(4)
	r9_spawns.append({"tier": 5, "variant": "Ring Belt"})
	r9_spawns.append(5)
	round_definitions[9] = { "spawns": r9_spawns, "interval": 0.1 }
	
	# Round 10: 10 Giants, 5 Planet Chunks [End of Days] (interval 0.1s)
	var r10_spawns = []
	for i in range(10):
		if i % 2 == 0:
			r10_spawns.append({"tier": 4, "elemental": "Lava"})
		else:
			r10_spawns.append(4)
	r10_spawns.append({"tier": 5, "variant": "Magnetic Core"})
	r10_spawns.append({"tier": 5, "elemental": "Ice"})
	r10_spawns.append({"tier": 5, "elemental": "Lava"})
	r10_spawns.append({"tier": 5, "variant": "Ring Belt"})
	r10_spawns.append(5)
	round_definitions[10] = { "spawns": r10_spawns, "interval": 0.1 }

func reset_rounds():
	self.current_round = 0
	round_active = false
	active_asteroids = 0
	leaks_this_round = 0
	spawn_list.clear()
	if spawn_timer:
		spawn_timer.stop()

func set_round(value: int):
	current_round = clamp(value, 0, TOTAL_ROUNDS)
	round_changed.emit(current_round)

func start_round():
	if round_active or GameManager.current_phase == GameManager.GamePhase.GAME_OVER or GameManager.current_phase == GameManager.GamePhase.GAME_WON:
		return
		
	self.current_round += 1
	round_active = true
	leaks_this_round = 0
	active_asteroids = 0
	
	GameManager.current_phase = GameManager.GamePhase.ROUND_ACTIVE
	round_started.emit(current_round)
	
	# Load definitions
	var def = round_definitions.get(current_round, round_definitions[1])
	spawn_list.clear()
	for s in def["spawns"]:
		spawn_list.append(s)
	spawn_interval = def["interval"]
	
	MetricsManager.start_round(current_round)
	
	spawn_timer.start(0.5) # Start first spawn shortly

func _spawn_next():
	if spawn_list.is_empty():
		return
		
	var spawn_data = spawn_list.pop_front()
	var tier = 1
	var variant = "None"
	var elemental = "None"
	
	if spawn_data is Dictionary:
		tier = spawn_data.get("tier", 1)
		variant = spawn_data.get("variant", "None")
		elemental = spawn_data.get("elemental", "None")
	else:
		tier = spawn_data as int
		
	# Spawn in the main scene
	get_tree().call_group("main", "spawn_asteroid", tier, 0.0, variant, elemental)
	
	if not spawn_list.is_empty():
		# Start timer for next spawn, considering current speed scale
		spawn_timer.start(spawn_interval)

func register_asteroid_spawn():
	active_asteroids += 1

func register_asteroid_removed():
	active_asteroids = max(0, active_asteroids - 1)
	_check_round_end()

func register_leak():
	leaks_this_round += 1

func _check_round_end():
	if round_active and spawn_list.is_empty() and active_asteroids == 0:
		round_active = false
		var no_leak = (leaks_this_round == 0)
		
		# Award bonus
		if no_leak:
			var bonus = current_round * 5
			EconomyManager.add_minerals(bonus)
			
		MetricsManager.end_round(current_round, leaks_this_round)
		
		round_completed.emit(current_round, no_leak)
		
		if current_round >= TOTAL_ROUNDS:
			GameManager.current_phase = GameManager.GamePhase.GAME_WON
		else:
			GameManager.current_phase = GameManager.GamePhase.ROUND_PREPARATION
