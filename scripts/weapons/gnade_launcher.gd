extends "res://scripts/weapons/weapon.gd"
class_name GnadeLauncher

func _ready():
	projectile = projectileScene.instantiate()
	$Timer.wait_time = 1.0 / fire_rate

func gunshot():
	if !can_shot : return
	$GunSfx.play()
	var nade = projectile.duplicate() as GnadeProjectile
	var mouse_pos = get_global_mouse_position()
	nade.from_weapon = self.duplicate()
	nade.global_position = $ProjectileSpawnLocation.global_position
	nade.rotation = rotation
	nade.destination = mouse_pos
	get_tree().root.add_child(nade)
	can_shot = false
	$Timer.start()
