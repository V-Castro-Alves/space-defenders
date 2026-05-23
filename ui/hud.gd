extends CanvasLayer

var lives_label: Label
var minerals_label: Label
var wave_label: Label
var speed_btn: Button
var launch_btn: Button
var shop_buttons: Dictionary = {}

var ship_panel: Control
var hud_root: Control

func _ready():
	# Screen boundaries (Control node setup)
	hud_root = Control.new()
	hud_root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	hud_root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(hud_root)
	
	# Top bar container
	var top_bar = HBoxContainer.new()
	top_bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	top_bar.set_anchors_and_offsets_preset(Control.PRESET_TOP_LEFT)
	top_bar.position = Vector2(40, 30)
	top_bar.add_theme_constant_override("separation", 24)
	hud_root.add_child(top_bar)
	
	# Styles for Panels (Glassmorphism styling)
	var panel_style = StyleBoxFlat.new()
	panel_style.bg_color = Color(0.05, 0.08, 0.15, 0.75) # Dark translucent blue
	panel_style.border_width_left = 1
	panel_style.border_width_top = 1
	panel_style.border_width_right = 1
	panel_style.border_width_bottom = 1
	panel_style.border_color = Color(0.2, 0.3, 0.5, 0.5) # Soft cyan/blue outline
	panel_style.corner_radius_top_left = 8
	panel_style.corner_radius_top_right = 8
	panel_style.corner_radius_bottom_left = 8
	panel_style.corner_radius_bottom_right = 8
	
	# 1. Lives Display
	var lives_panel = PanelContainer.new()
	lives_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	lives_panel.add_theme_stylebox_override("panel", panel_style)
	top_bar.add_child(lives_panel)
	
	var lives_margin = MarginContainer.new()
	lives_margin.mouse_filter = Control.MOUSE_FILTER_IGNORE
	lives_margin.add_theme_constant_override("margin_left", 20)
	lives_margin.add_theme_constant_override("margin_top", 10)
	lives_margin.add_theme_constant_override("margin_right", 20)
	lives_margin.add_theme_constant_override("margin_bottom", 10)
	lives_panel.add_child(lives_margin)
	
	lives_label = Label.new()
	lives_label.text = "❤️ LIVES: 20"
	lives_label.add_theme_font_size_override("font_size", 24)
	lives_label.add_theme_color_override("font_color", Color("#ef4444")) # Bright red
	lives_margin.add_child(lives_label)
	
	# 2. Minerals Display
	var minerals_panel = PanelContainer.new()
	minerals_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	minerals_panel.add_theme_stylebox_override("panel", panel_style)
	top_bar.add_child(minerals_panel)
	
	var minerals_margin = MarginContainer.new()
	minerals_margin.mouse_filter = Control.MOUSE_FILTER_IGNORE
	minerals_margin.add_theme_constant_override("margin_left", 20)
	minerals_margin.add_theme_constant_override("margin_top", 10)
	minerals_margin.add_theme_constant_override("margin_right", 20)
	minerals_margin.add_theme_constant_override("margin_bottom", 10)
	minerals_panel.add_child(minerals_margin)
	
	minerals_label = Label.new()
	minerals_label.text = "💎 MINERALS: 50"
	minerals_label.add_theme_font_size_override("font_size", 24)
	minerals_label.add_theme_color_override("font_color", Color("#06b6d4")) # Bright cyan
	minerals_margin.add_child(minerals_label)
	
	# 3. Wave Display
	var wave_panel = PanelContainer.new()
	wave_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	wave_panel.add_theme_stylebox_override("panel", panel_style)
	top_bar.add_child(wave_panel)
	
	var wave_margin = MarginContainer.new()
	wave_margin.mouse_filter = Control.MOUSE_FILTER_IGNORE
	wave_margin.add_theme_constant_override("margin_left", 20)
	wave_margin.add_theme_constant_override("margin_top", 10)
	wave_margin.add_theme_constant_override("margin_right", 20)
	wave_margin.add_theme_constant_override("margin_bottom", 10)
	wave_panel.add_child(wave_margin)
	
	wave_label = Label.new()
	wave_label.text = "🌊 WAVE: 0 / 10"
	wave_label.add_theme_font_size_override("font_size", 24)
	wave_label.add_theme_color_override("font_color", Color("#f97316")) # Bright orange
	wave_margin.add_child(wave_label)
	
	# 4. Speed Toggle Button
	speed_btn = Button.new()
	speed_btn.text = "SPEED: 1x"
	speed_btn.custom_minimum_size = Vector2(160, 48)
	speed_btn.add_theme_font_size_override("font_size", 20)
	speed_btn.pressed.connect(func(): GameManager.toggle_speed())
	
	var speed_style_normal = StyleBoxFlat.new()
	speed_style_normal.bg_color = Color(0.1, 0.15, 0.25, 0.8)
	speed_style_normal.corner_radius_top_left = 8
	speed_style_normal.corner_radius_top_right = 8
	speed_style_normal.corner_radius_bottom_left = 8
	speed_style_normal.corner_radius_bottom_right = 8
	speed_btn.add_theme_stylebox_override("normal", speed_style_normal)
	speed_btn.add_theme_stylebox_override("hover", speed_style_normal)
	speed_btn.add_theme_stylebox_override("pressed", speed_style_normal)
	top_bar.add_child(speed_btn)
	
	# Bottom Shop Container snapped to bottom-center
	var shop_panel_container = PanelContainer.new()
	shop_panel_container.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var shop_style = StyleBoxFlat.new()
	shop_style.bg_color = Color(0.03, 0.05, 0.1, 0.85) # Very dark translucent blue
	shop_style.border_width_left = 2
	shop_style.border_width_top = 2
	shop_style.border_width_right = 2
	shop_style.border_width_bottom = 2
	shop_style.border_color = Color(0.2, 0.4, 0.7, 0.6) # Sleek borders
	shop_style.corner_radius_top_left = 12
	shop_style.corner_radius_top_right = 12
	shop_style.corner_radius_bottom_left = 0
	shop_style.corner_radius_bottom_right = 0
	shop_panel_container.add_theme_stylebox_override("panel", shop_style)
	
	# Positioning shop container
	shop_panel_container.custom_minimum_size = Vector2(1540, 136)
	shop_panel_container.position = Vector2(2048.0 / 2.0 - 1540.0 / 2.0, 1152.0 - 136.0)
	hud_root.add_child(shop_panel_container)
	
	var shop_margin = MarginContainer.new()
	shop_margin.mouse_filter = Control.MOUSE_FILTER_IGNORE
	shop_margin.add_theme_constant_override("margin_left", 24)
	shop_margin.add_theme_constant_override("margin_top", 12)
	shop_margin.add_theme_constant_override("margin_right", 24)
	shop_margin.add_theme_constant_override("margin_bottom", 12)
	shop_panel_container.add_child(shop_margin)
	
	var shop_hbox = HBoxContainer.new()
	shop_hbox.mouse_filter = Control.MOUSE_FILTER_IGNORE
	shop_hbox.add_theme_constant_override("separation", 24)
	shop_margin.add_child(shop_hbox)
	
	# Registering the 7 shop items [Ship Name, cost, color]
	var shop_items = [
		{"name": "Scout", "cost": 20, "color": Color("#22c55e")},
		{"name": "Laser Frigate", "cost": 35, "color": Color("#06b6d4")},
		{"name": "Missile Cruiser", "cost": 45, "color": Color("#a855f7")},
		{"name": "Pulse Beam", "cost": 55, "color": Color("#f59e0b")},
		{"name": "Ion Cannon", "cost": 60, "color": Color("#3b82f6")},
		{"name": "Drone Carrier", "cost": 75, "color": Color("#ec4899")},
		{"name": "Gravity Well", "cost": 80, "color": Color("#ffffff")}
	]
	
	for item in shop_items:
		var btn = Button.new()
		btn.custom_minimum_size = Vector2(190, 88)
		btn.add_theme_font_size_override("font_size", 16)
		btn.text = "%s\n💎 %d" % [item["name"], item["cost"]]
		
		# Stylized normal state
		var btn_style = StyleBoxFlat.new()
		btn_style.bg_color = Color(0.08, 0.12, 0.22, 0.8)
		btn_style.border_width_left = 2
		btn_style.border_width_top = 2
		btn_style.border_width_right = 2
		btn_style.border_width_bottom = 2
		btn_style.border_color = item["color"]
		btn_style.corner_radius_top_left = 6
		btn_style.corner_radius_top_right = 6
		btn_style.corner_radius_bottom_left = 6
		btn_style.corner_radius_bottom_right = 6
		btn.add_theme_stylebox_override("normal", btn_style)
		btn.add_theme_stylebox_override("hover", btn_style)
		btn.add_theme_stylebox_override("pressed", btn_style)
		btn.add_theme_stylebox_override("disabled", btn_style)
		
		btn.pressed.connect(func(): get_parent().start_placement_mode(item["name"]))
		shop_hbox.add_child(btn)
		
		# Save reference to adjust disabled state based on minerals
		shop_buttons[item["name"]] = {"button": btn, "cost": item["cost"], "color": item["color"]}
		
	# 5. Launch Wave Button at bottom-right
	launch_btn = Button.new()
	launch_btn.text = "LAUNCH WAVE 1"
	launch_btn.custom_minimum_size = Vector2(280, 88)
	launch_btn.position = Vector2(2048 - 320, 1152 - 112)
	launch_btn.add_theme_font_size_override("font_size", 24)
	
	var launch_style = StyleBoxFlat.new()
	launch_style.bg_color = Color("#16a34a") # Emerald green
	launch_style.corner_radius_top_left = 8
	launch_style.corner_radius_top_right = 8
	launch_style.corner_radius_bottom_left = 8
	launch_style.corner_radius_bottom_right = 8
	launch_btn.add_theme_stylebox_override("normal", launch_style)
	launch_btn.add_theme_stylebox_override("hover", launch_style)
	launch_btn.add_theme_stylebox_override("pressed", launch_style)
	launch_btn.add_theme_stylebox_override("disabled", launch_style)
	
	launch_btn.pressed.connect(func(): WaveManager.start_wave())
	hud_root.add_child(launch_btn)
	
	# Context Ship Panel upgrade/sell/reposition
	var panel_scene = load("res://ui/ship_panel.tscn")
	ship_panel = panel_scene.instantiate()
	add_child(ship_panel)
	
	# Connect to singletons
	GameManager.lives_changed.connect(_on_lives_changed)
	GameManager.speed_changed.connect(_on_speed_changed)
	GameManager.phase_changed.connect(_on_phase_changed)
	EconomyManager.minerals_changed.connect(_on_minerals_changed)
	WaveManager.wave_changed.connect(_on_wave_changed)
	WaveManager.wave_started.connect(_on_wave_started)
	WaveManager.wave_completed.connect(_on_wave_completed)
	
	# Initial updates
	_update_hud()
	_update_shop_buttons()

