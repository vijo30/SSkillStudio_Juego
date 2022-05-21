extends PlayerState

func enter(_msg := {}) -> void:
	player.velocity = Vector2.ZERO

	
func physics_update(_delta: float) -> void:
	player.animations.set("parameters/in_air_state/current",0)	 # Grounded animations
	player.animations.set("parameters/movement/current",0) # Idle animation
	if (not player.grounded) and (not player.climbing):
		state_machine.transition_to("Fall")

	elif (player.climbing):
		state_machine.transition_to("Climb")
	
	elif Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		state_machine.transition_to("Run")

	elif Input.is_action_pressed("attack") and player.canIAttack:
		state_machine.transition_to("Attack")
		
	elif player.damaged:
		state_machine.transition_to("Damage")
	
	elif player.health == 0:
		state_machine.transition_to("Dead")
