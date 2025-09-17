@tool
class_name Ball
extends Node2D

static var ALL_BALLS: Array[Ball]
const GRAVITIONAL_CONSTANT := 1000.0

@export var mass := 1.0
@export var color := Color.WHITE
@export var filled := false
@export var fixed := false
@export var can_collide := true
@export var label := "ball"
var show_label := true

var velocity: Vector2
var radius:
	get: return (1000.0 * mass / (4.0/3 * PI)) ** (1.0/3)

func _ready() -> void:
	ALL_BALLS.append(self)
	z_index = roundi(-radius)

func _draw() -> void:
	draw_circle(Vector2.ZERO, radius, Color.BLACK)
	draw_circle(Vector2.ZERO, radius, color, filled)
	
	if show_label:
		draw_string(preload("res://Font.tres"), Vector2(-64, -radius - 8), label, HORIZONTAL_ALIGNMENT_CENTER, 128, 12, color.lerp(Color(0.5, 0.5, 0.5, 0.5), 0.7), TextServer.JUSTIFICATION_NONE, TextServer.DIRECTION_AUTO, TextServer.ORIENTATION_HORIZONTAL, 2)
	
	if Engine.is_editor_hint():
		return
	
	var viewport_width := get_window().size.x
	var viewport_height := get_window().size.y
	
	if position.x + radius > viewport_width / 2.0 or position.x - radius < -viewport_width / 2.0:
		draw_circle(Vector2(viewport_width * -sign(position.x), 0), radius, Color.BLACK)
		draw_circle(Vector2(viewport_width * -sign(position.x), 0), radius, color, filled)
	
	if position.y + radius > viewport_height / 2.0 or position.y - radius < -viewport_height / 2.0:
		draw_circle(Vector2(0, viewport_height * -sign(position.y)), radius, Color.BLACK)
		draw_circle(Vector2(0, viewport_height * -sign(position.y)), radius, color, filled)

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	
	for ball in ALL_BALLS:
		if ball == self: continue
		
		var relative_position := ball.position - position
		
		if abs(-ball.position.x - position.x) < abs(relative_position.x):
			relative_position.x = -ball.position.x - position.x
		
		if abs(-ball.position.y - position.y) < abs(relative_position.y):
			relative_position.y = -ball.position.y - position.y
		
		var direction = relative_position.normalized()
		var distance = relative_position.length()
		
		if !fixed and distance > radius + ball.radius:
			var force = GRAVITIONAL_CONSTANT * direction * mass * ball.mass / (distance ** 2)
			velocity += force / mass * delta
		
		#if can_collide and ball.can_collide and position.distance_to(ball.position) < radius + ball.radius:
			#var normal = position.direction_to(ball.position)
			#position -= normal * (radius + ball.radius - position.distance_to(ball.position))
			#velocity = velocity.bounce(normal)
	
	if !fixed:
		position += velocity * delta
	
	var viewport_width := get_window().size.x
	var viewport_height := get_window().size.y
	
	if position.x < -viewport_width / 2.0 or position.x > viewport_width / 2.0:
		position.x *= -1
	
	if position.y < -viewport_height / 2.0 or position.y > viewport_height / 2.0:
		position.y *= -1
	
	if Input.is_action_just_pressed("Toggle Label"):
		show_label = !show_label
	
	color.ok_hsl_h += velocity.length() * 0.001 * delta
	queue_redraw()
