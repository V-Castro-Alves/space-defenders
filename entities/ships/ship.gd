extends Area2D

var ship_type: String = "Scout"
var display_name: String = "Scout"
var base_cost: int = 20
var range_tiles: float = 2.0
var fire_rate: float = 1.0
var damage: int = 1
var ship_color: Color = Color("#22c55e")

var range_pixels: float = 128.0
var targeting_mode: String = "First"
var is_ghost: bool = false
var is_selected: bool = false
var is_hovered: bool = false

var fire_cooldown: float = 0.0
var selected_range_color: Color = Color(0, 1, 0, 0.4)

# Drone Carrier specific
var drones: Array[Node2D] = []
var drone_angle: float = 0.0
var drone_cooldowns: Array[float] = [0.0, 0.0, 0.0]

# Pulse Beam specific
var pulse_beam_angle: float = 0.0

# Upgrades state
var laser_upgrade: String = "None" # "None", "Hot", "Cold"
var has_optical_targeting: bool = false
var upgrades_cost: int = 0

func get_total_value() -> int:
	return base_cost + upgrades_cost

func _ready():
	input_pickable = true
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	
	# Set up a collision shape for mouse clicking
	var collision = CollisionShape2D.new()
	var shape = RectangleShape2D.new()
	shape.size = Vector2(48, 48)
	collision.shape = shape
	add_child(collision)
	
	setup_type(ship_type)
	if not is_ghost:
		MetricsManager.record_tower_placement(ship_type, base_cost)
	queue_redraw()

func setup_type(type: String):
	ship_type = type
	match ship_type:
		"Scout":
			display_name = "Scout"
			base_cost = 75
			range_tiles = 1.5
			fire_rate = 1.0
			damage = 1
			ship_color = Color("#22c55e") # Green
		"Laser Frigate":
			display_name = "Laser Frigate"
			base_cost = 150
			range_tiles = 3.0
			fire_rate = 1.0
			damage = 2
			ship_color = Color("#06b6d4") # Cyan
		"Missile Cruiser":
			display_name = "Missile Cruiser"
			base_cost = 220
			range_tiles = 2.5
			fire_rate = 0.8
			damage = 1
			ship_color = Color("#a855f7") # Purple
		"Pulse Beam":
			display_name = "Pulse Beam"
			base_cost = 300
			range_tiles = 2.0
			fire_rate = 0.5
			damage = 1
			ship_color = Color("#f59e0b") # Warm gold
		"Ion Cannon":
			display_name = "Ion Cannon"
			base_cost = 450
			range_tiles = 3.0
			fire_rate = 0.5
			damage = 3
			ship_color = Color("#3b82f6") # Blue
		"Drone Carrier":
			display_name = "Drone Carrier"
			base_cost = 550
			range_tiles = 2.5
			fire_rate = 0.8
			damage = 1
			ship_color = Color("#ec4899") # Pink
			# Setup drones
			if drones.is_empty() and not is_ghost:
				for i in range(3):
					var drone = Node2D.new()
					drone.name = "Drone_" + str(i)
					add_child(drone)
					drones.append(drone)
		"Gravity Well":
			display_name = "Gravity Well"
			base_cost = 600
			range_tiles = 3.0
			fire_rate = 1.0 / 6.0
			damage = 0
			ship_color = Color("#ffffff") # White
			
	range_pixels = range_tiles * 64.0
	selected_range_color = ship_color
	selected_range_color.a = 0.4
	
	queue_redraw()

func _on_mouse_entered():
	is_hovered = true
	queue_redraw()

func _on_mouse_exited():
	is_hovered = false
	queue_redraw()

func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if not is_ghost:
			get_tree().call_group("main", "select_ship", self)
			get_viewport().set_input_as_handled()

