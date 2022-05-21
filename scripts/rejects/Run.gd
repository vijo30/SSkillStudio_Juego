extends PlayerState


func physics_update(delta: float) -> void:
	player.animations.set("parameters/in_air_state/current",0)	 # Grounded animations set
	player.animations.set("parameters/movement/current",1) # Run animation
	
	# Notice how we have some code duplication between states. That's inherent to the pattern,
	# although in production, your states will tend to be more complex and duplicate code
	# much more rare.
	if (not player.grounded) and (not player.climbing):
		state_machine.transition_to("Fall")

	elif (player.climbing):
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
		
	elif is_equal_approx(mve, 0.0):
		state_machine.transition_to("Idle")
