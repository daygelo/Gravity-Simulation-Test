class_name Main
extends Node2D

@export var mass_curve: Curve

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	
	var num_balls := 20
	var base_color := Color.from_ok_hsl(0.0, 1.0, 0.65)
	for i in num_balls:
		var ball = preload("res://Ball.tscn").instantiate()
		ball.position = Vector2.from_angle(TAU * i / num_balls) * get_viewport_rect().size.length() * 0.2
		ball.mass = mass_curve.sample_baked(randf())
		ball.velocity = Vector2.from_angle(TAU * i / num_balls).rotated(TAU * 0.25) * 50.0
		ball.color = base_color
		ball.label = "p%02d" % (i + 1)
		add_child(ball)
		base_color.ok_hsl_h += 1.0 / num_balls

func _process(_delta: float) -> void:
	$Ball.position = get_local_mouse_position()
