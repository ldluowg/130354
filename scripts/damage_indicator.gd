extends Node2D

class_name DamageIndicator

var damage_type = {
	player = {
		color = Color(0,0,0)
	}
}

func display_damage(display_position,damage) -> DamageIndicator:
	position = display_position
	visible = true
	$DamageLabel.text = str(damage)
	$AnimationPlayer.play("show_indicator")
	return self


func _on_display_end(anim_name):
	queue_free()
