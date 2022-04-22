extends KinematicBody2D

export var move_speed := 100
export var gravity := 2000
# Grounded
var grounded = false
# Enable gravity
var grv = true
# Direction of climb_wall
var lastDir = 0
# Climbing
var climb = false
var velocity := Vector2.ZERO
var canIAttack = false

func _ready():
	$AnimationTree.active = true

# INNOVATIVE MECHANICS
func _on_GroundDetector_body_entered(body):
	if body.is_in_group('tilemap'):
		grounded = true


func _on_GroundDetector_body_exited(body):
	if body.is_in_group('tilemap'):
		grounded = false

func _on_climb_wall_body_entered(body):
	if body.is_in_group('tilemap'):
		climb = true


func _on_climb_wall_body_exited(body):
	if body.is_in_group('tilemap'):
		climb = false

func _process(delta):
	if get_node("/root/Main/Panel/ProgressBar").value >= 100:
		canIAttack = true
		# sonidito, cambio color en la barra, shader al player


func _physics_process(delta):

	# reset horizontal velocity
	velocity.x = 0
	
	# set horizontal velocity
	var mve = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	velocity.x = mve * move_speed

	if mve > 0: $HeroKnight.flip_h = false
	if mve < 0: $HeroKnight.flip_h = true
	# set direction of climb_wall	
	if mve != 0:
		lastDir = mve
	$climb_wall.rotation_degrees = lastDir * 90
	
	grv = not climb
	if climb: velocity.y = 0
	# apply gravity
	# player always has downward velocity
	if grv:
		velocity.y += gravity * delta
	
	# move upwards or downwards on walls
	if Input.is_action_pressed("move_up") and (climb):
		velocity.y -= move_speed
	if Input.is_action_pressed("move_down") and (climb):
		velocity.y += move_speed


	# actually move the player
	velocity = move_and_slide(velocity, Vector2.UP)
	# animations	
	if mve==0:
		$AnimationTree.set("parameters/movement/current",0)
	if abs(mve)>0 and not climb:
		$AnimationTree.set("parameters/movement/current",1)
	if not climb and not grounded:
		$AnimationTree.set("parameters/in_air_state/current",1)
	else:
		$AnimationTree.set("parameters/in_air_state/current",0)
	# attack implementation
	if Input.is_action_just_pressed("attack") and canIAttack:
		canIAttack = false
		pass # implementar el ataque
	
func _on_Area2D_body_entered(_body):
	# when the Player reaches this area, it completes the level (Changes the scene to the next one)
	# self.position.x = 484
	# self.position.y = 166
	get_tree().change_scene("res://SecondLevel.tscn")
	
func _input(event):
	if event.is_action_pressed("exit_game"):
		get_tree().quit()
