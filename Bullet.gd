extends Area2D

const SPEED = 100
var motion = Vector2.ZERO
var direction = 1

func _physics_process(delta):
	motion.x = SPEED * delta * direction
	translate(motion)

func set_fireball_direction(dir):
	direction = dir
	
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
	
func _on_Bullet_body_entered(body):
	queue_free()
