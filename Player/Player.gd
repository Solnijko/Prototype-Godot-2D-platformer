extends CharacterBody2D

#Physical constants
const SPEED = 270.0
const JUMP_VELOCITY = -400.0
const DASH_SPEED = 910
const DASH_LENGTH = .1
const FALL_MODIFIER = 50


# Get the gravity from the project settings to be synced with RigidBody nodes
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var jump_counter = 0


#Conditional variables
var is_dashing = false
var is_stomping = false

#Accesing other nodes and scenes
@onready var animation = get_node("AnimationPlayer")
@onready var dash = $Dash


func _physics_process(delta):
	# Add the gravity
	if not is_on_floor():
		velocity.y += gravity * delta
		if Input.is_action_pressed("crouch"):
			velocity.y += FALL_MODIFIER
			#if velocity.y > 1000 :
			#	is_stomping = true
		if velocity.y > 0:
			animation.play("Fall")
			
	
	#Reset jump counter
	if is_on_floor():
		jump_counter = 0

	# Handle Jump
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y += JUMP_VELOCITY
		animation.play("Jump")
	
	#Double jump
	if Input.is_action_just_pressed("jump") and not is_on_floor() and jump_counter < 1:
		velocity.y = JUMP_VELOCITY * 0.85
		animation.play("Jump")
		jump_counter += 1

	
	#Get player direction
	var direction = Input.get_axis("move_left", "move_right")
	
	#Flip animation based on player's direction
	if direction == -1:
		get_node("AnimatedSprite2D").flip_h = true
	elif direction == 1:
		get_node("AnimatedSprite2D").flip_h = false
	
	#Handling movement
	if direction:
		if Input.is_action_just_pressed("dash"):
			dash.start_dash(DASH_LENGTH)
		velocity.x = direction * DASH_SPEED if dash.is_dashing() else direction * SPEED
		if velocity.y == 0:
			animation.play("Run")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if velocity.y == 0:
			animation.play("Idle")
			
	move_and_slide()

func _input(event):
	if Input.is_action_just_pressed("open_menu"):
		get_tree().change_scene_to_file("res://main.tscn")
#To Title Screen
 
