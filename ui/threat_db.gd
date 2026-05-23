extends Control

# Custom Control node to programmatically draw exact asteroid previews
class ThreatPreview extends Control:
	var current_tier: int = 1
	var variant: String = "None"
	var elemental_type: String = "None"
	var draw_size: float = 32.0
	var color: Color = Color.WHITE

	func setup_preview(t: int, v: String, e: String):
		current_tier = t
		variant = v
		elemental_type = e
		
		# Map tier sizes and colors matching asteroid.gd
		match current_tier:
			5:
				draw_size = 64.0
				color = Color("#7f1d1d")
			4:
				draw_size = 48.0
				color = Color("#dc2626")
			3:
				draw_size = 36.0
				color = Color("#ea580c")
			2:
				draw_size = 24.0
				color = Color("#f97316")
			1:
				draw_size = 16.0
				color = Color("#eab308")
				
		custom_minimum_size = Vector2(80, 80)
		queue_redraw()

	func _draw():
		var center = size / 2.0
		var draw_color = color
		if elemental_type == "Ice":
			draw_color = Color("#bae6fd") # Ice pale blue
		elif elemental_type == "Lava":
			draw_color = Color("#f97316") # Molten orange
			
		# Draw solid square representing the asteroid centered
		var rect = Rect2(center.x - draw_size / 2, center.y - draw_size / 2, draw_size, draw_size)
		draw_rect(rect, draw_color)
		# Subtle dark inner border to give dimension
		draw_rect(rect, Color(0, 0, 0, 0.4), false, 2.0)
		
		# Frosted ice cracks or Lava molten veins
		if elemental_type == "Ice":
			draw_line(center + Vector2(-draw_size/3, -draw_size/3), center + Vector2(draw_size/3, draw_size/3), Color("#f0f9ff", 0.5), 1.0)
			draw_line(center + Vector2(draw_size/4, -draw_size/4), center + Vector2(-draw_size/4, draw_size/4), Color("#f0f9ff", 0.5), 1.0)
		elif elemental_type == "Lava":
			draw_line(center + Vector2(-draw_size/3, 0), center + Vector2(draw_size/3, 0), Color("#fef08a", 0.6), 1.5)
			draw_line(center + Vector2(0, -draw_size/3), center + Vector2(0, draw_size/3), Color("#fef08a", 0.6), 1.5)
		
		# Draw variant visual layers
		match variant:
			"Hard Crust":
				draw_rect(Rect2(center.x - draw_size / 4, center.y - draw_size / 4, draw_size / 2, draw_size / 2), Color(0.1, 0.1, 0.1, 0.6))
				draw_rect(Rect2(center.x - draw_size / 4, center.y - draw_size / 4, draw_size / 2, draw_size / 2), Color.BLACK, false, 1.0)
			"Magnetic Core":
				var aura_color = Color("#60a5fa")
				aura_color.a = 0.25
				draw_circle(center, draw_size * 0.8, aura_color)
				draw_arc(center, draw_size * 0.8, 0, 2*PI, 32, Color("#3b82f6", 0.4), 1.0)
			"Ring Belt":
				var ring_color = Color("#94a3b8")
				ring_color.a = 0.6
				draw_arc(center, draw_size * 0.9, 0, 2*PI, 16, ring_color, 1.5, true)
			"Blinding Tail":
				var tail_color = Color("#fbbf24")
				tail_color.a = 0.7
				draw_circle(center + Vector2(-draw_size/3, 0), draw_size/4, tail_color)


