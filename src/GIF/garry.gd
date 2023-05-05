extends CharacterBody2D


const SPEED = 270.0
const JUMP_VELOCITY = -400.0
# Get the gravity from the project settings to be synced with RigidBody nodes
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var jump_counter = 0
@onready var animation = get_node("AnimationPlayer")

	
func _physics_process(delta):
	# Add the gravity
	if not is_on_floor():
		velocity.y += gravity * delta
		if velocity.y > 0:
			animation.play("Fall")
	
	#Reset jump counter
	if is_on_floor():
		jump_counter = 0

	# Handle Jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		animation.play("Jump")
	
	#Double jump
	if Input.is_action_just_pressed("ui_accept") and not is_on_floor() and jump_counter < 1:
		velocity.y = JUMP_VELOCITY * 0.85
		animation.play("Jump")
		jump_counter += 1

	# Get e input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	
	if direction == -1:
		get_node("AnimatedSprite2D").flip_h = true
	elif direction == 1:
		get_node("AnimatedSprite2D").flip_h = false
		
	
	if direction:
		velocity.x = direction * SPEED
		
		
		if velocity.y == 0:
			animation.play("Run")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if velocity.y == 0:
			animation.play("Idle")
			
	move_and_slide()

#escape to title
func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE:
			get_tree().change_scene_to_file("res://main.tscn") 
