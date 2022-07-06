extends KinematicBody2D

signal health_updated(health)
signal killed()

var direction = 1
export var max_health = 1
onready var health = max_health setget _set_health
var Balallampa = preload("res://enemies/static/Balallampa.tscn")
var Callampita = preload("res://items/Callampitas.tscn")

var attacking = false
var damaged = false
var dead = false
var alert = false # player en rango de ataque

func _ready():
	$AnimatedCallampin.set_animation("idle")
	
func _physics_process(_delta):
	if not dead:
		detect_turn_around()
		try_to_attack()

func detect_turn_around():
	print($CallampinBack.get_collider())
	if $CallampinBack.get_collider() != null:
		print("hola")
		if $CallampinBack.get_collider().is_in_group("Player"):
			print("en la espalda tengo al weon")
			# volteamos al callampin completo
			scale.x = -scale.x
			direction *= -1

func try_to_attack():
	# si no lo he atacado y está en mi rango, me lo piteo
	if alert == true and attacking ==false:
		$AnimatedCallampin.set_animation("attack")
		$attackTimer.start()
		$delayTimer.start() # timer para animacion bala
		attacking = true

# pa volver a atacar
func _on_attackTimer_timeout():
	attacking = false

func _set_health(value):
	var prev_health = health
	health = clamp(value, 0, max_health)
	if health != prev_health:
		emit_signal("health_updated",health)
		print(str(health))
		if health == 0:
			die()
			emit_signal("killed")

func die():
	if not dead:
		$Sounds/death.play()
		var item = Callampita.instance()
		item.global_position = Vector2($SpawnBalallampa.global_position.x, $SpawnBalallampa.global_position.y)
		get_parent().add_child(item)
		item.fire_to(Vector2(item.global_position.x, item.position.y-4))
		dead = true
		$CallampinCollision.set_deferred("disabled",true)
		$AttackRangeArea/AttackRange.set_deferred("disabled",true)
		$CallampinBack.set_deferred("disabled",true)
		$AnimatedCallampin.set_animation("death")

func _on_AttackRangeArea_body_entered(body):
	if body.is_in_group("Player"):
		alert = true
		print("ALERTA")

func _on_AttackRangeArea_body_exited(body):
	if body.is_in_group("Player"):
		alert = false

func _on_Hitbox_area_entered(area):
	if area.is_in_group("sword"):
		die()

# aqui vuelve al estado normal despues de atacar
func _on_AnimatedCallampin_animation_finished():
	if $AnimatedCallampin.animation == "attack":
		$AnimatedCallampin.set_animation("idle")


func _on_delayTimer_timeout():
	var balallampa = Balallampa.instance()
	balallampa.global_position = $SpawnBalallampa.global_position
	get_parent().add_child(balallampa)
	balallampa.set_direction(direction)
	$Sounds/attack.play()
	balallampa.fire_to(Vector2($SpawnBalallampa.global_position.x, self.position.y))
