extends Control

var current_ship: Node2D = null

var panel: PanelContainer
var title_label: Label
var target_dropdown: OptionButton
var reposition_btn: Button
var sell_btn: Button

# Upgrades UI
var upgrades_vbox: VBoxContainer
var hot_laser_btn: Button
var cold_laser_btn: Button
var optical_btn: Button

func _ready():
	visible = false
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	# Programmatic visual panel
	panel = PanelContainer.new()
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.04, 0.06, 0.12, 0.9) # Dark translucent
	style.border_width_left = 2
	style.border_width_top = 2
	style.border_width_right = 2
	style.border_width_bottom = 2
	style.border_color = Color(0.3, 0.5, 0.8, 0.7) # Glowing border
	style.corner_radius_top_left = 10
	style.corner_radius_top_right = 10
	style.corner_radius_bottom_left = 10
	style.corner_radius_bottom_right = 10
	panel.add_theme_stylebox_override("panel", style)
	
	panel.custom_minimum_size = Vector2(320, 220)
	add_child(panel)
	
	var margin = MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 16)
	margin.add_theme_constant_override("margin_top", 16)
	margin.add_theme_constant_override("margin_right", 16)
	margin.add_theme_constant_override("margin_bottom", 16)
	panel.add_child(margin)
	
	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 12)
	margin.add_child(vbox)
	
	# Header with title and close
	var header = HBoxContainer.new()
	vbox.add_child(header)
	
	title_label = Label.new()
	title_label.text = "SHIP INFO"
	title_label.add_theme_font_size_override("font_size", 20)
	title_label.size_flags_horizontal = SIZE_EXPAND_FILL
	header.add_child(title_label)
	
	var close_btn = Button.new()
	close_btn.text = "X"
	close_btn.custom_minimum_size = Vector2(24, 24)
	close_btn.pressed.connect(func(): close_panel())
	header.add_child(close_btn)
	
	vbox.add_child(HSeparator.new())
	
	# Targeting dropdown
	var target_box = HBoxContainer.new()
	target_box.add_theme_constant_override("separation", 10)
	vbox.add_child(target_box)
	
	var target_lbl = Label.new()
	target_lbl.text = "Target:"
	target_lbl.add_theme_font_size_override("font_size", 16)
	target_box.add_child(target_lbl)
	
	target_dropdown = OptionButton.new()
	target_dropdown.size_flags_horizontal = SIZE_EXPAND_FILL
	target_dropdown.add_item("First")
	target_dropdown.add_item("Last")
	target_dropdown.add_item("Strongest")
	target_dropdown.add_item("Closest")
	target_dropdown.item_selected.connect(_on_target_mode_selected)
	target_box.add_child(target_dropdown)
	
	vbox.add_child(HSeparator.new())
	
	# Action buttons
	var actions = HBoxContainer.new()
	actions.add_theme_constant_override("separation", 12)
	vbox.add_child(actions)
	
	reposition_btn = Button.new()
	reposition_btn.text = "Reposition\n💎--"
	reposition_btn.size_flags_horizontal = SIZE_EXPAND_FILL
	reposition_btn.custom_minimum_size.y = 52
	reposition_btn.pressed.connect(_on_reposition_pressed)
	
	var repo_style = StyleBoxFlat.new()
	repo_style.bg_color = Color(0.12, 0.2, 0.35, 0.8)
	repo_style.corner_radius_top_left = 6
	repo_style.corner_radius_top_right = 6
	repo_style.corner_radius_bottom_left = 6
	repo_style.corner_radius_bottom_right = 6
	reposition_btn.add_theme_stylebox_override("normal", repo_style)
	reposition_btn.add_theme_stylebox_override("hover", repo_style)
	reposition_btn.add_theme_stylebox_override("pressed", repo_style)
	reposition_btn.add_theme_stylebox_override("disabled", repo_style)
	actions.add_child(reposition_btn)
	
	sell_btn = Button.new()
	sell_btn.text = "Sell\n+💎--"
	sell_btn.size_flags_horizontal = SIZE_EXPAND_FILL
	sell_btn.custom_minimum_size.y = 52
	sell_btn.pressed.connect(_on_sell_pressed)
	
	var sell_style = StyleBoxFlat.new()
	sell_style.bg_color = Color(0.35, 0.12, 0.12, 0.8)
	sell_style.corner_radius_top_left = 6
	sell_style.corner_radius_top_right = 6
	sell_style.corner_radius_bottom_left = 6
	sell_style.corner_radius_bottom_right = 6
	sell_btn.add_theme_stylebox_override("normal", sell_style)
	sell_btn.add_theme_stylebox_override("hover", sell_style)
	sell_btn.add_theme_stylebox_override("pressed", sell_style)
	actions.add_child(sell_btn)
	
	# Upgrades panel VBox Container
	upgrades_vbox = VBoxContainer.new()
	upgrades_vbox.add_theme_constant_override("separation", 8)
	vbox.add_child(upgrades_vbox)
	
	var sep = HSeparator.new()
	upgrades_vbox.add_child(sep)
	
	var upg_lbl = Label.new()
	upg_lbl.text = "Upgrades:"
	upg_lbl.add_theme_font_size_override("font_size", 14)
	upgrades_vbox.add_child(upg_lbl)
	
	var lasers_hbox = HBoxContainer.new()
	lasers_hbox.add_theme_constant_override("separation", 10)
	upgrades_vbox.add_child(lasers_hbox)
	
	hot_laser_btn = Button.new()
	hot_laser_btn.text = "Hot Laser\n🔥 💎 25"
	hot_laser_btn.size_flags_horizontal = SIZE_EXPAND_FILL
	hot_laser_btn.custom_minimum_size.y = 44
	hot_laser_btn.pressed.connect(_on_hot_laser_pressed)
	
	var upg_style = StyleBoxFlat.new()
	upg_style.bg_color = Color(0.08, 0.12, 0.22, 0.8)
	upg_style.corner_radius_top_left = 6
	upg_style.corner_radius_top_right = 6
	upg_style.corner_radius_bottom_left = 6
	upg_style.corner_radius_bottom_right = 6
	hot_laser_btn.add_theme_stylebox_override("normal", upg_style)
	hot_laser_btn.add_theme_stylebox_override("hover", upg_style)
	hot_laser_btn.add_theme_stylebox_override("pressed", upg_style)
	hot_laser_btn.add_theme_stylebox_override("disabled", upg_style)
	lasers_hbox.add_child(hot_laser_btn)
	
	cold_laser_btn = Button.new()
	cold_laser_btn.text = "Cold Laser\n❄️ 💎 30"
	cold_laser_btn.size_flags_horizontal = SIZE_EXPAND_FILL
	cold_laser_btn.custom_minimum_size.y = 44
	cold_laser_btn.pressed.connect(_on_cold_laser_pressed)
	cold_laser_btn.add_theme_stylebox_override("normal", upg_style)
	cold_laser_btn.add_theme_stylebox_override("hover", upg_style)
	cold_laser_btn.add_theme_stylebox_override("pressed", upg_style)
	cold_laser_btn.add_theme_stylebox_override("disabled", upg_style)
	lasers_hbox.add_child(cold_laser_btn)
	
	optical_btn = Button.new()
	optical_btn.text = "Optical Targeting\n🎯 💎 15"
	optical_btn.custom_minimum_size.y = 44
	optical_btn.pressed.connect(_on_optical_pressed)
	optical_btn.add_theme_stylebox_override("normal", upg_style)
	optical_btn.add_theme_stylebox_override("hover", upg_style)
	optical_btn.add_theme_stylebox_override("pressed", upg_style)
	optical_btn.add_theme_stylebox_override("disabled", upg_style)
	upgrades_vbox.add_child(optical_btn)

