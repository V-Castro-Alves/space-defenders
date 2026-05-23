extends Node2D

var start_pos: Vector2
var range_radius: float
var effect_color: Color = Color("#38bdf8") # Cyan / Light Blue

var lifetime: float = 0.6
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
	
	# Concentric rings
	var border_color = effect_color
	border_color.a = alpha
	
	draw_arc(Vector2.ZERO, current_radius, 0, 2*PI, 64, border_color, 3.0, true)
	
	# Inner ring
	if progress_ratio > 0.3:
		var inner_color = effect_color
		inner_color.a = alpha * 0.5
		draw_arc(Vector2.ZERO, current_radius * 0.6, 0, 2*PI, 64, inner_color, 1.5, true)
		
	# Subtle translucent filled center
	var fill_color = effect_color
	fill_color.a = alpha * 0.08
	draw_circle(Vector2.ZERO, current_radius, fill_color)
