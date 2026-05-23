extends Area2D

var damage: int = 1
var speed: float = 600.0
var direction: Vector2 = Vector2.RIGHT
var target: Node2D = null
var splash_radius: float = 0.0 # If > 0, AoE damage is applied
var projectile_color: Color = Color("#f59e0b") # Warm amber/yellow
var shot_type: String = "Weak"
var source_ship_type: String = ""

func _ready():
	top_level = true
	
	# Hitbox
	var collision = CollisionShape2D.new()
	var shape = RectangleShape2D.new()
	shape.size = Vector2(8, 8)
	collision.shape = shape
	add_child(collision)
	
	area_entered.connect(_on_area_entered)
	queue_redraw()

func _draw():
	# Draw projectile as a small glowing square
	draw_rect(Rect2(-4, -4, 8, 8), projectile_color)

func _physics_process(delta):
	if is_instance_valid(target):
		direction = (target.global_position - global_position).normalized()
		
	position += direction * speed * delta
	
	# Bounds clean up
	if position.x < -100 or position.x > 2500 or position.y < -100 or position.y > 1500:
		queue_free()

func _on_area_entered(area):
	var asteroid = area.get_parent()
	if asteroid.has_method("take_damage"):
		if splash_radius > 0.0:
			_explode(asteroid)
		else:
			asteroid.take_damage(damage, shot_type, source_ship_type)
			
		queue_free()

func _explode(_primary_target: Node2D):
	# Spawn a visual explosion effect
	var explosion = Node2D.new()
	explosion.name = "ExplosionVisual"
	explosion.position = global_position
	explosion.set_script(preload("res://entities/projectiles/explosion_effect.gd"))
	explosion.radius = splash_radius
	get_parent().add_child(explosion)
	
	# Find all asteroids within splash radius
	var asteroids = get_tree().get_nodes_in_group("asteroids")
	for ast in asteroids:
		if is_instance_valid(ast):
			var dist = global_position.distance_to(ast.global_position)
			if dist <= splash_radius:
				# Apply damage to all in radius
				ast.take_damage(damage, "Splash", source_ship_type)
