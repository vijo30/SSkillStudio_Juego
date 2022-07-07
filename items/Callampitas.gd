extends KinematicBody2D

var SPEED = 200
var linear_vel = Vector2.ZERO
var direction = 1
var actualMushroom

func _ready() -> void:
	connect("body_entered", self, "on_body_entered")
	connect("area_entered", self, "on_area_entered")
	randomize()
	actualMushroom = str((randi()%3) +1)
	
func _physics_process(delta: float) -> void:
	if is_on_ceiling():
		linear_vel = Vector2.ZERO
	if not is_on_floor():
		linear_vel += Vector2.DOWN * SPEED *  delta
	move_and_slide(linear_vel, Vector2.UP)

func getMushroom():
	return actualMushroom

func fire_to(target: Vector2):
	$Area2D/Callampitas.set_animation(actualMushroom)
	linear_vel = (target - global_position).normalized() * SPEED
	
func set_direction(value):
	print("change_direction")
	direction = value

func _on_Area2D_body_entered(body):
	if body.is_in_group("Player") and is_on_floor():
		body.consumeMushroom(actualMushroom)
		queue_free()
