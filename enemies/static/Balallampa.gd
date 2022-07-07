extends Area2D

var speed = 200
var SPEED = 300
var linear_vel = Vector2.ZERO
var direction = 1
func _ready() -> void:
	connect("body_entered", self, "on_body_entered")
	connect("area_entered", self, "on_area_entered")


func _physics_process(delta: float) -> void:

	linear_vel += Vector2(1, 0) * direction * SPEED *  delta
	
	position += linear_vel * delta
	

func fire_to(target: Vector2):
	linear_vel = (target*Vector2(1, 0)).normalized() * SPEED * direction
	
func set_direction(value):
	print("change_direction")
	direction = value

func _on_Balallampa_body_entered(body):
	if body is TileMap or body.is_in_group("Player"):
		queue_free()
