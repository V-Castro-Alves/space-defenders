extends Node2D

var path_node: Path2D
var visual_line: Line2D
var visual_outline: Line2D

# Placement states
var placement_active: bool = false
var placement_type: String = ""
var ghost_ship: Node2D = null

# Reposition state
var repositioning_active: bool = false
var ship_to_reposition: Node2D = null

# Selected ship
var selected_ship: Node2D = null

func _ready():
	# Background
	var bg = ColorRect.new()
	bg.size = Vector2(2048, 1152)
	bg.color = Color("#090d16") # Deep space dark blue
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	bg.z_index = -100
	add_child(bg)
	
	# Path Waypoints (Snaking triple-corridor layout)
	var waypoints = [
		Vector2(-64, 160),
		Vector2(1600, 160),
		Vector2(1600, 480),
		Vector2(192, 480),
		Vector2(192, 800),
		Vector2(1600, 800),
		Vector2(1600, 960),
		Vector2(1728, 960)
	]
	
	# Visual Path Line
	visual_line = Line2D.new()
	visual_line.points = waypoints
	visual_line.width = 64
	visual_line.default_color = Color("#1e293b") # Sleek charcoal
	visual_line.z_index = -10
	visual_line.joint_mode = Line2D.LINE_JOINT_ROUND
	visual_line.begin_cap_mode = Line2D.LINE_CAP_ROUND
	visual_line.end_cap_mode = Line2D.LINE_CAP_ROUND
	add_child(visual_line)
	
	# Neon path outline for high-end feel
	visual_outline = Line2D.new()
	visual_outline.points = waypoints
	visual_outline.width = 72
	visual_outline.default_color = Color("#0f172a") # Darker border
	visual_outline.z_index = -11
	visual_outline.joint_mode = Line2D.LINE_JOINT_ROUND
	add_child(visual_outline)
	
	var neon_glow = Line2D.new()
	neon_glow.points = waypoints
	neon_glow.width = 8
	neon_glow.default_color = Color("#38bdf8") # Cyan glowing core
	neon_glow.z_index = -9
	neon_glow.joint_mode = Line2D.LINE_JOINT_ROUND
	add_child(neon_glow)
	
	# Path2D for asteroid tracking
	path_node = Path2D.new()
	path_node.curve = Curve2D.new()
	for p in waypoints:
		path_node.curve.add_point(p)
	add_child(path_node)
	
	# Load UI HUD
	var hud_scene = load("res://ui/hud.tscn")
	var hud = hud_scene.instantiate()
	add_child(hud)
	
	# Load Main Menu overlay at start in PRE_GAME phase
	var menu_class = load("res://ui/main_menu.gd")
	var menu = menu_class.new()
	add_child(menu)
	
	# Setup starting ships (Scouts) - removed so board starts completely empty

func _process(_delta):
	if placement_active and is_instance_valid(ghost_ship):
		var snap_pos = _get_snapped_mouse_pos()
		ghost_ship.global_position = snap_pos
		
		# Update ranges visual depending on buildability
		if is_position_buildable(snap_pos):
			ghost_ship.selected_range_color = Color(0, 1, 0, 0.4) # Green
		else:
			ghost_ship.selected_range_color = Color(1, 0, 0, 0.4) # Red
		ghost_ship.queue_redraw()
			
	elif repositioning_active and is_instance_valid(ghost_ship):
		var snap_pos = _get_snapped_mouse_pos()
		ghost_ship.global_position = snap_pos
		
		# Update ranges visual depending on buildability
		if is_position_buildable(snap_pos) or (ship_to_reposition and snap_pos.distance_to(ship_to_reposition.global_position) < 10.0):
			ghost_ship.selected_range_color = Color(0, 1, 0, 0.4)
		else:
			ghost_ship.selected_range_color = Color(1, 0, 0, 0.4)
		ghost_ship.queue_redraw()

func _get_snapped_mouse_pos() -> Vector2:
	# Freeform placement returns the raw mouse position instead of grid steps
	return get_global_mouse_position()

func is_position_on_path(pos: Vector2) -> bool:
	var curve = path_node.curve
	for i in range(curve.point_count - 1):
		var p1 = curve.get_point_position(i)
		var p2 = curve.get_point_position(i + 1)
		var closest = Geometry2D.get_closest_point_to_segment(pos, p1, p2)
		# 48px ensures safe clearance from the path center without blocking visual corridors
		if pos.distance_to(closest) < 48.0:
			return true
	return false

func is_tile_occupied(pos: Vector2) -> bool:
	var ships = get_tree().get_nodes_in_group("ships")
	for s in ships:
		if is_instance_valid(s) and not s.is_ghost:
			# Skip checking self during repositioning
			if repositioning_active and s == ship_to_reposition:
				continue
			# Ship square size is 48px, so center-to-center distance must be at least 48px to prevent overlap
			if s.global_position.distance_to(pos) < 48.0:
				return true
	return false

