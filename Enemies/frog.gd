extends CharacterBody2D

#Physical variables
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
const SPEED = 100
const JUMP_VELOCITY = -290

#Preload nodes and scenes
var player
@onready var animation = get_node("AnimationPlayer")
@onready var death_timer = $death_animation_timer

#Conditional variables
var chase = false
var is_dead = false


func _physics_process(delta):
	# Frog gravity
	if not is_on_floor() and !is_dead:
		velocity.y += gravity * delta
	
	# Chase triggers movement performed via jumping ('cause it's a frog)
	if chase == true and !is_dead:
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
			animation.play("Jump")
		if velocity.y > 0:
			animation.play("Fall")
		
		#Change direction based on player position
		player = get_node("../../Player/Player")
		var direction = (player.position - self.position)
		
		#Horizontal movement
		if direction.x >= -435:
			get_node("AnimatedSprite2D").flip_h = true
			velocity.x = SPEED
		elif direction.x == -435:
			velocity.x = 0
		else:
			get_node("AnimatedSprite2D").flip_h = false
			velocity.x = -SPEED
			
	elif chase == false:
		animation.play("Idle")
	move_and_slide()
	

#Trigger death animation
func _on_enemy_death_body_entered(body):
	if body.name == "Player" and !is_dead:
		animation.play("Death")
		is_dead = true
		velocity.x = 0
		velocity.y = 0
		death_timer.wait_time = 0.65
		death_timer.start()

#Remove enemy after timer times out
func _on_death_animation_timer_timeout():
	self.queue_free()
	

#Triggers chase mode
func _on_player_detection_body_entered(body):
	if body.name == "Player" and !is_dead:
		chase = true
	
#Stops chase
func _on_player_detection_body_exited(body):
	if body.name == "Player" and !is_dead:
		chase = false
		velocity.x = 0