# Custom Control node to programmatically draw exact ship previews
class ShipPreview extends Control:
	var ship_type: String = "Scout"
	var ship_color: Color = Color("#22c55e")
	
	func setup_preview(type: String):
		ship_type = type
		match ship_type:
			"Scout": ship_color = Color("#22c55e")
			"Laser Frigate": ship_color = Color("#06b6d4")
			"Missile Cruiser": ship_color = Color("#a855f7")
			"Pulse Beam": ship_color = Color("#f59e0b")
			"Ion Cannon": ship_color = Color("#3b82f6")
			"Drone Carrier": ship_color = Color("#ec4899")
			"Gravity Well": ship_color = Color("#ffffff")
			
		custom_minimum_size = Vector2(80, 80)
		queue_redraw()

	func _draw():
		var center = size / 2.0
		# Draw solid square representing ship centered (48x48 box)
		var rect = Rect2(center.x - 24, center.y - 24, 48, 48)
		draw_rect(rect, ship_color)
		draw_rect(rect, Color.BLACK, false, 2.0)
		
		# Type specifics visual decoration inside square
		match ship_type:
			"Scout":
				draw_line(center + Vector2(0, -16), center + Vector2(-12, 12), Color.BLACK, 2.0)
				draw_line(center + Vector2(0, -16), center + Vector2(12, 12), Color.BLACK, 2.0)
				draw_line(center + Vector2(-12, 12), center + Vector2(0, 4), Color.BLACK, 2.0)
				draw_line(center + Vector2(12, 12), center + Vector2(0, 4), Color.BLACK, 2.0)
			"Laser Frigate":
				draw_circle(center, 8.0, Color.BLACK)
				draw_circle(center, 4.0, Color.WHITE)
			"Missile Cruiser":
				draw_rect(Rect2(center.x - 6, center.y - 18, 12, 36), Color.BLACK)
				draw_rect(Rect2(center.x - 18, center.y - 6, 36, 12), Color.BLACK)
			"Pulse Beam":
				draw_arc(center, 8.0, -PI/4, PI/4, 8, Color.BLACK, 2.0)
				draw_arc(center, 14.0, -PI/4, PI/4, 8, Color.BLACK, 2.0)
				draw_line(center, center + Vector2(12, 0), Color.BLACK, 2.0)
			"Ion Cannon":
				draw_rect(Rect2(center.x - 8, center.y - 20, 16, 12), Color.BLACK)
			"Drone Carrier":
				draw_circle(center, 6.0, Color.BLACK)
				# Orbiting drones mini layout
				for i in range(3):
					var angle = (i * PI * 2.0 / 3.0) + PI/6.0
					var drone_pos = center + Vector2.from_angle(angle) * 44.0
					draw_rect(Rect2(drone_pos.x - 6, drone_pos.y - 6, 12, 12), Color("#f472b6"))
					draw_rect(Rect2(drone_pos.x - 6, drone_pos.y - 6, 12, 12), Color.BLACK, false, 1.0)
			"Gravity Well":
				draw_circle(center, 16.0, Color.BLACK, false, 1.5)
				draw_circle(center, 8.0, Color.BLACK, false, 1.5)
				draw_circle(center, 3.0, Color.BLACK)


var current_profile: Dictionary = {}
var active_tab: String = "Threats"