func is_position_buildable(pos: Vector2) -> bool:
	# Keep ship center inside buildable viewport bounds.
	# The right-side HUD panel begins at X=1728. Subtracting 24px ship buffer gives 1704px.
	if pos.x < 24 or pos.x > 1704 or pos.y < 24 or pos.y > 1152 - 24:
		return false
		
	# Overlap path
	if is_position_on_path(pos):
		return false
		
	# Overlap existing tower
	if is_tile_occupied(pos):
		return false
		
	return true

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if placement_active:
			var snap_pos = _get_snapped_mouse_pos()
			if is_position_buildable(snap_pos):
				# Get cost
				var cost = _get_ship_cost(placement_type)
				if EconomyManager.spend_minerals(cost):
					_spawn_placed_ship(placement_type, snap_pos)
					if not Input.is_key_pressed(KEY_SHIFT):
						_cancel_placement()
			get_viewport().set_input_as_handled()
			
		elif repositioning_active:
			var snap_pos = _get_snapped_mouse_pos()
			var dist_to_original = snap_pos.distance_to(ship_to_reposition.global_position) if ship_to_reposition else INF
			
			# If repositioned near the original ship location (within 24px width range), treat as cancel (free)
			if dist_to_original < 24.0:
				_cancel_reposition()
			elif is_position_buildable(snap_pos):
				var cost = EconomyManager.get_reposition_fee(ship_to_reposition.base_cost)
				if EconomyManager.spend_minerals(cost):
					ship_to_reposition.global_position = snap_pos
					# Clear selected state and update panel
					select_ship(ship_to_reposition)
					_cancel_reposition()
			get_viewport().set_input_as_handled()
			
		else:
			# Deselect selection if clicked empty area
			select_ship(null)
			
	elif event.is_action_pressed("ui_cancel") or (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed):
		if placement_active:
			_cancel_placement()
			get_viewport().set_input_as_handled()
		elif repositioning_active:
			_cancel_reposition()
			get_viewport().set_input_as_handled()

func start_placement_mode(type: String):
	if placement_active or repositioning_active:
		_cancel_placement()
		_cancel_reposition()
		
	# Deselect
	select_ship(null)
	
	placement_active = true
	placement_type = type
	
	var ship_scene = load("res://entities/ships/ship.tscn")
	ghost_ship = ship_scene.instantiate()
	ghost_ship.ship_type = type
	ghost_ship.is_ghost = true
	add_child(ghost_ship)
	
	# Set snap position
	ghost_ship.global_position = _get_snapped_mouse_pos()

func _cancel_placement():
	placement_active = false
	placement_type = ""
	if is_instance_valid(ghost_ship):
		ghost_ship.queue_free()
		ghost_ship = null

func start_reposition_mode(ship: Node2D):
	if placement_active or repositioning_active:
		_cancel_placement()
		_cancel_reposition()
		
	repositioning_active = true
	ship_to_reposition = ship
	
	var ship_scene = load("res://entities/ships/ship.tscn")
	ghost_ship = ship_scene.instantiate()
	ghost_ship.ship_type = ship.ship_type
	ghost_ship.is_ghost = true
	add_child(ghost_ship)
	
	# Snap
	ghost_ship.global_position = _get_snapped_mouse_pos()

func _cancel_reposition():
	repositioning_active = false
	ship_to_reposition = null
	if is_instance_valid(ghost_ship):
		ghost_ship.queue_free()
		ghost_ship = null

func _spawn_placed_ship(type: String, pos: Vector2):
	var ship_scene = load("res://entities/ships/ship.tscn")
	var s = ship_scene.instantiate()
	s.ship_type = type
	s.global_position = pos
	add_child(s)

func _get_ship_cost(type: String) -> int:
	match type:
		"Scout": return 75
		"Laser Frigate": return 150
		"Missile Cruiser": return 220
		"Ion Cannon": return 450
		"Drone Carrier": return 550
		"Pulse Beam": return 300
		"Gravity Well": return 600
	return 0

# Called by RoundManager
func spawn_asteroid(tier: int, custom_progress: float, custom_variant: String = "None", custom_elemental: String = "None"):
	var asteroid_scene = load("res://entities/asteroids/asteroid.tscn")
	var a = asteroid_scene.instantiate()
	a.current_tier = tier
	a.variant = custom_variant
	a.elemental_type = custom_elemental
	path_node.add_child(a)
	a.progress = custom_progress

func select_ship(ship: Node2D):
	if selected_ship == ship:
		return
		
	if is_instance_valid(selected_ship):
		selected_ship.is_selected = false
		selected_ship.queue_redraw()
		
	selected_ship = ship
	
	if is_instance_valid(selected_ship):
		selected_ship.is_selected = true
		selected_ship.queue_redraw()
		
	# Notify Ship Management Panel
	get_tree().call_group("hud_ui", "open_ship_panel", selected_ship)

func spawn_nuke_flash():
	var flash = ColorRect.new()
	flash.size = Vector2(2048, 1152)
	flash.color = Color.WHITE
	flash.z_index = 1000
	add_child(flash)
	
	var tween = create_tween()
	tween.tween_property(flash, "modulate:a", 0.0, 1.2)
	tween.tween_callback(flash.queue_free)