func open_for_ship(ship: Node2D):
	current_ship = ship
	visible = true
	
	# Update fields
	title_label.text = current_ship.display_name
	
	# Targeting dropdown option index matching mode
	var idx = 0
	match current_ship.targeting_mode:
		"First": idx = 0
		"Last": idx = 1
		"Strongest": idx = 2
		"Closest": idx = 3
	target_dropdown.selected = idx
	
	# Reposition fee
	var repo_fee = EconomyManager.get_reposition_fee(current_ship.base_cost)
	reposition_btn.text = "Reposition\n💎 %d" % repo_fee
	
	# Disable reposition if player cannot afford
	if EconomyManager.can_afford(repo_fee):
		reposition_btn.disabled = false
		reposition_btn.modulate = Color.WHITE
	else:
		reposition_btn.disabled = true
		reposition_btn.modulate = Color(1, 1, 1, 0.4)
		
	# Sell refund based on total net value including upgrades!
	var refund = EconomyManager.get_sell_refund(current_ship.get_total_value())
	sell_btn.text = "Sell\n+💎 %d" % refund
	
	# Handle upgrades panel layout and states dynamically
	if current_ship.ship_type == "Scout" or current_ship.ship_type == "Laser Frigate":
		upgrades_vbox.visible = true
		panel.custom_minimum_size = Vector2(340, 360) # expand size to fit upgrades!
		
		# Optical targeting visibility
		if current_ship.ship_type == "Scout":
			optical_btn.visible = true
			if current_ship.has_optical_targeting:
				optical_btn.disabled = true
				optical_btn.text = "Optical Target [ACTIVE]"
			else:
				optical_btn.disabled = not EconomyManager.can_afford(15)
				optical_btn.text = "Optical Target\n🎯 💎 15"
		else:
			optical_btn.visible = false
			
		# Lasers state
		if current_ship.laser_upgrade == "Hot":
			hot_laser_btn.disabled = true
			hot_laser_btn.text = "Hot Laser [ACTIVE]"
			cold_laser_btn.disabled = true
			cold_laser_btn.text = "Cold Laser"
		elif current_ship.laser_upgrade == "Cold":
			hot_laser_btn.disabled = true
			hot_laser_btn.text = "Hot Laser"
			cold_laser_btn.disabled = true
			cold_laser_btn.text = "Cold Laser [ACTIVE]"
		else:
			hot_laser_btn.disabled = not EconomyManager.can_afford(25)
			hot_laser_btn.text = "Hot Laser\n🔥 💎 25"
			cold_laser_btn.disabled = not EconomyManager.can_afford(30)
			cold_laser_btn.text = "Cold Laser\n❄️ 💎 30"
	else:
		upgrades_vbox.visible = false
		panel.custom_minimum_size = Vector2(320, 220) # normal size
		
	# Positioning near ship and clamping to viewport
	var desired_pos = current_ship.global_position + Vector2(-160, -260)
	global_position = desired_pos.clamp(Vector2(20, 20), Vector2(2048 - 340, 1152 - 380))

