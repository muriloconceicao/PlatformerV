extends KinematicBody2D

const SPEED = 38
const GRAVITY = 200

enum {
	WANDER,
	CHASE
}

var motion = Vector2.ZERO
var _is_moving_left = true
var state = WANDER
onready var animationPlayer = $AnimationPlayer
onready var playerDetectionZone = $PlayerDetectionZone
onready var sprite = $Sprite
onready var raycast = $RayCast2D

func _physics_process(delta):
	
	match state:
		WANDER:
			seek_player()
			wander()
		CHASE:
			chase()
			
	detectWall()
	setGravity(delta)
	
func setGravity(delta):
	motion.y += GRAVITY * delta
	
func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE

func wander():
	animationPlayer.play("Walk")
	motion.x = -SPEED if _is_moving_left else SPEED
	motion.x = clamp(motion.x, -SPEED, SPEED)
	motion = move_and_slide(motion)
	
func chase():
	var player = playerDetectionZone.player
	if player != null:
		var direction = (player.global_position - global_position).normalized()
		motion = motion.move_toward(direction * SPEED, SPEED)
	else:
		state = WANDER
		
	changeDirection()
	motion = move_and_slide(motion)
	
func detectWall():
	if raycast.is_colliding():
		if !_is_moving_left:
			flipWalker(false, 90)
		else:
			flipWalker(true, -90)

func changeDirection():
	if motion.x < 0:
		flipWalker(false, 90)
	else:
		flipWalker(true, -90)
		
func flipWalker(flip, degress):
	sprite.flip_h = flip
	raycast.rotation_degrees = degress
	_is_moving_left = !flip
	
func _on_StompDetector_body_entered(body):
	if body.global_position.y < get_node("StompDetector").global_position.y:
		call_deferred("set", "disabled", true)
		queue_free()
	else:
		return
