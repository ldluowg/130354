extends StaticBody2D

@export var hp = 15

func _ready():
	set_collision_mask_value(1,true)
	set_collision_mask_value(2,true)
	set_collision_layer_value(1,false)
	set_collision_layer_value(11,true)
	
func take_damage(damage):
	hp -= damage
	if hp <= 0:
		queue_free()
