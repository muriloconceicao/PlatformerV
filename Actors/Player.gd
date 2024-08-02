extends KinematicBody2D

const ACCELERATION = 512
const MAX_SPEED = 64
const FRICTION = 7
const AIR_RESISTANCE = 0.02
const GRAVITY = 200
const JUMP_FORCE = 128.0
const STOMP_FORCE = 152
const FIREBALL = preload("res://Bullet.tscn")

var motion = Vector2.ZERO
onready var sprite = $Sprite
onready var animationPlayer = $AnimationPlayer

func _physics_process(delta):
	setInputs(delta)
	setGravity(delta)
	motion = move_and_slide(motion, Vector2.UP)
	
func setGravity(delta):
	motion.y += GRAVITY * delta
	
func setInputs(delta):
	var x_input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	
	if x_input != 0:
		animationPlayer.play("Run")
		motion.x += x_input * ACCELERATION * delta
		motion.x = clamp(motion.x, -MAX_SPEED, MAX_SPEED)
		sprite.flip_h = x_input < 0
		
		if x_input == 1:
			if ($Position2D.position.x) == -8:
				$Position2D.position.x *= -1
		elif x_input == -1:
			if ($Position2D.position.x) == 8:
				$Position2D.position.x *= -1
	else:
		animationPlayer.play("Idle")
		
	if Input.is_action_just_pressed("Shoot"):
		var fireball = FIREBALL.instance()
		fireball.position = $Position2D.global_position
		if $Position2D.position.x == 8:
			fireball.set_fireball_direction(1)
		else:
			fireball.set_fireball_direction(-1)
		get_parent().add_child(fireball)
		
	if is_on_floor():
		if x_input == 0:
			motion.x = lerp(motion.x, 0, FRICTION * delta)
		if Input.is_action_just_pressed("ui_up"):
			motion.y = -JUMP_FORCE
	else:
		animationPlayer.play("Jump")
		if Input.is_action_just_released("ui_up") and motion.y < -JUMP_FORCE/2:
			motion.y = -JUMP_FORCE/2
		if x_input == 0:
			motion.x = lerp(motion.x, 0, AIR_RESISTANCE)

func _on_EnemyDetector_area_entered(_area):
	motion.y = -STOMP_FORCE

func _on_EnemyDetector_body_entered(_body):
	queue_free()
