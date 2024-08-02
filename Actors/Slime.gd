extends KinematicBody2D

const SPEED = 32
const GRAVITY = 200

var motion = Vector2.ZERO
var _is_moving_left = true
onready var animationPlayer = $AnimationPlayer

func _physics_process(delta):
	setGravity(delta)
	setMoviment()
	detectWall()
	
func setGravity(delta):
	motion.y += GRAVITY * delta
	
func setMoviment():
	animationPlayer.play("Run")
	motion.x = -SPEED if _is_moving_left else SPEED
	motion.x = clamp(motion.x, -SPEED, SPEED)
	motion = move_and_slide(motion)
	
func detectWall():
	if $RayCast2D.is_colliding():
		_is_moving_left = !_is_moving_left
		scale.x = -scale.x

func _on_StompDetector_body_entered(body):
	if body.global_position.y < get_node("StompDetector").global_position.y:
		call_deferred("set", "disabled", true)
		queue_free()
	else:
		return
	
func _on_Hitbox_area_entered(area):
	queue_free()
