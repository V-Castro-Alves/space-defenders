extends CanvasLayer

var lives_label: Label
var minerals_label: Label
var round_label: Label
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
	
	# Create vertical panel Container on the right side of the screen
	# Virtual resolution is 2048 x 1152. Side panel width is 320 px (X: 1728 to 2048)
	var right_panel = PanelContainer.new()
	right_panel.mouse_filter = Control.MOUSE_FILTER_STOP # Block mouse clicks going to game map
	
	var panel_style = StyleBoxFlat.new()
	panel_style.bg_color = Color(0.03, 0.05, 0.1, 0.85) # Dark translucent blue glass
	panel_style.border_width_left = 2
	panel_style.border_color = Color(0.2, 0.4, 0.7, 0.6) # Sleek glowing cyan border on the left
	panel_style.corner_radius_top_left = 0
	panel_style.corner_radius_bottom_left = 0
	right_panel.add_theme_stylebox_override("panel", panel_style)
	
	right_panel.custom_minimum_size = Vector2(320, 1152)
	right_panel.position = Vector2(2048 - 320, 0)
	hud_root.add_child(right_panel)
	
	var margin = MarginContainer.new()
	margin.mouse_filter = Control.MOUSE_FILTER_IGNORE
	margin.add_theme_constant_override("margin_left", 20)
	margin.add_theme_constant_override("margin_top", 30)
	margin.add_theme_constant_override("margin_right", 20)
	margin.add_theme_constant_override("margin_bottom", 30)
	right_panel.add_child(margin)
	
	var main_vbox = VBoxContainer.new()
	main_vbox.mouse_filter = Control.MOUSE_FILTER_IGNORE
	main_vbox.add_theme_constant_override("separation", 24)
	margin.add_child(main_vbox)
	
	# --- Top Section: Status HUD ---
	var status_vbox = VBoxContainer.new()
	status_vbox.mouse_filter = Control.MOUSE_FILTER_IGNORE
	status_vbox.add_theme_constant_override("separation", 12)
	main_vbox.add_child(status_vbox)
	
	# Lives and Minerals HBox (Upper Position, emojis only)
	var resources_hbox = HBoxContainer.new()
	resources_hbox.mouse_filter = Control.MOUSE_FILTER_IGNORE
	resources_hbox.add_theme_constant_override("separation", 24)
	status_vbox.add_child(resources_hbox)
	
	# Lives Label
	lives_label = Label.new()
	lives_label.text = "❤️ 20"
	lives_label.add_theme_font_size_override("font_size", 26)
	lives_label.add_theme_color_override("font_color", Color("#ef4444")) # Red
	lives_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	resources_hbox.add_child(lives_label)
	
	# Minerals Label
	minerals_label = Label.new()
	minerals_label.text = "💎 50"
	minerals_label.add_theme_font_size_override("font_size", 26)
	minerals_label.add_theme_color_override("font_color", Color("#06b6d4")) # Cyan
	resources_hbox.add_child(minerals_label)
	
	# Round Label (Directly underneath resources, text only)
	round_label = Label.new()
	round_label.text = "ROUND: 0 / 10"
	round_label.add_theme_font_size_override("font_size", 22)
	round_label.add_theme_color_override("font_color", Color("#f97316")) # Orange
	status_vbox.add_child(round_label)
	
	# Small separator between status and shop list
	status_vbox.add_child(HSeparator.new())
	
	# --- Middle Section: Vertical Shop ---
	var shop_label = Label.new()
	shop_label.text = "STARFLEET FACTORY"
	shop_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	shop_label.add_theme_font_size_override("font_size", 16)
	shop_label.add_theme_color_override("font_color", Color("#64748b")) # Tech slate
	main_vbox.add_child(shop_label)
	
	var shop_scroll = ScrollContainer.new()
	shop_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	shop_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	main_vbox.add_child(shop_scroll)
	
	var shop_vbox = VBoxContainer.new()
	shop_vbox.mouse_filter = Control.MOUSE_FILTER_IGNORE
	shop_vbox.add_theme_constant_override("separation", 14)
	shop_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	shop_scroll.add_child(shop_vbox)
	
	# The 7 ship registry items
	var shop_items = [
		{"name": "Scout", "cost": 75, "color": Color("#22c55e")},
		{"name": "Laser Frigate", "cost": 150, "color": Color("#06b6d4")},
		{"name": "Missile Cruiser", "cost": 220, "color": Color("#a855f7")},
		{"name": "Pulse Beam", "cost": 300, "color": Color("#f59e0b")},
		{"name": "Ion Cannon", "cost": 450, "color": Color("#3b82f6")},
		{"name": "Drone Carrier", "cost": 550, "color": Color("#ec4899")},
		{"name": "Gravity Well", "cost": 600, "color": Color("#ffffff")}
	]
	
	for item in shop_items:
		var btn = Button.new()
		btn.custom_minimum_size = Vector2(280, 72)
		btn.add_theme_font_size_override("font_size", 16)
		btn.text = "%s\n💎 %d" % [item["name"], item["cost"]]
		
		# Stylized flat state
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
		shop_vbox.add_child(btn)
		
		# Save references
		shop_buttons[item["name"]] = {"button": btn, "cost": item["cost"], "color": item["color"]}
		
	# --- Bottom Section: Fixed Launch/Speed Up Button ---
	launch_btn = Button.new()
	launch_btn.text = "START ROUND 1"
	launch_btn.custom_minimum_size = Vector2(280, 88)
	launch_btn.add_theme_font_size_override("font_size", 22)
	
	# Handles dynamic callback checking phase state
	launch_btn.pressed.connect(func():
		if GameManager.current_phase == GameManager.GamePhase.ROUND_ACTIVE:
			GameManager.toggle_speed()
		else:
			RoundManager.start_round()
	)
	main_vbox.add_child(launch_btn)
	
	# Floating Ship Upgrade Panel
	var panel_scene = load("res://ui/ship_panel.tscn")
	ship_panel = panel_scene.instantiate()
	add_child(ship_panel)
	
	# Connect to singletons
	GameManager.lives_changed.connect(_on_lives_changed)
	GameManager.speed_changed.connect(_on_speed_changed)
	GameManager.phase_changed.connect(_on_phase_changed)
	EconomyManager.minerals_changed.connect(_on_minerals_changed)
	RoundManager.round_changed.connect(_on_round_changed)
	RoundManager.round_started.connect(_on_round_started)
	RoundManager.round_completed.connect(_on_round_completed)
	
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
		lives_label.text = "❤️ ♾️"
		minerals_label.text = "💎 ♾️"
	else:
		lives_label.text = "❤️ %d" % GameManager.lives
		minerals_label.text = "💎 %d" % EconomyManager.minerals
		
	round_label.text = "ROUND: %d / 10" % RoundManager.current_round
	
	# Launch/Speed toggle state
	if GameManager.current_phase == GameManager.GamePhase.ROUND_ACTIVE:
		launch_btn.disabled = false
		launch_btn.text = "SPEED: %.0fx" % GameManager.speed_multiplier
		
		var style_speed = StyleBoxFlat.new()
		style_speed.bg_color = Color("#3b82f6") # Blue
		style_speed.corner_radius_top_left = 8
		style_speed.corner_radius_top_right = 8
		style_speed.corner_radius_bottom_left = 8
		style_speed.corner_radius_bottom_right = 8
		launch_btn.add_theme_stylebox_override("normal", style_speed)
		launch_btn.add_theme_stylebox_override("hover", style_speed)
		launch_btn.add_theme_stylebox_override("pressed", style_speed)
		
	elif GameManager.current_phase == GameManager.GamePhase.GAME_OVER:
		launch_btn.disabled = true
		launch_btn.text = "GAME OVER"
		var style_disabled = StyleBoxFlat.new()
		style_disabled.bg_color = Color(0.2, 0.2, 0.2, 0.8)
		style_disabled.corner_radius_top_left = 8
		style_disabled.corner_radius_top_right = 8
		style_disabled.corner_radius_bottom_left = 8
		style_disabled.corner_radius_bottom_right = 8
		launch_btn.add_theme_stylebox_override("disabled", style_disabled)
		
	elif GameManager.current_phase == GameManager.GamePhase.GAME_WON:
		launch_btn.disabled = true
		launch_btn.text = "VICTORY!"
		var style_disabled = StyleBoxFlat.new()
		style_disabled.bg_color = Color(0.2, 0.2, 0.2, 0.8)
		style_disabled.corner_radius_top_left = 8
		style_disabled.corner_radius_top_right = 8
		style_disabled.corner_radius_bottom_left = 8
		style_disabled.corner_radius_bottom_right = 8
		launch_btn.add_theme_stylebox_override("disabled", style_disabled)
		
	else:
		launch_btn.disabled = false
		launch_btn.text = "START ROUND %d" % (RoundManager.current_round + 1)
		
		var style_launch = StyleBoxFlat.new()
		style_launch.bg_color = Color("#16a34a") # Green
		style_launch.corner_radius_top_left = 8
		style_launch.corner_radius_top_right = 8
		style_launch.corner_radius_bottom_left = 8
		style_launch.corner_radius_bottom_right = 8
		launch_btn.add_theme_stylebox_override("normal", style_launch)
		launch_btn.add_theme_stylebox_override("hover", style_launch)
		launch_btn.add_theme_stylebox_override("pressed", style_launch)

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

func _on_round_changed(_val):
	_update_hud()

func _on_round_started(_val):
	_update_hud()

func _on_round_completed(_val, _no_leak):
	_update_hud()

func _on_phase_changed(_val):
	_update_hud()

func open_ship_panel(ship: Node2D):
	if is_instance_valid(ship):
		ship_panel.open_for_ship(ship)
	else:
		ship_panel.close_panel()