func _update_hud():
	if GameManager.current_phase == GameManager.GamePhase.PRE_GAME:
		hud_root.visible = false
		return
	else:
		hud_root.visible = true
		
	# Format Dev Mode text beautifully
	if GameManager.dev_mode:
		lives_label.text = "❤️ LIVES: ♾️"
		minerals_label.text = "💎 MINERALS: ♾️"
	else:
		lives_label.text = "❤️ LIVES: %d / 20" % GameManager.lives
		minerals_label.text = "💎 MINERALS: %d" % EconomyManager.minerals
		
	wave_label.text = "🌊 WAVE: %d / 10" % WaveManager.current_wave
	speed_btn.text = "SPEED: %.0fx" % GameManager.speed_multiplier
	
	# Launch Wave text
	if GameManager.current_phase == GameManager.GamePhase.WAVE_ACTIVE:
		launch_btn.disabled = true
		launch_btn.text = "WAVE IN PROGRESS"
		var launch_style_disabled = launch_btn.get_theme_stylebox("disabled").duplicate()
		launch_style_disabled.bg_color = Color(0.2, 0.2, 0.2, 0.8)
		launch_btn.add_theme_stylebox_override("disabled", launch_style_disabled)
	elif GameManager.current_phase == GameManager.GamePhase.GAME_OVER:
		launch_btn.disabled = true
		launch_btn.text = "GAME OVER"
	elif GameManager.current_phase == GameManager.GamePhase.GAME_WON:
		launch_btn.disabled = true
		launch_btn.text = "VICTORY!"
	else:
		launch_btn.disabled = false
		launch_btn.text = "LAUNCH WAVE %d" % (WaveManager.current_wave + 1)
		var launch_style_normal = launch_btn.get_theme_stylebox("normal").duplicate()
		launch_style_normal.bg_color = Color("#16a34a")
		launch_btn.add_theme_stylebox_override("normal", launch_style_normal)

