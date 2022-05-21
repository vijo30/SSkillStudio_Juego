extends PlayerState


func physics_update(delta: float) -> void:
	player.animations.set("parameters/in_air_state/current",0)	 # Grounded animations set
	player.animations.set("parameters/movement/current",2) # Attack animation
	
	var mve = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	player.velocity.x = mve * player.move_speed
	player.velocity.y = 0
	player.velocity = player.move_and_slide(player.velocity, Vector2.UP)
	
	player.canIAttack = false
	
	if (not player.grounded) and (not player.climbing):
		state_machine.transition_to("Fall")

	elif (player.climbing):
		state_machine.transition_to("Climb")
	
			
	if player.damaged:
		state_machine.transition_to("Damage")
	
	elif player.health == 0:
		state_machine.transition_to("Dead")
		
	elif is_equal_approx(mve, 0.0) and player.grounded:
		state_machine.transition_to("Idle")