func _draw():
	# Range Circle
	if is_selected or is_ghost or is_hovered:
		var fill_color = selected_range_color
		fill_color.a = 0.12
		draw_circle(Vector2.ZERO, range_pixels, fill_color)
		draw_arc(Vector2.ZERO, range_pixels, 0, 2*PI, 64, selected_range_color, 1.5, true)
		
		# For Pulse Beam, draw the 90-degree sector facing its current pulse_beam_angle
		if ship_type == "Pulse Beam" and not is_ghost:
			var cone_color = selected_range_color
			cone_color.a = 0.3
			draw_line(Vector2.ZERO, Vector2.from_angle(pulse_beam_angle - PI/4) * range_pixels, cone_color, 1.5)
			draw_line(Vector2.ZERO, Vector2.from_angle(pulse_beam_angle + PI/4) * range_pixels, cone_color, 1.5)
			draw_arc(Vector2.ZERO, range_pixels, pulse_beam_angle - PI/4, pulse_beam_angle + PI/4, 32, selected_range_color, 2.0, true)
		
	# Solid Square Representing Ship
	draw_rect(Rect2(-24, -24, 48, 48), ship_color)
	# Accent borders
	draw_rect(Rect2(-24, -24, 48, 48), Color.BLACK, false, 2.0)
	
	# Type specifics visual decoration inside square
	match ship_type:
		"Scout":
			# Arrow decoration
			draw_line(Vector2(0, -16), Vector2(-12, 12), Color.BLACK, 2.0)
			draw_line(Vector2(0, -16), Vector2(12, 12), Color.BLACK, 2.0)
			draw_line(Vector2(-12, 12), Vector2(0, 4), Color.BLACK, 2.0)
			draw_line(Vector2(12, 12), Vector2(0, 4), Color.BLACK, 2.0)
		"Laser Frigate":
			# Center lens
			draw_circle(Vector2.ZERO, 8.0, Color.BLACK)
			draw_circle(Vector2.ZERO, 4.0, Color.WHITE)
		"Missile Cruiser":
			# Rocket cross
			draw_rect(Rect2(-6, -18, 12, 36), Color.BLACK)
			draw_rect(Rect2(-18, -6, 36, 12), Color.BLACK)
		"Pulse Beam":
			# 3 concentric arcs for broad sweeps
			draw_arc(Vector2.ZERO, 8.0, -PI/4, PI/4, 8, Color.BLACK, 2.0)
			draw_arc(Vector2.ZERO, 14.0, -PI/4, PI/4, 8, Color.BLACK, 2.0)
			draw_line(Vector2.ZERO, Vector2(12, 0), Color.BLACK, 2.0)
		"Ion Cannon":
			# Heavy barrel indicator
			draw_rect(Rect2(-8, -20, 16, 12), Color.BLACK)
		"Drone Carrier":
			# Inner core
			draw_circle(Vector2.ZERO, 6.0, Color.BLACK)
		"Gravity Well":
			# Spiral/concentric ripples inside block
			draw_circle(Vector2.ZERO, 16.0, Color.BLACK, false, 1.5)
			draw_circle(Vector2.ZERO, 8.0, Color.BLACK, false, 1.5)
			draw_circle(Vector2.ZERO, 3.0, Color.BLACK)

	# Draw drones programmatically for Carrier
	if ship_type == "Drone Carrier" and not is_ghost:
		for i in range(drones.size()):
			var angle = drone_angle + (i * PI * 2.0 / 3.0)
			var drone_pos = Vector2.from_angle(angle) * 44.0
			draw_rect(Rect2(drone_pos.x - 6, drone_pos.y - 6, 12, 12), Color("#f472b6"))
			draw_rect(Rect2(drone_pos.x - 6, drone_pos.y - 6, 12, 12), Color.BLACK, false, 1.0)

func _process(delta):
	if is_ghost:
		return
		
	# Handle Pulse Beam auto-rotation sweep even when not firing, to look alive
	if ship_type == "Pulse Beam":
		pulse_beam_angle = get_densest_cluster_angle()
		queue_redraw()

	# Handle shooting cooldowns
	if fire_cooldown > 0.0:
		fire_cooldown -= delta
	else:
		_shoot()
		
	# Orbit drones for Carrier
	if ship_type == "Drone Carrier":
		drone_angle += delta * 2.0
		queue_redraw()
		
		# Process distributive drone shooting
		var targets = get_asteroids_in_range()
		targets = sort_asteroids_by_targeting_mode(targets)
		
		for i in range(drones.size()):
			if drone_cooldowns[i] > 0.0:
				drone_cooldowns[i] -= delta
			else:
				var t = null
				if i < targets.size():
					t = targets[i]
				elif not targets.is_empty():
					t = targets[0]
					
				if t:
					_shoot_drone(i, t)

