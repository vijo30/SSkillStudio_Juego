extends KinematicBody2D


signal health_updated(health)
signal killed()
signal skeleton_attack

export var move_speed := 500
export var gravity := 2000


var velocity := Vector2.ZERO

# Health

export var max_health = 1
onready var health = max_health setget _set_health

var is_moving_left = false
var attacking = false
var damaged = false
var dead = false
onready var atkTimer = $AttackTimer
onready var offTimer = $OffTimer

func _ready():
	$AnimatedSprite.playing = true





func _physics_process(delta):
	if not dead:
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
	dead = true
	$CollisionShape2D.set_deferred("disabled", true)
	$PlayerDetector/CollisionShape2D.set_deferred("disabled", true)
	$AttackDetector/CollisionShape2D.set_deferred("disabled", true)
	$RayCast2D.set_deferred("disabled", true)
	$AnimatedSprite.set_animation("Death")



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
	atkTimer.start()
	


func _on_AttackDetector_area_entered(area):
	print("")
	





func _on_PlayerDetector_area_exited(area):
	attacking = false
	atkTimer.stop()


func _on_AttackTimer_timeout():
	$AttackDetector/CollisionShape2D.disabled = false
	print("On")

func _on_AttackDetector_area_exited(area):
	pass
	


func _on_Hitbox_area_entered(area):
	if area.is_in_group("sword"):
		kill()


func _on_OffTimer_timeout():
	$AttackDetector/CollisionShape2D.disabled = true
	print("Off")


func _on_AttackDetector2_area_entered(area):
	offTimer.start()


func _on_AttackDetector2_area_exited(area):
	offTimer.stop()
