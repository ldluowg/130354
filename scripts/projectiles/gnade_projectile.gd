extends Projectile
class_name GnadeProjectile

@export var explosion_range = 80
@export var explosion_delay = 1.5
@export var max_travel_distant = 150

var start
var controll_point
var destination:Vector2
var travel_time = 0

func _ready():
	$CollisionShape2D.shape.radius = explosion_range
	$Timer.wait_time = explosion_delay
	$Timer.start()
	start = global_position
	if (global_position - destination).length() > max_travel_distant :
		destination = global_position + (Vector2.RIGHT.rotated(rotation) * max_travel_distant) + Player.getPlayer().velocity.normalized()
	controll_point = global_position + (destination - global_position)/3	
	
func _process(delta):
	travel_time += delta
	if travel_time > explosion_delay : travel_time = explosion_delay
	position = position.bezier_interpolate(start,controll_point,destination, travel_time / explosion_delay)
	
func _on_explosion():
	$PSfx.play()
	$AnimationPlayer.play("explode")
	var enemys = get_colliding_bodies() as Array[Enemy]
	for enemy in enemys :
		enemy.take_damage(damage)
		DamageIndicatorManager.get_damage_indicator_manager().display_player_damage(enemy.global_position,damage)


func _on_animation_player_animation_finished(anim_name):
	call_deferred("free")