func sort_asteroids_by_targeting_mode(list: Array) -> Array:
	var sorted = list.duplicate()
	match targeting_mode:
		"First":
			sorted.sort_custom(func(a, b): return a.progress > b.progress)
		"Last":
			sorted.sort_custom(func(a, b): return a.progress < b.progress)
		"Strongest":
			sorted.sort_custom(func(a, b):
				if a.current_tier != b.current_tier:
					return a.current_tier > b.current_tier
				return a.progress > b.progress
			)
		"Closest":
			sorted.sort_custom(func(a, b):
				return global_position.distance_to(a.global_position) < global_position.distance_to(b.global_position)
			)
	return sorted

func get_densest_cluster_angle() -> float:
	var list = get_asteroids_in_range()
	if list.is_empty():
		return 0.0
		
	var best_angle = 0.0
	var max_count = -1
	
	# Sweep 36 steps (every 10 degrees)
	for step in range(36):
		var angle = step * (PI / 18.0)
		var count = 0
		for ast in list:
			var relative_vector = ast.global_position - global_position
			var angle_to_ast = relative_vector.angle()
			var angle_diff = abs(angle_to_local_angle(angle_to_ast - angle))
			if angle_diff <= PI / 4.0: # 45 degrees either side = 90 degree cone
				count += 1
		if count > max_count:
			max_count = count
			best_angle = angle
	return best_angle

func angle_to_local_angle(a: float) -> float:
	return fposmod(a + PI, 2 * PI) - PI

func get_asteroids_in_range() -> Array:
	var in_range = []
	var asteroids = get_tree().get_nodes_in_group("asteroids")
	for ast in asteroids:
		if is_instance_valid(ast):
			var dist = global_position.distance_to(ast.global_position)
			if dist <= range_pixels:
				# Blinding Tail check
				if ast.variant == "Blinding Tail" and dist <= 192.0:
					if ship_type == "Missile Cruiser" or ship_type == "Drone Carrier":
						continue # Blinded!
					if ship_type == "Scout" and not has_optical_targeting:
						continue # Blinded!
						
				in_range.append(ast)
	return in_range

func get_best_target() -> Node2D:
	var list = get_asteroids_in_range()
	if list.is_empty():
		return null
		
	var best = null
	match targeting_mode:
		"First":
			var max_prog = -1.0
			for ast in list:
				if ast.progress > max_prog:
					max_prog = ast.progress
					best = ast
		"Last":
			var min_prog = INF
			for ast in list:
				if ast.progress < min_prog:
					min_prog = ast.progress
					best = ast
		"Strongest":
			var max_tier = -1
			var max_prog = -1.0
			for ast in list:
				if ast.current_tier > max_tier or (ast.current_tier == max_tier and ast.progress > max_prog):
					max_tier = ast.current_tier
					max_prog = ast.progress
					best = ast
		"Closest":
			var min_dist = INF
			for ast in list:
				var dist = global_position.distance_to(ast.global_position)
				if dist < min_dist:
					min_dist = dist
					best = ast
	return best

func get_freeze_duration(tier: int) -> float:
	match tier:
		1: return 4.0
		2: return 3.0
		3: return 2.0
		4: return 1.5
		5: return 1.0
	return 0.0

