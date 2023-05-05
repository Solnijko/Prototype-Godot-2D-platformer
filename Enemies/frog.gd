extends CharacterBody2D

const SPEED = 100
const JUMP_VELOCITY = -290

var player
@onready var animation = get_node("AnimationPlayer")
var chase = false

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	# Frog gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# Chase triggers movement performed via jumping ('cause it's a frog)
	if chase == true:
		get_node("AnimatedSprite2D").play("Jump")
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
			
		player = get_node("../../Player/Player")
		var direction = (player.position - self.position)
		
		if direction.x >= -435:
			get_node("AnimatedSprite2D").flip_h = true
			velocity.x = SPEED
		elif direction.x == -435:
			velocity.x = 0
		else:
			get_node("AnimatedSprite2D").flip_h = false
			velocity.x = -SPEED
			
	move_and_slide()

func _on_player_detection_body_entered(body):
	if body.name == "Player":
		chase = true
	
	
func _on_player_detection_body_exited(body):
	if body.name == "Player":
		chase = false
		velocity.x = 0
		get_node("AnimatedSprite2D").play("Idle")
		print("chase stoped")