var profiles: Dictionary = {
	"Pebble": {
		"title": "PEBBLE (TIER 1 THREAT)",
		"tier": 1, "variant": "None", "element": "None",
		"integrity": "1 Hit", "speed": "180 px/s (Swift)", "penalty": "1 Life",
		"desc": "Small, swift space debris fragments. Pebbles move quickly but have zero armor structures.",
		"advice": "Scouts are highly cost-efficient counters due to rapid direct shots."
	},
	"Boulder": {
		"title": "BOULDER (TIER 2 THREAT)",
		"tier": 2, "variant": "None", "element": "None",
		"integrity": "2 Hits (HP)", "speed": "130 px/s (Moderate)", "penalty": "4 Lives",
		"desc": "Moderate-sized metamorphic rock. Boulder Integrity requires 2 hits before splitting.",
		"advice": "Splits into 2 Pebbles. Build early coverage to clear cascading splits."
	},
	"Meteor": {
		"title": "METEOR (TIER 3 THREAT)",
		"tier": 3, "variant": "None", "element": "None",
		"integrity": "3 Hits (HP)", "speed": "90 px/s (Medium)", "penalty": "8 Lives",
		"desc": "Heavy incoming asteroid cores. Meteors split into 2 Boulders, cascading into 4 Pebbles.",
		"advice": "Drone Carrier drones deal 0 damage due to crust density. Deploy heavy ships."
	},
	"Giant": {
		"title": "GIANT (TIER 4 THREAT)",
		"tier": 4, "variant": "None", "element": "None",
		"integrity": "4 Hits (HP)", "speed": "60 px/s (Slow)", "penalty": "16 Lives",
		"desc": "Massive monolithic space rock chunk. Extremely high cumulative split hits required.",
		"advice": "Deploy Laser Frigates for pierce sweep, or Ion Cannons to shred high HP tiers."
	},
	"Planet Chunk": {
		"title": "PLANET CHUNK (TIER 5 THREAT)",
		"tier": 5, "variant": "None", "element": "None",
		"integrity": "5 Hits (HP)", "speed": "40 px/s (Very Slow)", "penalty": "32 Lives (Instant Death)",
		"desc": "Colossal remnant core. Leaking a single Planet Chunk triggers an immediate GAME OVER.",
		"advice": "Prioritize with Ion Cannons and freeze with Gravity Wells in looped pathways."
	},
	"Hard Crust": {
		"title": "HARD CRUST VARIANT",
		"tier": 3, "variant": "Hard Crust", "element": "None",
		"integrity": "+0 HP (Absorbs Weak)", "speed": "Base Tier Speed", "penalty": "Base Tier Penalty",
		"desc": "Armored space rock variant covered in high-density basalt plates.",
		"advice": "Absorbs ALL weak shots entirely (Scouts, Missile splash, Drones). Use Ion or Pierce shots."
	},
	"Magnetic Core": {
		"title": "MAGNETIC CORE VARIANT",
		"tier": 3, "variant": "Magnetic Core", "element": "None",
		"integrity": "Regenerates 0.5 HP/s", "speed": "Base Tier Speed", "penalty": "Base Tier Penalty",
		"desc": "Shielded variant creating localized electromagnetic fields that restore HP automatically.",
		"advice": "HP heals to max after 4.0s idle. Focus-fire or hit with Pulse Beam to pause regen for 2.0s."
	},
	"Ring Belt": {
		"title": "RING BELT VARIANT",
		"tier": 4, "variant": "Ring Belt", "element": "None",
		"integrity": "Splash Deflector", "speed": "Base Tier Speed", "penalty": "Base Tier Penalty",
		"desc": "Asteroids surrounded by a spinning orbital belt of sand and granular debris.",
		"advice": "Deflects all splash/AoE damage and drone strikes entirely. Use Scout direct focused fire."
	},
	"Blinding Tail": {
		"title": "BLINDING TAIL VARIANT",
		"tier": 3, "variant": "Blinding Tail", "element": "None",
		"integrity": "Targeting Swallower", "speed": "Base Tier Speed", "penalty": "Base Tier Penalty",
		"desc": "Comet-like streaks of ionization dust that occlude visual trackers within 3.0 tiles (192px).",
		"advice": "Blinds Scouts, Missile Cruisers, and Drones. Use Laser Frigates/Ions, or Scout Optical Upgrades."
	},
	"Ice Elemental": {
		"title": "❄️ ICE ELEMENTAL SUB-TYPE",
		"tier": 3, "variant": "None", "element": "Ice",
		"integrity": "Laser Vulnerable", "speed": "Base Tier Speed", "penalty": "Base Tier Penalty",
		"desc": "Rare cryogenic core sub-type interacting dynamically with laser thermal frequencies.",
		"advice": "Hot Laser melts it cleanly. Cold Laser shatters it, triggering a 2.0-tile shrapnel burst."
	},
	"Lava Elemental": {
		"title": "🌋 LAVA ELEMENTAL SUB-TYPE",
		"tier": 3, "variant": "None", "element": "Lava",
		"integrity": "Laser Vulnerable", "speed": "Base Tier Speed", "penalty": "Base Tier Penalty",
		"desc": "Rare volcanic molten sub-type interacting dynamically with laser thermal frequencies.",
		"advice": "Cold Laser solidifies it (0 damage conversion). Hot Laser triggers massive Overload explosion."
	}
}

