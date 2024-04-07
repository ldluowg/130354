extends CharacterBody2D
class_name Enemy

signal enemy_defeated

static var kill_count = 0

@export var movement_speed = 50
@export var health = 70
@export var dmg = 1
@export var exp = 1
@export var speed = 0
@onready var player = Player.getPlayer()
@onready var sprite = $Sprite2D
@onready var animation = $AnimationPlayer
@onready var loot_base = get_tree().get_first_node_in_group("loot")
var exp_gem = preload("res://objects/experience.tscn")

func _ready():
	animation.play("walk")
	

func  _physics_process(_delta):
	if !player.is_alive : return
	var direction = global_position.direction_to(player.global_position)
	velocity = direction*movement_speed
	
	if direction.x >= 0.1:
		sprite.flip_h = true
	else:
		sprite.flip_h = false
	move_and_slide()
	
	for i in get_slide_collision_count():
		var colli = get_slide_collision(i)
		if colli.get_collider().has_method("take_damage") :
			colli.get_collider().take_damage(dmg)

func take_damage(dmg_take):
	health -= dmg_take
	if health <=0:
		print(health)
		defeat()
		return self


func defeat():
	Enemy.kill_count += 1
	# Phát tín hiệu enemy_defeated
	emit_signal("enemy_defeated")
	var new_gem = exp_gem.instantiate()
	new_gem.global_position = global_position
	new_gem.exp_value = exp
	get_tree().current_scene.call_deferred("add_child", new_gem)
	# Biến mất enemy
	queue_free()

func _on_hurt_box_hurt(damage):
	health -= damage
	print(health)
	defeat()
	return self
