extends Control

func _ready():
	# Full screen layout
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	
	# Cosmic background ColorRect
	var bg = ColorRect.new()
	bg.size = Vector2(2048, 1152)
	bg.color = Color("#070a13") # Even darker space blue
	add_child(bg)
	
	# Concentric background circles for a high-tech radar/tactical scan feel
	for i in range(1, 5):
		var radar_ring = Line2D.new()
		radar_ring.width = 1.0
		radar_ring.default_color = Color("#1e293b", 0.3)
		# Draw a big circle in the middle
		var pts = PackedVector2Array()
		var center = Vector2(2048.0 / 2.0, 1152.0 / 2.0)
		var rad = 150.0 * i
		for j in range(65):
			var a = j * PI * 2.0 / 64.0
			pts.append(center + Vector2.from_angle(a) * rad)
		radar_ring.points = pts
		add_child(radar_ring)

	# Central Dialog Panel container
	var panel = PanelContainer.new()
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.04, 0.06, 0.12, 0.85) # Glassmorphic dark blue
	style.border_width_left = 2
	style.border_width_top = 2
	style.border_width_right = 2
	style.border_width_bottom = 2
	style.border_color = Color(0.2, 0.4, 0.8, 0.5) # Glowing tech border
	style.corner_radius_top_left = 16
	style.corner_radius_top_right = 16
	style.corner_radius_bottom_left = 16
	style.corner_radius_bottom_right = 16
	panel.add_theme_stylebox_override("panel", style)
	
	panel.custom_minimum_size = Vector2(640, 480)
	panel.position = Vector2(2048.0 / 2.0 - 640.0 / 2.0, 1152.0 / 2.0 - 480.0 / 2.0)
	add_child(panel)
	
	var margin = MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 48)
	margin.add_theme_constant_override("margin_top", 48)
	margin.add_theme_constant_override("margin_right", 48)
	margin.add_theme_constant_override("margin_bottom", 48)
	panel.add_child(margin)
	
	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 24)
	margin.add_child(vbox)
	
	# Title Block
	var title = Label.new()
	title.text = "SPACE DEFENDERS"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 48)
	title.add_theme_color_override("font_color", Color("#38bdf8")) # Neon Cyan
	vbox.add_child(title)
	
	var subtitle = Label.new()
	subtitle.text = "ORBITAL HARVEST DEFENSE NETWORK"
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	subtitle.add_theme_font_size_override("font_size", 14)
	subtitle.add_theme_color_override("font_color", Color("#64748b")) # Tech Slate Grey
	vbox.add_child(subtitle)
	
	vbox.add_child(HSeparator.new())
	
	var select_lbl = Label.new()
	select_lbl.text = "SELECT OPERATIONS MODE"
	select_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	select_lbl.add_theme_font_size_override("font_size", 16)
	select_lbl.add_theme_color_override("font_color", Color.WHITE)
	vbox.add_child(select_lbl)
	
	# Normal Mode button
	var btn_normal = Button.new()
	btn_normal.custom_minimum_size.y = 72
	btn_normal.add_theme_font_size_override("font_size", 20)
	btn_normal.text = "NORMAL MODE\n💎 50 | ❤️ 20"
	
	var style_normal = StyleBoxFlat.new()
	style_normal.bg_color = Color(0.08, 0.16, 0.1, 0.8)
	style_normal.border_width_left = 2
	style_normal.border_width_top = 2
	style_normal.border_width_right = 2
	style_normal.border_width_bottom = 2
	style_normal.border_color = Color("#22c55e") # Green
	style_normal.corner_radius_top_left = 8
	style_normal.corner_radius_top_right = 8
	style_normal.corner_radius_bottom_left = 8
	style_normal.corner_radius_bottom_right = 8
	btn_normal.add_theme_stylebox_override("normal", style_normal)
	btn_normal.add_theme_stylebox_override("hover", style_normal)
	btn_normal.add_theme_stylebox_override("pressed", style_normal)
	btn_normal.pressed.connect(_on_normal_pressed)
	vbox.add_child(btn_normal)
	
	# Dev Mode button
	var btn_dev = Button.new()
	btn_dev.custom_minimum_size.y = 72
	btn_dev.add_theme_font_size_override("font_size", 20)
	btn_dev.text = "DEVELOPER MODE\n💎 ♾️ | ❤️ ♾️"
	
	var style_dev = StyleBoxFlat.new()
	style_dev.bg_color = Color(0.08, 0.12, 0.22, 0.8)
	style_dev.border_width_left = 2
	style_dev.border_width_top = 2
	style_dev.border_width_right = 2
	style_dev.border_width_bottom = 2
	style_dev.border_color = Color("#06b6d4") # Cyan
	style_dev.corner_radius_top_left = 8
	style_dev.corner_radius_top_right = 8
	style_dev.corner_radius_bottom_left = 8
	style_dev.corner_radius_bottom_right = 8
	btn_dev.add_theme_stylebox_override("normal", style_dev)
	btn_dev.add_theme_stylebox_override("hover", style_dev)
	btn_dev.add_theme_stylebox_override("pressed", style_dev)
	btn_dev.pressed.connect(_on_dev_pressed)
	vbox.add_child(btn_dev)

func _on_normal_pressed():
	# Configure Normal Mode starting states
	GameManager.dev_mode = false
	GameManager.lives = 20
	EconomyManager.minerals = 50
	
	# Transition Phase to preparing & clear menu overlay
	GameManager.current_phase = GameManager.GamePhase.WAVE_PREPARATION
	queue_free()

func _on_dev_pressed():
	# Configure Dev Mode starting states
	GameManager.dev_mode = true
	GameManager.lives = 99999
	EconomyManager.minerals = 99999
	
	# Transition Phase to preparing & clear menu overlay
	GameManager.current_phase = GameManager.GamePhase.WAVE_PREPARATION
	queue_free()