var ship_profiles: Dictionary = {
	"Scout": {
		"title": "STARFLEET SCOUT (LIGHT INTERCEPTOR)",
		"cost": "💎 75 Minerals", "range": "1.5 Tiles (96 px)", "damage": "1 Hit (Direct Shot)", "fire_rate": "1.0 shots/s",
		"desc": "Light combat vessel designed for high-frequency direct engagements. Rapid fire rate and low cost make it exceptionally reliable.",
		"advice": "Upgradable with Hot/Cold Laser and Optical Targeting. Ideal for Pebble cleanup and Blinding Tail bypass."
	},
	"Laser Frigate": {
		"title": "LASER FRIGATE (PIERCING SCANNER)",
		"cost": "💎 150 Minerals", "range": "3.0 Tiles (192 px)", "damage": "2 Hits (Linear Pierce)", "fire_rate": "1.0 shots/s",
		"desc": "Heavy line-of-sight cruiser projecting concentrated laser beams that pierce all targets in their vector path.",
		"advice": "Align along straight lanes for maximum traversal coverage. Upgradable with Hot/Cold Laser options."
	},
	"Missile Cruiser": {
		"title": "MISSILE CRUISER (HEAVY ARTILLERY)",
		"cost": "💎 220 Minerals", "range": "2.5 Tiles (160 px)", "damage": "1 Hit (96px Splash Area)", "fire_rate": "0.8 shots/s",
		"desc": "Tactical support platform launching long-range high-explosive missiles that deal wide area splash damage.",
		"advice": "Deploy at tight loops and intersections. Highly vulnerable to Ring Belt and Hard Crust defensive structures."
	},
	"Pulse Beam": {
		"title": "PULSE BEAM (KINETIC CONE SWEEPER)",
		"cost": "💎 300 Minerals", "range": "2.0 Tiles (128 px)", "damage": "1 Hit (90° Sweeping Cone)", "fire_rate": "0.5 shots/s",
		"desc": "Dynamic tactical suppressor. Evaluates the local space sector to locate the densest cluster of threats and sweeps a wide cone wave.",
		"advice": "Its kinetic force pauses Magnetic Core regeneration for 2.0s. Excellent for massive group control."
	},
	"Ion Cannon": {
		"title": "ION CANNON (ORBITAL DEMOLISHER)",
		"cost": "💎 450 Minerals", "range": "3.0 Tiles (192 px)", "damage": "3 Hits (Heavy Single)", "fire_rate": "0.5 shots/s",
		"desc": "Heavy particle weapon firing high-yield ion blasts that deal massive single-target disruption.",
		"advice": "Your primary anti-armor weapon to break down Giant and Planet Chunk structures. Back up with fast Scouts."
	},
	"Drone Carrier": {
		"title": "DRONE CARRIER (SWARM COMPONENT)",
		"cost": "💎 550 Minerals", "range": "2.5 Tiles (160 px)", "damage": "1 Hit per Drone (3 Drones)", "fire_rate": "0.8 shots/s per Drone",
		"desc": "Mobile coordination hub hosting 3 interceptor drones. Drones separate to independently target different threats in range.",
		"advice": "Perfect for broad swarm management. Drones deal 0 damage to Meteor (T3) or higher and are deflected by Ring Belt."
	},
	"Gravity Well": {
		"title": "GRAVITY WELL (CHRONO-LOCK DEVICE)",
		"cost": "💎 600 Minerals", "range": "3.0 Tiles (192 px)", "damage": "0 Hits (Cryo Freeze Wave)", "fire_rate": "0.16 shots/s (6s Cooldown)",
		"desc": "High-tech support module emitting gravity waves that freeze and completely immobilize all threats in range.",
		"advice": "Freeze durations scale inversely with mass (T1 Pebble = 4.0s down to T5 Chunk = 1.0s). Highly effective in loop zones."
	}
}

