extends RigidBody2D
class_name Chess

@export var exp_value = 1
@export var follow_speed = 5
@onready var sprite = $Sprite2D
var chess = preload("res://Textures/Items/Chess/chess.jpg")
@onready var animation = $AnimationPlayer
var weapon_drop = preload("res://objects/weapon_drops/weapon_drop.tscn")
@onready var loot_base = get_tree().get_first_node_in_group("loot")
var move_toward_player = false
var playerNode:Node2D = null


func _ready():
	animation.play("jumping")
	sprite.texture = chess
		
func _process(delta):
	animation.play("jumping")
	if !move_toward_player : return
	var player_pos = playerNode.position
	position = position.slerp(player_pos,delta * follow_speed)
	var distant = position.distance_to(player_pos)
	if abs(distant) < playerNode.get_node("PlayerCollision").shape.radius :
		call_deferred("free")

func _on_player_pickup(body):
	print("exp value:")
	print(exp_value)
	var player:Player = body.get_parent()
	playerNode = player
	move_toward_player = true
	player.pick_up_exp(exp_value)
	call_deferred("set_contact_monitor",false)
	var new_weapon = weapon_drop.instantiate()
	new_weapon.global_position = global_position
	loot_base.call_deferred("add_child", new_weapon)
	queue_free()
