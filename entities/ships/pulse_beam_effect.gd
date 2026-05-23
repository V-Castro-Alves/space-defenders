extends Node2D

var start_pos: Vector2
var direction_angle: float
var range_radius: float
var beam_color: Color = Color("#f59e0b") # Warm gold/orange

var lifetime: float = 0.4
var elapsed: float = 0.0

func _ready():
	z_index = -5
	queue_redraw()

func _process(delta):
	elapsed += delta
	if elapsed >= lifetime:
		queue_free()
	else:
		queue_redraw()

func _draw():
	var progress_ratio = elapsed / lifetime
	var alpha = 1.0 - progress_ratio
	var current_radius = range_radius * progress_ratio
	
	# Draw translucent wedge sector
	var fill_color = beam_color
	fill_color.a = alpha * 0.25
	
	var border_color = beam_color
	border_color.a = alpha
	
	var points = PackedVector2Array()
	points.append(Vector2.ZERO) # relative to position
	
	var segments = 16
	var half_cone = PI / 4.0 # 45 degrees either side = 90 degrees
	for i in range(segments + 1):
		var angle = direction_angle - half_cone + (half_cone * 2.0 * i / segments)
		points.append(Vector2.from_angle(angle) * current_radius)
		
	draw_polygon(points, [fill_color])
	
	# Draw outer arc
	var arc_points = PackedVector2Array()
	for i in range(segments + 1):
		var angle = direction_angle - half_cone + (half_cone * 2.0 * i / segments)
		arc_points.append(Vector2.from_angle(angle) * current_radius)
	draw_polyline(arc_points, border_color, 2.0)
