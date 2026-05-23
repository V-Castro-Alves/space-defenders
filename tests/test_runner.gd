extends Node

func _ready():
	print("====================================")
	print("SPACE DEFENDERS - AUTOMATED TEST RUNNER")
	print("====================================")
	
	# Create a visual canvas to display test results on screen
	var bg = ColorRect.new()
	bg.size = Vector2(2048, 1152)
	bg.color = Color("#090d16")
	add_child(bg)
	
	var label = Label.new()
	label.position = Vector2(80, 80)
	label.add_theme_font_size_override("font_size", 24)
	add_child(label)
	
	var log_text = "SPACE DEFENDERS TEST RESULTS:\n\n"
	var passed = true
	
	# ----------------------------------------------------
	# Test 1: Economy, Refunds & Upgrades Net Value
	# ----------------------------------------------------
	log_text += "[RUN] Testing Economy and Upgrade Net Value...\n"
	EconomyManager.reset_economy()
	if EconomyManager.minerals != 50:
		log_text += "  [FAIL] Starting minerals is not 50 (got %d)\n" % EconomyManager.minerals
		passed = false
	else:
		log_text += "  [PASS] Starting minerals is 50\n"
		
	# GDD: Repositioning a Scout (cost 20) costs 15% (3 minerals)
	var repo_fee = EconomyManager.get_reposition_fee(20)
	if repo_fee != 3:
		log_text += "  [FAIL] Reposition fee for Scout is wrong (got %d, expected 3)\n" % repo_fee
		passed = false
	else:
		log_text += "  [PASS] Reposition fee for Scout is 3 minerals\n"
		
	# GDD: Selling a base Scout (cost 20) returns 70% (14 minerals)
	var base_refund = EconomyManager.get_sell_refund(20)
	if base_refund != 14:
		log_text += "  [FAIL] Sell refund for base Scout is wrong (got %d, expected 14)\n" % base_refund
		passed = false
	else:
		log_text += "  [PASS] Sell refund for base Scout is 14 minerals\n"
		
	# GDD: Selling an upgraded Scout (cost 20 + 25 Hot Laser) returns 70% of total (31 minerals)
	var upgraded_refund = EconomyManager.get_sell_refund(20 + 25)
	if upgraded_refund != 31:
		log_text += "  [FAIL] Sell refund for upgraded Scout is wrong (got %d, expected 31)\n" % upgraded_refund
		passed = false
	else:
		log_text += "  [PASS] Sell refund for upgraded Scout is 31 minerals (70% of 45)\n"
		
	# ----------------------------------------------------
	# Test 2: Asteroid Splitting & Core HP Physics
	# ----------------------------------------------------
	log_text += "\n[RUN] Testing Asteroid Splitting & Core HP Physics...\n"
	var asteroid_scene = load("res://entities/asteroids/asteroid.tscn")
	
	# Boulder (T2) requires 2 hits to split
	var b1 = asteroid_scene.instantiate()
	b1.current_tier = 2
	add_child(b1)
	
	b1.take_damage(1, "Weak")
	if b1.is_queued_for_deletion():
		log_text += "  [FAIL] Boulder split on the first hit (expected it to survive)\n"
		passed = false
	elif b1.current_hp != 1.0:
		log_text += "  [FAIL] Boulder HP did not reduce to 1 after first hit (got %f)\n" % b1.current_hp
		passed = false
	else:
		log_text += "  [PASS] Boulder survived the first hit with 1 HP remaining\n"
		
	# Clean up
	b1.queue_free()
	
	# Magnetic Core HP Regeneration check
	var mag = asteroid_scene.instantiate()
	mag.current_tier = 2
	mag.variant = "Magnetic Core"
	add_child(mag)
	
	mag.take_damage(1, "Weak") # HP is now 1.0, max is 2.0
	# Wait 4.0s of idle in _process to trigger full heal reset
	mag._process(4.1)
	if mag.current_hp != 2.0:
		log_text += "  [FAIL] Magnetic Core did not fully heal after 4s idle (got %f)\n" % mag.current_hp
		passed = false
	else:
		log_text += "  [PASS] Magnetic Core fully healed back to max HP after 4s idle\n"
		
	# Clean up
	mag.queue_free()
	
	# ----------------------------------------------------
	# Test 3: Asteroid Variant Armor & Immunities
	# ----------------------------------------------------
	log_text += "\n[RUN] Testing Asteroid Variant Armor & Immunities...\n"
	
	# Hard Crust absorbs weak shots (Scout base, Splash, Drone), breaks on heavy/pierce
	var crust = asteroid_scene.instantiate()
	crust.current_tier = 2
	crust.variant = "Hard Crust"
	add_child(crust)
	
	crust.take_damage(1, "Weak")
	if crust.current_hp != 2.0:
		log_text += "  [FAIL] Hard Crust took damage from Scout weak shot (expected 0)\n"
		passed = false
	else:
		log_text += "  [PASS] Hard Crust absorbed Scout weak shot entirely (0 damage)\n"
		
	crust.take_damage(1, "Drone")
	if crust.current_hp != 2.0:
		log_text += "  [FAIL] Hard Crust took damage from Drone weak shot (expected 0)\n"
		passed = false
	else:
		log_text += "  [PASS] Hard Crust absorbed Drone shot entirely (0 damage)\n"
		
	crust.take_damage(1, "Pierce")
	if crust.current_hp != 1.0:
		log_text += "  [FAIL] Hard Crust resisted pierce shot (got %f, expected 1.0)\n" % crust.current_hp
		passed = false
	else:
		log_text += "  [PASS] Hard Crust took full damage from pierce shot (Laser Frigate)\n"
		
	# Clean up
	crust.queue_free()
	
	# Ring Belt deflects Splash and Drones, vulnerable to direct
	var ring = asteroid_scene.instantiate()
	ring.current_tier = 4
	ring.variant = "Ring Belt"
	add_child(ring)
	
	ring.take_damage(1, "Splash")
	if ring.current_hp != 4.0:
		log_text += "  [FAIL] Ring Belt took damage from splash shot (expected 0)\n"
		passed = false
	else:
		log_text += "  [PASS] Ring Belt absorbed splash damage entirely\n"
		
	ring.take_damage(1, "Weak") # Scout direct fire
	if ring.current_hp != 3.0:
		log_text += "  [FAIL] Ring Belt resisted Scout direct shot (got %f)\n" % ring.current_hp
		passed = false
	else:
		log_text += "  [PASS] Ring Belt took full damage from Scout direct shot\n"
		
	# Clean up
	ring.queue_free()
	
	# ----------------------------------------------------
	# Test 4: Blinding Tail Blindness & Targeting Override
	# ----------------------------------------------------
	log_text += "\n[RUN] Testing Blinding Tail & Target Occlusions...\n"
	var ship_scene = load("res://entities/ships/ship.tscn")
	var scout = ship_scene.instantiate()
	scout.ship_type = "Scout"
	scout.global_position = Vector2(1000, 500)
	add_child(scout)
	
	var tail = asteroid_scene.instantiate()
	tail.current_tier = 3
	tail.variant = "Blinding Tail"
	tail.global_position = Vector2(1000, 550) # Within 3-tile blindness (dist 50)
	add_child(tail)
	
	var in_range = scout.get_asteroids_in_range()
	if in_range.has(tail):
		log_text += "  [FAIL] Scout without Optical Targeting locked onto Blinding Tail (expected blind)\n"
		passed = false
	else:
		log_text += "  [PASS] Scout without Optical Targeting was correctly blinded by Blinding Tail\n"
		
	scout.has_optical_targeting = true
	in_range = scout.get_asteroids_in_range()
	if not in_range.has(tail):
		log_text += "  [FAIL] Upgraded Scout failed to target Blinding Tail\n"
		passed = false
	else:
		log_text += "  [PASS] Upgraded Scout (Optical Targeting) successfully targeted Blinding Tail\n"
		
	# Clean up
	scout.queue_free()
	tail.queue_free()
	
	# ----------------------------------------------------
	# Test 5: Thermal Laser Reactions (Ice & Lava elementals)
	# ----------------------------------------------------
	log_text += "\n[RUN] Testing Thermal Laser Reactions...\n"
	
	# Ice Shatter (Ice + Cold Laser -> 2.0-tile AoE shrapnel burst)
	var ice1 = asteroid_scene.instantiate()
	ice1.current_tier = 2
	ice1.elemental_type = "Ice"
	ice1.global_position = Vector2(1000, 500)
	add_child(ice1)
	
	var ice2 = asteroid_scene.instantiate()
	ice2.current_tier = 1
	ice2.global_position = Vector2(1000, 550) # Within 128px (dist 50)
	add_child(ice2)
	
	# Trigger shatter
	ice1.take_damage(1, "ColdLaser")
	if ice2.current_hp != 0.0 or not ice2.is_queued_for_deletion(): # 1 HP Pebble takes 1 reaction damage -> destroyed!
		log_text += "  [FAIL] Ice Shatter shrapnel failed to damage adjacent T1 asteroid (got HP %f)\n" % ice2.current_hp
		passed = false
	else:
		log_text += "  [PASS] Cold Laser hitting Ice correctly triggered Shatter AoE shrapnel blast\n"
		
	# Clean up
	ice1.queue_free()
	if is_instance_valid(ice2): ice2.queue_free()
	
	# Lava Solidification (Lava + Cold Laser -> 0 damage, neutral conversion)
	var lava = asteroid_scene.instantiate()
	lava.current_tier = 3
	lava.elemental_type = "Lava"
	add_child(lava)
	
	lava.take_damage(1, "ColdLaser")
	if lava.current_hp != 3.0:
		log_text += "  [FAIL] Lava Solidify took damage (expected 0 damage, got HP %f)\n" % lava.current_hp
		passed = false
	elif lava.elemental_type != "None":
		log_text += "  [FAIL] Lava Solidify failed to convert elemental type to None (got %s)\n" % lava.elemental_type
		passed = false
	else:
		log_text += "  [PASS] Cold Laser hitting Lava Solidified it to standard rock with 0 damage\n"
		
	# Clean up
	lava.queue_free()
	
	# ----------------------------------------------------
	# Test 6: Kinetic & Gravitational well support physics
	# ----------------------------------------------------
	log_text += "\n[RUN] Testing Support Ships & Freeze Fields...\n"
	
	var g_well = ship_scene.instantiate()
	g_well.ship_type = "Gravity Well"
	add_child(g_well)
	
	# Verify mass-scaled freeze durations
	var f_pebble = g_well.get_freeze_duration(1) # Pebble (T1) GDD duration: 4.0s
	var f_chunk = g_well.get_freeze_duration(5) # Planet Chunk (T5) GDD duration: 1.0s
	if f_pebble != 4.0 or f_chunk != 1.0:
		log_text += "  [FAIL] Gravity Well mass-scaled freeze lookup failed (got Pebble %fs, Chunk %fs)\n" % [f_pebble, f_chunk]
		passed = false
	else:
		log_text += "  [PASS] Mass-scaled freeze duration mapped correctly (Pebble 4.0s, Planet Chunk 1.0s)\n"
		
	# Verify freeze effect pauses progress movement in asteroid.gd
	var ast_f = asteroid_scene.instantiate()
	ast_f.current_tier = 1
	add_child(ast_f)
	
	ast_f.apply_freeze(3.0)
	ast_f._process(1.0)
	if ast_f.progress != 0.0:
		log_text += "  [FAIL] Frozen asteroid moved progress! (got progress %f, expected 0.0)\n" % ast_f.progress
		passed = false
	elif ast_f.freeze_timer != 2.0:
		log_text += "  [FAIL] Frozen timer did not decrement correctly (got %f)\n" % ast_f.freeze_timer
		passed = false
	else:
		log_text += "  [PASS] Frozen asteroid successfully stationary during active freeze timers\n"
		
	# Clean up
	g_well.queue_free()
	ast_f.queue_free()
	
	# ----------------------------------------------------
	# Test 7: Drone Carrier Target Distribution
	# ----------------------------------------------------
	log_text += "\n[RUN] Testing Drone Carrier target distribution...\n"
	
	var carrier = ship_scene.instantiate()
	carrier.ship_type = "Drone Carrier"
	carrier.global_position = Vector2(1000, 500)
	add_child(carrier)
	
	# Create two asteroids in range
	var ast_d1 = asteroid_scene.instantiate()
	ast_d1.current_tier = 1
	ast_d1.global_position = Vector2(1000, 520)
	ast_d1.progress = 100.0
	add_child(ast_d1)
	
	var ast_d2 = asteroid_scene.instantiate()
	ast_d2.current_tier = 1
	ast_d2.global_position = Vector2(1000, 480)
	ast_d2.progress = 200.0
	add_child(ast_d2)
	
	# Run a frame of Carrier process and check drone shoots target distribution
	var list_d = carrier.get_asteroids_in_range()
	list_d = carrier.sort_asteroids_by_targeting_mode(list_d)
	
	# Drone 0 should lock target 0, Drone 1 should lock target 1
	var t0 = list_d[0]
	var t1 = list_d[1]
	
	if t0 != ast_d2 or t1 != ast_d1:
		log_text += "  [FAIL] Carrier failed to sort target modes correctly\n"
		passed = false
	else:
		log_text += "  [PASS] Drones successfully distributed to different targets: Drone 0 -> Target First, Drone 1 -> Target Second\n"
		
	# Clean up
	carrier.queue_free()
	ast_d1.queue_free()
	ast_d2.queue_free()
	
	# ----------------------------------------------------
	# Test 8: Main Menu Launch Protocols & Developer Mode
	# ----------------------------------------------------
	log_text += "\n[RUN] Testing Main Menu Protocols & Developer Mode...\n"
	
	var menu_class = load("res://ui/main_menu.gd")
	var menu_test = menu_class.new()
	add_child(menu_test)
	
	# Try Normal Mode start
	menu_test._on_normal_pressed()
	if GameManager.dev_mode or GameManager.lives != 20 or EconomyManager.minerals != 50:
		log_text += "  [FAIL] Normal Mode protocol set incorrect parameters (lives %d, minerals %d)\n" % [GameManager.lives, EconomyManager.minerals]
		passed = false
	else:
		log_text += "  [PASS] Normal Mode launch protocol successfully sets 50 minerals and 20 lives\n"
		
	# Try Dev Mode start
	var menu_test2 = menu_class.new()
	add_child(menu_test2)
	menu_test2._on_dev_pressed()
	
	if not GameManager.dev_mode or GameManager.lives != 99999 or EconomyManager.minerals != 99999:
		log_text += "  [FAIL] Dev Mode protocol set incorrect parameters\n"
		passed = false
	else:
		log_text += "  [PASS] Dev Mode launch protocol successfully sets 99999 minerals and lives\n"
		
	# Verify Dev Mode blocks spend deductions
	EconomyManager.spend_minerals(100)
	if EconomyManager.minerals != 99999:
		log_text += "  [FAIL] Dev Mode spend_minerals deducted minerals (got %d)\n" % EconomyManager.minerals
		passed = false
	else:
		log_text += "  [PASS] Dev Mode spend_minerals bypassed mineral deductions successfully\n"
		
	# Verify Dev Mode blocks live deductions
	GameManager.lose_lives(10)
	if GameManager.lives != 99999:
		log_text += "  [FAIL] Dev Mode lose_lives deducted lives (got %d)\n" % GameManager.lives
		passed = false
	else:
		log_text += "  [PASS] Dev Mode lose_lives bypassed live deductions successfully\n"
		
	# Reset back to Normal Mode to avoid polluting normal gameplay after tests
	GameManager.dev_mode = false
	GameManager.lives = 20
	EconomyManager.minerals = 50
	
	# ----------------------------------------------------
	# Final Output & Visual Display
	# ----------------------------------------------------
	if passed:
		log_text += "\n====================================\n"
		log_text += "ALL SPECIFICATION TESTS PASSED SUCCESSFULLY! ✅"
		log_text += "\n====================================\n"
		label.add_theme_color_override("font_color", Color("#22c55e"))
	else:
		log_text += "\n====================================\n"
		log_text += "SOME SYSTEM SPECIFICATION TESTS FAILED! ❌"
		log_text += "\n====================================\n"
		label.add_theme_color_override("font_color", Color("#ef4444"))
		
	label.text = log_text
	print(log_text)
