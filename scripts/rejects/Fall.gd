extends PlayerState


func physics_update(delta: float) -> void:
	player.animations.set("parameters/in_air_state/current",1) # Fall animation
	
	if (player.climbing):
		state_machine.transition_to("Climb")
	# We move the run-specific input code to the state.
	# A good alternative would be to define a `get_input_direction()` function on the `Player.gd`
	# script to avoid duplicating these lines in every script.
	var mve = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	player.velocity.x = mve * player.move_speed
	player.velocity.y += player.gravity * delta
	player.velocity = player.move_and_slide(player.velocity, Vector2.UP)

	if player.damaged:
		state_machine.transition_to("Damage")
	
	elif player.health == 0:
		state_machine.transition_to("Dead")
		
	elif is_equal_approx(mve, 0.0) and player.grounded:
		state_machine.transition_to("Idle")
