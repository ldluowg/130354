extends Node
@export var health = 0
@export var dmg = 0
@export var speed = 0

func take_damage(dmg_take):
	health -= dmg_take
	print(health)
	return self