var list_container: VBoxContainer
var preview_bg: PanelContainer
var profile_title: Label
var stats_grid: GridContainer
var desc_text: Label
var advice_text: Label

var lbl_hp: Label
var lbl_spd: Label
var lbl_leak: Label
var lbl_extra: Label

var stat_hp: Label
var stat_spd: Label
var stat_leak: Label
var stat_extra: Label

var btn_tab_threats: Button
var btn_tab_ships: Button

func _ready():
	# Full screen layout
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_STOP
	
	# Transparent backing to visually fade Main Menu
	var bg = ColorRect.new()
	bg.size = Vector2(2048, 1152)
	bg.color = Color(0.02, 0.04, 0.08, 0.95)
	add_child(bg)
	
	# Middle panel container
	var panel = PanelContainer.new()
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.04, 0.06, 0.12, 0.9)
	style.border_width_left = 2
	style.border_width_top = 2
	style.border_width_right = 2
	style.border_width_bottom = 2
	style.border_color = Color(0.2, 0.5, 0.9, 0.8) # Glowing cyan border
	style.corner_radius_top_left = 16
	style.corner_radius_top_right = 16
	style.corner_radius_bottom_left = 16
	style.corner_radius_bottom_right = 16
	panel.add_theme_stylebox_override("panel", style)
	
	panel.custom_minimum_size = Vector2(1360, 780)
	panel.position = Vector2(2048.0 / 2.0 - 1360.0 / 2.0, 1152.0 / 2.0 - 780.0 / 2.0)
	add_child(panel)
	
	var margin = MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 36)
	margin.add_theme_constant_override("margin_top", 36)
	margin.add_theme_constant_override("margin_right", 36)
	margin.add_theme_constant_override("margin_bottom", 36)
	panel.add_child(margin)
	
	var main_vbox = VBoxContainer.new()
	main_vbox.add_theme_constant_override("separation", 20)
	margin.add_child(main_vbox)
	
	# Header HBox
	var header = HBoxContainer.new()
	main_vbox.add_child(header)
	
	var db_title = Label.new()
	db_title.text = "TACTICAL COGNITIVE DATABASE"
	db_title.add_theme_font_size_override("font_size", 28)
	db_title.add_theme_color_override("font_color", Color("#06b6d4"))
	db_title.size_flags_horizontal = SIZE_EXPAND_FILL
	header.add_child(db_title)
	
	var back_btn = Button.new()
	back_btn.text = "RETURN TO BRIDGE"
	back_btn.custom_minimum_size = Vector2(200, 48)
	back_btn.add_theme_font_size_override("font_size", 16)
	
	var style_btn = StyleBoxFlat.new()
	style_btn.bg_color = Color(0.35, 0.12, 0.12, 0.8)
	style_btn.corner_radius_top_left = 6
	style_btn.corner_radius_top_right = 6
	style_btn.corner_radius_bottom_left = 6
	style_btn.corner_radius_bottom_right = 6
	back_btn.add_theme_stylebox_override("normal", style_btn)
	back_btn.add_theme_stylebox_override("hover", style_btn)
	back_btn.pressed.connect(func(): queue_free())
	header.add_child(back_btn)
	
	main_vbox.add_child(HSeparator.new())
	
	# Tab Selection Row
	var tab_hbox = HBoxContainer.new()
	tab_hbox.add_theme_constant_override("separation", 16)
	main_vbox.add_child(tab_hbox)
	
	btn_tab_threats = Button.new()
	btn_tab_threats.text = "👾 METEOROID THREAT ARCHIVE"
	btn_tab_threats.custom_minimum_size = Vector2(320, 48)
	btn_tab_threats.add_theme_font_size_override("font_size", 16)
	btn_tab_threats.pressed.connect(func(): set_tab("Threats"))
	tab_hbox.add_child(btn_tab_threats)
	
	btn_tab_ships = Button.new()
	btn_tab_ships.text = "🚀 STARFLEET FLEET REGISTRY"
	btn_tab_ships.custom_minimum_size = Vector2(320, 48)
	btn_tab_ships.add_theme_font_size_override("font_size", 16)
	btn_tab_ships.pressed.connect(func(): set_tab("Ships"))
	tab_hbox.add_child(btn_tab_ships)
	
	# Content Split Area (Sidebar + Detailed Card)
	var content_area = HBoxContainer.new()
	content_area.size_flags_vertical = SIZE_EXPAND_FILL
	content_area.add_theme_constant_override("separation", 36)
	main_vbox.add_child(content_area)
	
	# Left Scrolling Sidebar Container
	var scroll = ScrollContainer.new()
	scroll.custom_minimum_size = Vector2(360, 0)
	scroll.size_flags_vertical = SIZE_EXPAND_FILL
	content_area.add_child(scroll)
	
	list_container = VBoxContainer.new()
	list_container.add_theme_constant_override("separation", 10)
	list_container.size_flags_horizontal = SIZE_EXPAND_FILL
	scroll.add_child(list_container)
	
	# Right Detailed Profile Card snaps
	var detail_card = PanelContainer.new()
	var style_card = StyleBoxFlat.new()
	style_card.bg_color = Color(0.06, 0.09, 0.18, 0.85)
	style_card.border_width_left = 1
	style_card.border_width_top = 1
	style_card.border_width_right = 1
	style_card.border_width_bottom = 1
	style_card.border_color = Color(0.2, 0.3, 0.5, 0.5)
	style_card.corner_radius_top_left = 10
	style_card.corner_radius_top_right = 10
	style_card.corner_radius_bottom_left = 10
	style_card.corner_radius_bottom_right = 10
	detail_card.add_theme_stylebox_override("panel", style_card)
	detail_card.size_flags_horizontal = SIZE_EXPAND_FILL
	detail_card.size_flags_vertical = SIZE_EXPAND_FILL
	content_area.add_child(detail_card)
	
	var card_margin = MarginContainer.new()
	card_margin.add_theme_constant_override("margin_left", 30)
	card_margin.add_theme_constant_override("margin_top", 30)
	card_margin.add_theme_constant_override("margin_right", 30)
	card_margin.add_theme_constant_override("margin_bottom", 30)
	detail_card.add_child(card_margin)
	
	var card_vbox = VBoxContainer.new()
	card_vbox.add_theme_constant_override("separation", 20)
	card_margin.add_child(card_vbox)
	
	# Header Profile
	profile_title = Label.new()
	profile_title.text = "TACTICAL SCAN PROFILE"
	profile_title.add_theme_font_size_override("font_size", 24)
	profile_title.add_theme_color_override("font_color", Color("#fbbf24")) # Amber/Gold
	card_vbox.add_child(profile_title)
	
	# Middle Section: live drawing preview + Core Stats side-by-side
	var mid_box = HBoxContainer.new()
	mid_box.add_theme_constant_override("separation", 40)
	card_vbox.add_child(mid_box)
	
	# Programmatic Preview Box wrapper
	var preview_container = CenterContainer.new()
	preview_container.custom_minimum_size = Vector2(160, 160)
	preview_bg = PanelContainer.new()
	var preview_style = StyleBoxFlat.new()
	preview_style.bg_color = Color("#090d16")
	preview_style.border_width_left = 2
	preview_style.border_width_top = 2
	preview_style.border_width_right = 2
	preview_style.border_width_bottom = 2
	preview_style.border_color = Color(0.2, 0.4, 0.7, 0.4)
	preview_style.corner_radius_top_left = 8
	preview_style.corner_radius_top_right = 8
	preview_style.corner_radius_bottom_left = 8
	preview_style.corner_radius_bottom_right = 8
	preview_bg.add_theme_stylebox_override("panel", preview_style)
	preview_bg.custom_minimum_size = Vector2(160, 160)
	preview_container.add_child(preview_bg)
	mid_box.add_child(preview_container)
	
	# Stats Grid Container
	stats_grid = GridContainer.new()
	stats_grid.columns = 2
	stats_grid.add_theme_constant_override("h_separation", 24)
	stats_grid.add_theme_constant_override("v_separation", 12)
	stats_grid.size_flags_horizontal = SIZE_EXPAND_FILL
	mid_box.add_child(stats_grid)
	
	# Add static stats labels
	lbl_hp = Label.new()
	lbl_hp.text = "Structural Integrity:"
	lbl_hp.add_theme_color_override("font_color", Color("#64748b"))
	stats_grid.add_child(lbl_hp)
	stat_hp = Label.new()
	stat_hp.text = "--"
	stats_grid.add_child(stat_hp)
	
	lbl_spd = Label.new()
	lbl_spd.text = "Velocity Scale:"
	lbl_spd.add_theme_color_override("font_color", Color("#64748b"))
	stats_grid.add_child(lbl_spd)
	stat_spd = Label.new()
	stat_spd.text = "--"
	stats_grid.add_child(stat_spd)
	
	lbl_leak = Label.new()
	lbl_leak.text = "Leak Impact (Station Lives):"
	lbl_leak.add_theme_color_override("font_color", Color("#64748b"))
	stats_grid.add_child(lbl_leak)
	stat_leak = Label.new()
	stat_leak.text = "--"
	stats_grid.add_child(stat_leak)

	lbl_extra = Label.new()
	lbl_extra.text = "Firing Frequency:"
	lbl_extra.add_theme_color_override("font_color", Color("#64748b"))
	stats_grid.add_child(lbl_extra)
	stat_extra = Label.new()
	stat_extra.text = "--"
	stats_grid.add_child(stat_extra)
	
	card_vbox.add_child(HSeparator.new())
	
	# Description fields
	var desc_header = Label.new()
	desc_header.text = "TACTICAL DESCRIPTION:"
	desc_header.add_theme_color_override("font_color", Color("#64748b"))
	card_vbox.add_child(desc_header)
	
	desc_text = Label.new()
	desc_text.text = "Select a threat profile from the list to pull scan readouts."
	desc_text.autowrap_mode = TextServer.AUTOWRAP_WORD
	card_vbox.add_child(desc_text)
	
	var advice_header = Label.new()
	advice_header.text = "STRATEGIC COUNTER RECOMMENDATION:"
	advice_header.add_theme_color_override("font_color", Color("#64748b"))
	card_vbox.add_child(advice_header)
	
	advice_text = Label.new()
	advice_text.text = "Select a threat profile from the list to pull counter recommendations."
	advice_text.autowrap_mode = TextServer.AUTOWRAP_WORD
	advice_text.add_theme_color_override("font_color", Color("#a855f7")) # Tech purple highlight
	card_vbox.add_child(advice_text)
	
	# Initial setup of active tabs
	set_tab("Threats")

