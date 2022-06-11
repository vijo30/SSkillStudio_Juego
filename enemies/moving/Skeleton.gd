extends KinematicBody2D


signal health_updated(health)
signal killed()

export var move_speed := 500
export var gravity := 2000

var velocity := Vector2.ZERO

# Health

export var max_health = 100
onready var health = max_health setget _set_health

var is_moving_left = false
var attacking = false


func _ready():
	$AnimatedSprite.playing = true
	


func _physics_process(delta):
	if not attacking:
		$AnimatedSprite.set_animation("Walk")
	elif attacking:
		$AnimatedSprite.set_animation("Attack")
	move_character()
	detect_turn_around()
	
func move_character():
	velocity.x = -move_speed if is_moving_left else move_speed
	velocity.y += gravity
	
	velocity = move_and_slide(velocity, Vector2.UP)


func detect_turn_around():
	if not $RayCast2D.is_colliding() and is_on_floor():
		is_moving_left = not is_moving_left
		print("Turn around")
		scale.x = -scale.x

func damage(amount):
	_set_health(health - amount)

	

func kill():
	set_deferred("$CollisionShape2D.disabled", true) 



func _set_health(value):
	var prev_health = health
	health = clamp(value, 0, max_health)
	if health != prev_health:
		emit_signal("health_updated",health)
		print(str(health))
		if health == 0:
			kill()
			emit_signal("killed")


func _on_PlayerDetector_area_entered(area):
	attacking = true


func _on_AttackDetector_area_entered(area):
	get_tree().reload_current_scene()




func _on_PlayerDetector_area_exited(area):
	attacking = false
