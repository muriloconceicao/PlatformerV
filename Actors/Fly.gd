extends KinematicBody2D

const SPEED = 16

onready var animationPlayer = $AnimationPlayer
var motion = Vector2.ZERO
var _is_flying_up = true

func _physics_process(_delta):
	setMovement()
	detectFloor()
	detectCelling()
	
func setMovement():
	animationPlayer.play("Fly")
	motion.y = -SPEED if _is_flying_up else SPEED
	motion.y = clamp(motion.y, -SPEED, SPEED)
	motion = move_and_slide(motion)
	
func detectCelling():
	if $RayCast2D.is_colliding():
		_is_flying_up = false
		
func detectFloor():
	if $RayCast2D2.is_colliding():
		_is_flying_up = true

func _on_StompDetector_body_entered(body):
	if body.global_position.y < get_node("StompDetector").global_position.y:
		call_deferred("set", "disabled", true)
		queue_free()
	else:
		return
