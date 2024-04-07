extends Area2D

var _ready = false


func _on_body_entered(body):
	if _ready:
		Player.getPlayer()._is_oxi_zone = true
		


func _on_body_exited(body):
	if _ready:
		Player.getPlayer()._is_oxi_zone= false
		


func _on_timer_timeout():
	_ready = true
