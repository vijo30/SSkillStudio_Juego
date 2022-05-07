extends KinematicBody2D

export var move_speed := 50
export var gravity := 2000

var velocity := Vector2.ZERO

# Grounded
var grounded = false
# Enable gravity
var grv = true
# Direction of climb_wall
var lastDir = 0

# Climbing var
var climb = false

# Attack var
var canIAttack = false
var attacking = false
onready var timer = get_node("Timer")
onready var next_level = get_tree().get_root()

# Activate animations
func _ready(): 
	$AnimationTree.active = true
	next_level.connect("entered", self, "handleNextLevel")

# Change the levels
func handleNextLevel():	
	print("res://levels/Level_" + str(int(get_tree().current_scene.name) + 1) + ".tscn")


# INNOVATIVE MECHANICS
func _on_GroundDetector_body_entered(body):
	if body.is_in_group('tilemap'): grounded = true

func _on_GroundDetector_body_exited(body):
	if body.is_in_group('tilemap'): grounded = false

func _on_climb_wall_body_entered(body):
	if body.is_in_group('tilemap'): climb = true

func _on_climb_wall_body_exited(body):
	if body.is_in_group('tilemap'): climb = false

func _process(delta):
	if weakref(Manager.progress_bar).get_ref():
		if Manager.progress_bar.value >= 100:
			canIAttack = true
			# sonidito, cambio color en la barra, shader al player

# Character
func _physics_process(delta):
	# Horizontal movement
	# reset horizontal velocity
	velocity.x = 0
	
	# set horizontal velocity
	var mve = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	velocity.x = mve * move_speed

	if mve > 0: $HeroKnight.flip_h = false
	if mve < 0: $HeroKnight.flip_h = true
	# set direction of climb_wall	
	if mve != 0: lastDir = mve
	$climb_wall.rotation_degrees = lastDir * 90
	
	# Vertical movement	
	grv = not climb
	if climb: velocity.y = 0
	
	# apply gravity
	if grv: velocity.y += gravity * delta
	
	# move upwards or downwards on walls
	if Input.is_action_pressed("move_up") and (climb): velocity.y -= move_speed
	if Input.is_action_pressed("move_down") and (climb): velocity.y += move_speed


	# actually move the player
	velocity = move_and_slide(velocity, Vector2.UP)
	
	
	# animations	
	if mve==0 and (not attacking): $AnimationTree.set("parameters/movement/current",0)
	
	if abs(mve)>0 and not climb:
		attacking = false
		$AnimationTree.set("parameters/movement/current",1)
	
	if climb:
		if velocity.y == 0: $AnimationTree.set("parameters/on_wall/current",0)
		else: $AnimationTree.set("parameters/on_wall/current",1)
	
	if not climb and not grounded: $AnimationTree.set("parameters/in_air_state/current",1)
	
	if climb: $AnimationTree.set("parameters/in_air_state/current",2)
		
	if grounded: $AnimationTree.set("parameters/in_air_state/current",0)

	# attack implementation
	if Input.is_action_pressed("attack") and canIAttack:
		timer.start()
		canIAttack = false
		attacking = true
		$AnimationTree.set("parameters/movement/current",2)
	

	
func _input(event):
	if event.is_action_pressed("exit_game"): get_tree().quit()


func _on_Timer_timeout(): attacking = false



