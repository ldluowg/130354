extends RigidBody2D
class_name Projectile

@export var speed = 10 : 
	set (val) : speed = val  
	get : 
		if from_weapon :
			return speed + from_weapon.powerup_modifier.speed
		return speed
@export var damage = 10 :
	set (val) : damage = val
	get:
		if from_weapon :
			var damage_valie = from_weapon.powerup_modifier.damage + damage
			return damage_valie
		return damage
@export var pierce = 0 :
	set (val) : pierce = val
	get :
		if from_weapon :
			return pierce + from_weapon.powerup_modifier.pierce
		return pierce

var from_weapon:Weapon :
	set (weap) : 
		from_weapon = weap
		if !from_weapon.is_connected("tree_exiting",on_parent_exit) :
			from_weapon.tree_exiting.connect(on_parent_exit)
	get : return from_weapon

func on_parent_exit():
	queue_free()

func _process(delta):
	move_local_x(speed * delta * 100)
	
func _on_body_entered(enemy):
	var dmgIndiManager = DamageIndicatorManager.get_damage_indicator_manager()
	if !dmgIndiManager : return
	print(damage)
	enemy.take_damage(damage)
	dmgIndiManager.display_player_damage(enemy.global_position,damage)
	pierce -= 1
	if pierce < 0 :
		$Bullet.hide()
		call_deferred("set_contact_monitor", false)
		queue_free()
