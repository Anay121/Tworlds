extends Actor


export var stomp_impulse: = 300.0
onready var anim_player: AnimationPlayer = get_node("AnimationPlayer")
var dead = 0
var player_tex1 = preload("res://assets/player.png")
var player_tex2 = preload("res://assets/playerDark.png")
var i = 0
var levelList = ["Level0", "Level0a","Level0b","Level1","Level2","Level3","Level4","Level8","Level5","Level6","Level7","Level9","Level10","TheEnd"]
# warning-ignore:unused_argument
func _on_StompDetector_area_entered(area: Area2D) -> void:
	print('yay', area)
	_velocity = calculate_stomp_velocity(_velocity, stomp_impulse)


# warning-ignore:unused_argument
func _on_EnemyDetector_body_entered(_body: PhysicsBody2D) -> void:
#	anim_player.play("DeathAnimation")
	dead = 1

#for me!
func _on_SpikeDetector_area_entered(_area: Area2D) -> void:
	anim_player.play("DeathAnimation")
	dead = 1

func _on_TrophyBox_area_entered(area):
	get_tree().change_scene("res://src/Levels/Level0.tscn")
	
func _on_PortalDetector_area_entered(area):
	var cur = get_tree().get_current_scene().get_name()
	print(cur)
	var i = 0
	while levelList[i] != cur:
		i+=1
	i+=1
	get_tree().change_scene("res://src/Levels/"+levelList[i]+".tscn")

# warning-ignore:unused_argument
func _physics_process(delta: float) -> void:
	if not dead:
		var is_jump_interrupted: = Input.is_action_just_released("jump") and _velocity.y < 0.0
		var direction: = get_direction()
		_velocity = calculate_move_velocity(_velocity, direction, speed, is_jump_interrupted)
		var snap: Vector2 = Vector2.DOWN * 60.0 if direction.y == 0.0 else Vector2.ZERO
		_velocity = move_and_slide_with_snap(
			_velocity, snap, FLOOR_NORMAL, true
		)
		if position.y > 1520:
			dead = 1
			anim_player.play("DeathAnimation")
	if not dead and Input.is_action_just_released("switch"):
#		switch()
		anim_player.play("SwitchAnimation")


func get_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		-Input.get_action_strength("jump") if is_on_floor() and Input.is_action_just_pressed("jump") else 0.0
	)

func switch_pic(isLight: bool) -> void:
	if isLight:
		get_node("Sprite").set_texture(player_tex1)
	else:
		get_node("Sprite").set_texture(player_tex2)


func calculate_move_velocity(
		linear_velocity: Vector2,
		direction: Vector2,
		speed: Vector2,
		is_jump_interrupted: bool
	) -> Vector2:
	var velocity: = linear_velocity
	velocity.x = speed.x * direction.x
	if direction.y != 0.0:
		velocity.y = speed.y * direction.y
	if is_jump_interrupted:
		velocity.y = 0.0
	return velocity


# warning-ignore:shadowed_variable
func calculate_stomp_velocity(linear_velocity: Vector2, stomp_impulse: float) -> Vector2:
	var stomp_jump: = -speed.y if Input.is_action_pressed("jump") else -stomp_impulse
	return Vector2(linear_velocity.x, stomp_jump)


func die() -> void:
	queue_free()
	get_tree().reload_current_scene()

func switch() -> void:
	if position.y > 650:
		position.y = 350
		switch_pic(true)
	else:
		position.y = 900
		switch_pic(false)
