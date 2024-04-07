extends Projectile
class_name FlameThrowerProjectile

var canDamageEnemy = true
var hit_delay = 0.5

func on_parent_exit():
	pass

func _ready(): 
	from_weapon = get_parent()
	if from_weapon : from_weapon = from_weapon as FlameThrower
	$Timer.wait_time = hit_delay
	

func _process(delta):
	if !canDamageEnemy : return
	if !contact_monitor : return
	var enemy_list = get_colliding_bodies()
	for enem in enemy_list :
		enem.take_damage(damage)
		DamageIndicatorManager.get_damage_indicator_manager().display_player_damage(enem.global_position,damage)
	canDamageEnemy = false
	$Timer.start()
	
	
func _on_body_entered(enemy):
	pass

func deactivate():
	$AnimatedSprite2D.stop()
	$AnimatedSprite2D.play("flame_thrower_end")
	$GPUParticles2D.emitting = false
	contact_monitor = false
	
func activate():
	if (!(from_weapon as FlameThrower).is_activated):
		$AnimatedSprite2D.play("flame_thrower_init")
		$GPUParticles2D.emitting = true
		contact_monitor = true
	
func hit_delay_countdown():
	canDamageEnemy = true

func anime_change():
	if $AnimatedSprite2D.animation == "flame_thrower_init":
		$AnimatedSprite2D.play("flame_thrower_throwing")