func close_panel():
	visible = false
	current_ship = null
	if get_parent().get_parent().selected_ship:
		get_parent().get_parent().select_ship(null)

func _on_target_mode_selected(index: int):
	if not is_instance_valid(current_ship):
		return
	var mode = "First"
	match index:
		0: mode = "First"
		1: mode = "Last"
		2: mode = "Strongest"
		3: mode = "Closest"
	current_ship.targeting_mode = mode

func _on_reposition_pressed():
	if not is_instance_valid(current_ship):
		return
	# Trigger reposition state in main
	get_parent().get_parent().start_reposition_mode(current_ship)
	visible = false

func _on_sell_pressed():
	if not is_instance_valid(current_ship):
		return
		
	var refund = EconomyManager.get_sell_refund(current_ship.get_total_value())
	EconomyManager.add_minerals(refund)
	
	# Delete ship
	current_ship.queue_free()
	close_panel()

func _on_hot_laser_pressed():
	if not is_instance_valid(current_ship):
		return
	if EconomyManager.spend_minerals(25):
		current_ship.laser_upgrade = "Hot"
		current_ship.upgrades_cost += 25
		open_for_ship(current_ship) # refresh panel

func _on_cold_laser_pressed():
	if not is_instance_valid(current_ship):
		return
	if EconomyManager.spend_minerals(30):
		current_ship.laser_upgrade = "Cold"
		current_ship.upgrades_cost += 30
		open_for_ship(current_ship) # refresh panel

func _on_optical_pressed():
	if not is_instance_valid(current_ship):
		return
	if EconomyManager.spend_minerals(15):
		current_ship.has_optical_targeting = true
		current_ship.upgrades_cost += 15
		open_for_ship(current_ship) # refresh panel