func _update_shop_buttons():
	var balance = EconomyManager.minerals
	for key in shop_buttons.keys():
		var data = shop_buttons[key]
		var btn = data["button"] as Button
		var cost = data["cost"] as int
		
		var style = btn.get_theme_stylebox("normal").duplicate() as StyleBoxFlat
		if balance >= cost:
			btn.disabled = false
			btn.modulate = Color.WHITE
			style.bg_color = Color(0.08, 0.12, 0.22, 0.85)
		else:
			# Visual gray out if unaffordable
			btn.disabled = true
			btn.modulate = Color(1.0, 1.0, 1.0, 0.35)
			style.bg_color = Color(0.05, 0.05, 0.08, 0.9)
			
		btn.add_theme_stylebox_override("normal", style)
		btn.add_theme_stylebox_override("disabled", style)

func _on_lives_changed(_val):
	_update_hud()

func _on_speed_changed(_val):
	_update_hud()

func _on_minerals_changed(_val):
	_update_hud()
	_update_shop_buttons()

func _on_wave_changed(_val):
	_update_hud()

func _on_wave_started(_val):
	_update_hud()

func _on_wave_completed(_val, _no_leak):
	_update_hud()

func _on_phase_changed(_val):
	_update_hud()

# Floating Ship Panel controller
func open_ship_panel(ship: Node2D):
	if is_instance_valid(ship):
		ship_panel.open_for_ship(ship)
	else:
		ship_panel.close_panel()