func _shoot():
	# Gravity Well does not need a target to pulse, it just pulses if any asteroids are in range
	if ship_type == "Gravity Well":
		var list = get_asteroids_in_range()
		if list.is_empty():
			return
		fire_cooldown = 1.0 / fire_rate
		
		# Spawn visual pulse effect
		var wave = Node2D.new()
		wave.set_script(preload("res://entities/ships/gravity_well_effect.gd"))
		wave.start_pos = global_position
		wave.range_radius = range_pixels
		wave.effect_color = ship_color
		wave.global_position = global_position
		get_parent().add_child(wave)
		
		# Freeze all asteroids in range
		for ast in list:
			if is_instance_valid(ast) and ast.has_method("apply_freeze"):
				ast.apply_freeze(get_freeze_duration(ast.current_tier))
		return

	var target = get_best_target()
	if not target:
		return
		
	fire_cooldown = 1.0 / fire_rate
	
	match ship_type:
		"Scout":
			# Spawn standard homing projectile
			var proj_scene = load("res://entities/projectiles/projectile.tscn")
			var p = proj_scene.instantiate()
			p.damage = damage
			p.target = target
			p.source_ship_type = "Scout"
			p.global_position = global_position
			
			var p_color = ship_color
			var s_type = "Weak"
			if laser_upgrade == "Hot":
				p_color = Color("#f97316") # Orange
				s_type = "HotLaser"
			elif laser_upgrade == "Cold":
				p_color = Color("#38bdf8") # Ice Blue
				s_type = "ColdLaser"
				
			p.projectile_color = p_color
			p.shot_type = s_type
			get_parent().add_child(p)
			
		"Ion Cannon":
			# Spawn standard homing projectile
			var proj_scene = load("res://entities/projectiles/projectile.tscn")
			var p = proj_scene.instantiate()
			p.damage = damage
			p.target = target
			p.source_ship_type = "Ion Cannon"
			p.global_position = global_position
			p.projectile_color = ship_color
			p.shot_type = "Heavy"
			get_parent().add_child(p)
			
		"Missile Cruiser":
			# Spawn splash missile
			var proj_scene = load("res://entities/projectiles/projectile.tscn")
			var p = proj_scene.instantiate()
			p.damage = damage
			p.target = target
			p.source_ship_type = "Missile Cruiser"
			p.splash_radius = 96.0 # 1.5 tiles
			p.global_position = global_position
			p.projectile_color = ship_color
			p.shot_type = "Weak"
			get_parent().add_child(p)
			
		"Laser Frigate":
			# Straight-line ray sweep piercing all asteroids along line
			var end_pos = global_position + (target.global_position - global_position).normalized() * range_pixels
			
			# Spawn visual beam effect
			var beam = Node2D.new()
			beam.set_script(preload("res://entities/ships/laser_beam_effect.gd"))
			beam.start_pos = global_position
			beam.end_pos = end_pos
			
			var l_color = ship_color
			var s_type = "Pierce"
			if laser_upgrade == "Hot":
				l_color = Color("#f97316")
				s_type = "HotLaser"
			elif laser_upgrade == "Cold":
				l_color = Color("#38bdf8")
				s_type = "ColdLaser"
				
			beam.beam_color = l_color
			get_parent().add_child(beam)
			
			# Pierce damage check
			var asteroids = get_asteroids_in_range()
			for ast in asteroids:
				if is_instance_valid(ast):
					# Check distance from asteroid point to laser line segment
					var closest = Geometry2D.get_closest_point_to_segment(ast.global_position, global_position, end_pos)
					if ast.global_position.distance_to(closest) < (ast.size / 2.0 + 8.0):
						ast.take_damage(damage, s_type, "Laser Frigate")
						
		"Pulse Beam":
			# Sweep to densest cluster center and lock rotation
			pulse_beam_angle = get_densest_cluster_angle()
			queue_redraw()
			
			# Spawn visual cone blast effect
			var beam = Node2D.new()
			beam.set_script(preload("res://entities/ships/pulse_beam_effect.gd"))
			beam.start_pos = global_position
			beam.direction_angle = pulse_beam_angle
			beam.range_radius = range_pixels
			beam.beam_color = ship_color
			beam.global_position = global_position
			get_parent().add_child(beam)
			
			# Apply damage to all asteroids in cone
			var asteroids = get_asteroids_in_range()
			for ast in asteroids:
				if is_instance_valid(ast):
					var relative_vector = ast.global_position - global_position
					var angle_to_ast = relative_vector.angle()
					var angle_diff = abs(angle_to_local_angle(angle_to_ast - pulse_beam_angle))
					if angle_diff <= PI / 4.0:
						ast.take_damage(damage, "Kinetic", "Pulse Beam")

func _shoot_drone(index: int, drone_target: Node2D):
	if not is_instance_valid(drone_target):
		return
		
	drone_cooldowns[index] = 1.25 # Drones fire rate 0.8 shot/s (cooldown 1.25s)
	
	var angle = drone_angle + (index * PI * 2.0 / 3.0)
	var d_pos = global_position + Vector2.from_angle(angle) * 44.0
	
	# Spawn a small drone laser or projectile
	var proj_scene = load("res://entities/projectiles/projectile.tscn")
	var p = proj_scene.instantiate()
	p.damage = 1
	p.target = drone_target
	p.source_ship_type = "Drone Carrier"
	p.speed = 800.0 # Drone shots are fast
	p.global_position = d_pos
	p.projectile_color = Color("#f472b6")
	p.shot_type = "Drone"
	get_parent().add_child(p)
