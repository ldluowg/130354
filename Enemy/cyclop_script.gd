extends Enemy
var chess = preload("res://objects/chess.tscn")
@export var timer = 2
@export var skill_colddown = 5
var _can_move = true
var is_using_skill = false
var skill_direction
func  _ready():
	$Timer.wait_time = timer
	_use_skill()
func  _physics_process(delta):
	if !player.is_alive : return
	if (is_using_skill == false):
		_normal_movement()
	else :
		_movement_skill()
	move_and_slide()
	

func _normal_movement():
	var direction = global_position.direction_to(player.global_position)
	velocity = direction*movement_speed
	if direction.x >= 0.1:
		sprite.flip_h = true
	else:
		sprite.flip_h = false
	
func _movement_skill():
	pass
	
func _get_damage(damage):
	health -= damage

func _use_skill():
	var skill_speed = 4
	is_using_skill = true
	skill_direction = global_position.direction_to(player.global_position)
	animation.play("walk")
	velocity = skill_direction.normalized()*movement_speed*skill_speed
	$Timer.wait_time = timer
	$Timer.start()


func _on_timer_timeout():
	if !is_using_skill :
		_use_skill()
		return
	is_using_skill = false
	$Timer.wait_time = skill_colddown
	$Timer.start()

func defeat():
	emit_signal("enemy_defeated")
	# Biến mất enemy
	queue_free()
