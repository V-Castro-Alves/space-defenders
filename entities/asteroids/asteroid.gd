extends PathFollow2D

var current_tier: int = 1
var speed: float = 100.0
var lives_on_leak: int = 1
var size: float = 32.0
var color: Color = Color.WHITE

var collision_shape: CollisionShape2D
var area: Area2D

var freeze_timer: float = 0.0

# Variant and HP state
var variant: String = "None" # "None", "Blinding Tail", "Hard Crust", "Magnetic Core", "Ring Belt"
var max_hp: float = 1.0
var current_hp: float = 1.0
var elemental_type: String = "None" # "None", "Ice", "Lava"

var last_damage_time: float = 0.0
var magnetic_regen_cooldown: float = 0.0

func _ready():
	loop = false
	
	# Create Area2D and CollisionShape2D
	area = Area2D.new()
	area.collision_layer = 2 # Asteroid layer
	area.collision_mask = 0
	add_child(area)
	
	collision_shape = CollisionShape2D.new()
	var shape = RectangleShape2D.new()
	shape.size = Vector2(size, size)
	collision_shape.shape = shape
	area.add_child(collision_shape)
	
	setup_tier(current_tier)
	WaveManager.register_asteroid_spawn()

func setup_tier(t: int):
	current_tier = t
	match current_tier:
		5:
			speed = 40.0
			lives_on_leak = 32
			size = 64.0
			color = Color("#7f1d1d") # Dark Red
		4:
			speed = 60.0
			lives_on_leak = 16
			size = 48.0
			color = Color("#dc2626") # Red
		3:
			speed = 90.0
			lives_on_leak = 8
			size = 36.0
			color = Color("#ea580c") # Orange
		2:
			speed = 130.0
			lives_on_leak = 4
			size = 24.0
			color = Color("#f97316") # Light Orange
		1:
			speed = 180.0
			lives_on_leak = 1
			size = 16.0
			color = Color("#eab308") # Yellow
			
	if collision_shape and collision_shape.shape:
		collision_shape.shape.size = Vector2(size, size)
		
	max_hp = current_tier
	current_hp = current_tier
	queue_redraw()

func _draw():
	var draw_color = color
	if elemental_type == "Ice":
		draw_color = Color("#bae6fd") # Ice pale blue
	elif elemental_type == "Lava":
		draw_color = Color("#f97316") # Molten orange
		
	# Draw solid square representing the asteroid
	draw_rect(Rect2(-size / 2, -size / 2, size, size), draw_color)
	# Subtle dark inner border to give dimension
	draw_rect(Rect2(-size / 2, -size / 2, size, size), Color(0, 0, 0, 0.4), false, 2.0)
	
	# Frosted ice cracks or Lava molten veins
	if elemental_type == "Ice":
		draw_line(Vector2(-size/3, -size/3), Vector2(size/3, size/3), Color("#f0f9ff", 0.5), 1.0)
		draw_line(Vector2(size/4, -size/4), Vector2(-size/4, size/4), Color("#f0f9ff", 0.5), 1.0)
	elif elemental_type == "Lava":
		draw_line(Vector2(-size/3, 0), Vector2(size/3, 0), Color("#fef08a", 0.6), 1.5)
		draw_line(Vector2(0, -size/3), Vector2(0, size/3), Color("#fef08a", 0.6), 1.5)
	
	# Draw variant visual layers
	match variant:
		"Hard Crust":
			# High-density armored cross inside block
			draw_rect(Rect2(-size / 4, -size / 4, size / 2, size / 2), Color(0.1, 0.1, 0.1, 0.6))
			draw_rect(Rect2(-size / 4, -size / 4, size / 2, size / 2), Color.BLACK, false, 1.0)
		"Magnetic Core":
			# Pulsing magnetic blue aura
			var aura_color = Color("#60a5fa")
			aura_color.a = 0.25
			draw_circle(Vector2.ZERO, size * 0.8, aura_color)
			draw_arc(Vector2.ZERO, size * 0.8, 0, 2*PI, 32, Color("#3b82f6", 0.4), 1.0)
		"Ring Belt":
			# Orbiting dotted ring belt
			var ring_color = Color("#94a3b8")
			ring_color.a = 0.6
			draw_arc(Vector2.ZERO, size * 0.9, 0, 2*PI, 16, ring_color, 1.5, true)
		"Blinding Tail":
			# Glowing bright orange-yellow core/tail decoration
			var tail_color = Color("#fbbf24")
			tail_color.a = 0.7
			draw_circle(Vector2(-size/3, 0), size/4, tail_color)

