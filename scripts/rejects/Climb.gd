extends PlayerState


func physics_update(delta: float) -> void:
	player.animations.set("parameters/in_air_state/current",2) # Climb animation set
	
	var mve = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	player.velocity.x = mve * player.move_speed
	player.velocity.y = 0
	player.velocity = player.move_and_slide(player.velocity, Vector2.UP)
	
	if player.velocity.y == 0: player.animations.set("parameters/on_wall/current",0) # Climb idle animation
		
	elif player.velocity.y != 0: player.animations.set("parameters/on_wall/current",1) # Climb animation
			
	elif player.damaged:
		state_machine.transition_to("Damage")
	
	elif player.health == 0:
		state_machine.transition_to("Dead")
		
	elif is_equal_approx(mve, 0.0) and player.grounded:
		state_machine.transition_to("Idle")
