extends KinematicBody2D

export var move_speed := 100
export var gravity := 2000

var velocity := Vector2.ZERO

func _physics_process(delta):
	# reset horizontal velocity
	velocity.x = 0
	
	# set horizontal velocity
	if Input.get_action_strength("move_right"):
		velocity.x += move_speed
	if Input.get_action_strength("move_left"):
		velocity.x -= move_speed
	
	# apply gravity
	# player always has downward velocity
	velocity.y += gravity * delta
	
	# actually move the player
	velocity = move_and_slide(velocity, Vector2.UP)