func set_tab(tab_name: String):
	active_tab = tab_name
	style_tabs()
	rebuild_sidebar()

func style_tabs():
	var style_active = StyleBoxFlat.new()
	style_active.bg_color = Color(0.1, 0.18, 0.32, 0.9)
	style_active.border_width_bottom = 4
	style_active.border_color = Color("#06b6d4") # Bright Cyan underline
	style_active.corner_radius_top_left = 6
	style_active.corner_radius_top_right = 6
	
	var style_inactive = StyleBoxFlat.new()
	style_inactive.bg_color = Color(0.04, 0.06, 0.12, 0.5)
	style_inactive.border_width_bottom = 1
	style_inactive.border_color = Color(0.2, 0.3, 0.5, 0.3)
	style_inactive.corner_radius_top_left = 6
	style_inactive.corner_radius_top_right = 6
	
	if active_tab == "Threats":
		btn_tab_threats.add_theme_stylebox_override("normal", style_active)
		btn_tab_threats.add_theme_stylebox_override("hover", style_active)
		btn_tab_ships.add_theme_stylebox_override("normal", style_inactive)
		btn_tab_ships.add_theme_stylebox_override("hover", style_inactive)
	else:
		btn_tab_threats.add_theme_stylebox_override("normal", style_inactive)
		btn_tab_threats.add_theme_stylebox_override("hover", style_inactive)
		btn_tab_ships.add_theme_stylebox_override("normal", style_active)
		btn_tab_ships.add_theme_stylebox_override("hover", style_active)

