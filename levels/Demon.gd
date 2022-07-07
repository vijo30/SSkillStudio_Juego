extends Area2D

var direction = -1

func _ready():
	$Drop/DropArea.set_deferred("disabled",true)
	$switchDirection.start()

func _process(delta):
	position.x += direction * 50 * delta


func _on_switchDirection_timeout():
	direction *= -1
	$AnimatedSprite.flip_h = !$AnimatedSprite.flip_h


func _on_DemonArea_area_entered(area):
	if area.is_in_group("sword"):
		direction = 0
		$switchDirection.stop()
		$deathTimer.start()
		$AnimatedSprite.set_animation("death")
		$CollisionShape2D.set_deferred("disabled",true)
		$Drop2.start()
	

func _on_Drop2_timeout():
	$Drop/DropArea.set_deferred("disabled",false)
	$Drop.set_deferred("visible",true)


func _on_Drop_area_entered(area):
	if area.is_in_group("player"):
		$Drop/DropArea.set_deferred("disabled",true)
		$Drop/Sprite.set_deferred("visible",false)
		$takeDrop.start()
		$win.play()
		


func _on_AREAFINAL_body_entered(body):
	if body.is_in_group("Player"):
		get_parent().get_node("Panel/backTheme").playing = false


func _on_takeDrop_timeout():
	get_tree().change_scene("res://credits/GodotCredits.tscn")


func _on_deathTimer_timeout():
	$death.play()
