extends Actor

#onready var stomp_area: Area2D = $StompArea2D

func _ready() -> void:
	set_physics_process(false)
	_velocity.x = -speed.x


func _physics_process(delta: float) -> void:
	_velocity.x *= -1 if is_on_wall() else 1
	_velocity.y = move_and_slide(_velocity, FLOOR_NORMAL).y

func _on_StompArea2D_body_entered(body: Node) -> void:
	if body.global_position.y > get_node("StompArea2D").global_position.y:
		return
	die()

func _on_StompArea2D_area_entered(body: Node) -> void:
	if body.global_position.y > get_node("StompArea2D").global_position.y:
		return
	die()

func die() -> void:
	queue_free()
	var parent = get_node('..')
	if parent is Timer:
		parent.enemyDied()