func rebuild_sidebar():
	# Clear sidebar children
	for child in list_container.get_children():
		child.queue_free()
		
	var keys = []
	if active_tab == "Threats":
		keys = ["Pebble", "Boulder", "Meteor", "Giant", "Planet Chunk", "Hard Crust", "Magnetic Core", "Ring Belt", "Blinding Tail", "Ice Elemental", "Lava Elemental"]
	else:
		keys = ["Scout", "Laser Frigate", "Missile Cruiser", "Pulse Beam", "Ion Cannon", "Drone Carrier", "Gravity Well"]
		
	for k in keys:
		var btn = Button.new()
		btn.text = k.to_upper()
		btn.custom_minimum_size.y = 48
		btn.add_theme_font_size_override("font_size", 16)
		
		var style_normal = StyleBoxFlat.new()
		style_normal.bg_color = Color(0.08, 0.12, 0.22, 0.8)
		style_normal.border_width_left = 1
		style_normal.border_width_top = 1
		style_normal.border_width_right = 1
		style_normal.border_width_bottom = 1
		style_normal.border_color = Color(0.2, 0.4, 0.7, 0.4)
		style_normal.corner_radius_top_left = 6
		style_normal.corner_radius_top_right = 6
		style_normal.corner_radius_bottom_left = 6
		style_normal.corner_radius_bottom_right = 6
		btn.add_theme_stylebox_override("normal", style_normal)
		btn.add_theme_stylebox_override("hover", style_normal)
		btn.add_theme_stylebox_override("pressed", style_normal)
		btn.pressed.connect(func(): display_profile(k))
		list_container.add_child(btn)
		
	# Select default first profile on load
	if not keys.is_empty():
		display_profile(keys[0])

