extends RigidBody2D
class_name Experience

@export var exp_value = 1
@export var follow_speed = 5
@onready var sprite = $Sprite2D

var spr_blue = preload("res://Textures/Items/Gems/Gem_blue.png")
var spr_green = preload("res://Textures/Items/Gems/Gem_green.png")
var spr_red = preload("res://Textures/Items/Gems/Gem_red.png")
var move_toward_player = false
var playerNode:Player = null


func _ready():
	$Sprite2D.texture = spr_blue
	if exp_value <5:
		return
	elif exp_value <25 && exp_value >5:
		sprite.texture = spr_green
	else:
		sprite.texture = spr_red
		
func _process(delta):
	if !move_toward_player : return
	var player_pos = playerNode.position
	position = position.slerp(player_pos,delta * follow_speed)
	var distant = position.distance_to(player_pos)
	if abs(distant) < playerNode.get_node("PlayerCollision").shape.radius :
		_add_player_exp()
		call_deferred("free")
	
func _on_player_pickup(body):
	var player:Player = body.get_parent()
	playerNode = player
	call_deferred("set_contact_monitor",false)
	move_toward_player = true
	
func _add_player_exp():
	playerNode.pick_up_exp(exp_value)
