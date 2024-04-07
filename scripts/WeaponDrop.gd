extends RigidBody2D
class_name WeaponDrop
var magnum = preload("res://prefabs/weapon/magnum.tscn")
var flame_thrower = preload("res://prefabs/weapon/FlameThrower.tscn")
#var gnade_launcher = preload("res://prefabs/weapon/GnadeLauncher.tscn")
var list_weapon = [magnum, flame_thrower]
var randomIndex = randi_range(0, list_weapon.size() - 1)
var chosenWeaponScene = list_weapon[randomIndex]
var weapon_src = chosenWeaponScene
@export var WeaponScene:PackedScene = weapon_src
func _on_body_entered(body):
	var player:Player = body.get_parent()
	player.pick_up_weapon(WeaponScene.instantiate())
	queue_free()