func display_profile(key: String):
	if active_tab == "Threats":
		var data = profiles.get(key, {})
		if data.is_empty():
			return
			
		current_profile = data
		profile_title.text = data["title"]
		
		# Set labels back to threat layout
		lbl_hp.text = "Structural Integrity:"
		lbl_spd.text = "Velocity Scale:"
		lbl_leak.text = "Leak Impact (Station Lives):"
		lbl_extra.visible = false
		stat_extra.visible = false
		
		stat_hp.text = data["integrity"]
		stat_spd.text = data["speed"]
		stat_leak.text = data["penalty"]
		
		desc_text.text = data["desc"]
		advice_text.text = data["advice"]
		
		# Update programmatic thumbnail renderer!
		update_preview_node("", "Threats", data["tier"] as int, data["variant"] as String, data["element"] as String)
	else:
		var data = ship_profiles.get(key, {})
		if data.is_empty():
			return
			
		current_profile = data
		profile_title.text = data["title"]
		
		# Set labels to ship layout
		lbl_hp.text = "Acquisition Cost:"
		lbl_spd.text = "Targeting Range:"
		lbl_leak.text = "Base Damage & Type:"
		lbl_extra.text = "Firing Frequency:"
		lbl_extra.visible = true
		stat_extra.visible = true
		
		stat_hp.text = data["cost"]
		stat_spd.text = data["range"]
		stat_leak.text = data["damage"]
		stat_extra.text = data["fire_rate"]
		
		desc_text.text = data["desc"]
		advice_text.text = data["advice"]
		
		# Update programmatic thumbnail renderer!
		update_preview_node(key, "Ships")

func update_preview_node(type: String, mode: String, t_tier: int = 1, v_variant: String = "None", e_element: String = "None"):
	# Clear existing children in preview_bg
	for child in preview_bg.get_children():
		child.queue_free()
		
	if mode == "Threats":
		var box = ThreatPreview.new()
		preview_bg.add_child(box)
		box.setup_preview(t_tier, v_variant, e_element)
	else:
		var box = ShipPreview.new()
		preview_bg.add_child(box)
		box.setup_preview(type)