func _process(delta):
	if freeze_timer > 0.0:
		freeze_timer -= delta
		modulate = Color("#7dd3fc")
	else:
		modulate = Color.WHITE
		# Move forward on path
		progress += speed * delta
		
	# Magnetic Core HP Regeneration
	if variant == "Magnetic Core" and current_hp < max_hp:
		last_damage_time += delta
		if last_damage_time >= 4.0:
			current_hp = max_hp
		else:
			if magnetic_regen_cooldown > 0.0:
				magnetic_regen_cooldown -= delta
			else:
				var rate = 0.25 if (freeze_timer > 0.0) else 0.5
				current_hp = min(current_hp + rate * delta, max_hp)
	
	if progress_ratio >= 1.0:
		# Leak asteroid
		GameManager.lose_lives(lives_on_leak)
		WaveManager.register_leak()
		WaveManager.register_asteroid_removed()
		queue_free()

func apply_freeze(duration: float):
	freeze_timer = max(freeze_timer, duration)

func _trigger_elemental_blast(radius_pixels: float, is_shatter: bool = true):
	# Spawn a visual shockwave effect
	var flash_color = Color("#38bdf8") if is_shatter else Color("#f97316") # Blue for ice, orange for lava
	var wave = Node2D.new()
	wave.set_script(preload("res://entities/ships/gravity_well_effect.gd"))
	wave.start_pos = global_position
	wave.range_radius = radius_pixels
	wave.effect_color = flash_color
	wave.global_position = global_position
	get_parent().add_child(wave)
	
	# Apply 1 damage to all adjacent asteroids in range (Reaction type prevents loops)
	var list = get_tree().get_nodes_in_group("asteroids")
	for ast in list:
		if is_instance_valid(ast) and ast != self:
			var dist = global_position.distance_to(ast.global_position)
			if dist <= radius_pixels:
				ast.take_damage(1, "Reaction")

func take_damage(amount: int, shot_type: String = "Weak"):
	if is_queued_for_deletion():
		return
		
	# Drone Carrier lockout rule: drones deal 0 damage to tier 3+ base asteroids
	if shot_type == "Drone" and current_tier >= 3:
		return
		
	# Hard Crust variant rule: absorbs weak shots (Scout, Splash, Drone)
	if variant == "Hard Crust" and (shot_type == "Weak" or shot_type == "Splash" or shot_type == "Drone"):
		return
		
	# Ring Belt variant rule: deflects splash/AoE and drone strikes
	if variant == "Ring Belt" and (shot_type == "Splash" or shot_type == "Drone"):
		return
		
	# Lava Solidification: Cold Laser cools molten exterior, deals 0 damage, converts to neutral
	if elemental_type == "Lava" and shot_type == "ColdLaser":
		elemental_type = "None"
		queue_redraw()
		return
		
	# Reset magnetic core timer on damage taken
	last_damage_time = 0.0
	if shot_type == "Kinetic" and variant == "Magnetic Core":
		magnetic_regen_cooldown = 2.0
		
	# Check thermal/kinetic reaction triggers before reducing HP to 0 (so position is valid)
	if shot_type != "Reaction":
		if elemental_type == "Ice":
			if shot_type == "ColdLaser":
				# The Shatter: normal damage + 2.0-tile (128px) shrapnel burst
				_trigger_elemental_blast(128.0, true)
			elif shot_type == "Kinetic":
				# Mini-Shatter: small 1.0-tile (64px) shrapnel burst
				_trigger_elemental_blast(64.0, true)
		elif elemental_type == "Lava":
			if shot_type == "HotLaser":
				# The Overload: normal damage + tier-scaled massive lava explosion
				var radius_px = 128.0 # 2.0 tiles default (T1/T2)
				match current_tier:
					3: radius_px = 160.0 # 2.5 tiles
					4: radius_px = 192.0 # 3.0 tiles
					5: radius_px = 224.0 # 3.5 tiles
				_trigger_elemental_blast(radius_px, false)
			elif shot_type == "Kinetic":
				# Mini-Overload: small 1.0-tile (64px) lava explosion
				_trigger_elemental_blast(64.0, false)
		
	# Subtract from current_hp
	current_hp -= amount
	
	if current_hp <= 0.0:
		var new_tier = current_tier - 1
		if new_tier <= 0:
			# Entirely destroyed
			if current_tier == 1:
				EconomyManager.add_minerals(1)
			elif current_tier == 2:
				# Destroyed Boulder completely (worth 4 minerals)
				EconomyManager.add_minerals(4)
			else:
				# Destroys bigger ones completely (adds full equivalent value)
				EconomyManager.add_minerals(get_mineral_value(current_tier))
				
			WaveManager.register_asteroid_removed()
			queue_free()
		else:
			# Boulder splits award 2 minerals
			if current_tier == 2:
				EconomyManager.add_minerals(2)
				
			# Spawn two children staggered on path, propagating variant and elemental types
			for main in get_tree().get_nodes_in_group("main"):
				main.call_deferred("spawn_asteroid", new_tier, progress - 8.0, variant, elemental_type)
				main.call_deferred("spawn_asteroid", new_tier, progress + 8.0, variant, elemental_type)
			
			# Remove parent
			WaveManager.register_asteroid_removed()
			queue_free()

func get_mineral_value(tier: int) -> int:
	match tier:
		5: return 32
		4: return 16
		3: return 8
		2: return 4
		1: return 1
	return 0
