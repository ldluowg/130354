extends  "res://scripts/weapons/weapon.gd"
#extends Weapon
class_name Magnum

func gunshot():
	if !can_shot : return false
	can_shot = false
	play_sfx()
	var shot_pos = $ProjectileSpawnLocation.global_position
	var spawnProjectile:Projectile = projectile.duplicate() as Projectile
	spawnProjectile.from_weapon = self.duplicate()
	spawnProjectile.global_position = shot_pos
	spawnProjectile.rotation = rotation
	get_tree().current_scene.add_child(spawnProjectile)
	$Timer.wait_time = 1.0 / (fire_rate)
	$Timer.start()
	return true

func face_to(look_position:Vector2) -> Weapon:
	look_at(look_position)
	if rotation_degrees > -90 and rotation_degrees < 90:
		$Sprite2D.flip_v = false
	else :
		$Sprite2D.flip_v = true
	return self
	
func best_match_action(_action):
	pass

func best_match_action_alt(_action):
	pass

func transition_to_right():
	$ProjectileSpawnLocation.position.y = 90
	
func transition_to_left():
	$ProjectileSpawnLocation.position.y = -90
	
