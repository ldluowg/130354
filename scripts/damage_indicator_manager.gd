extends Node
class_name DamageIndicatorManager

static var damageIndicatorManager:DamageIndicatorManager = null
static func get_damage_indicator_manager()->DamageIndicatorManager:
	return DamageIndicatorManager.damageIndicatorManager
# Called when the node enters the scene tree for the first time.
func _ready():
	DamageIndicatorManager.damageIndicatorManager = self
	$PlayerDamage.visible = false

func display_player_damage(display_position:Vector2,damage):
	var indicator:DamageIndicator = $PlayerDamage.duplicate()
	indicator.display_damage(display_position,damage)
	get_tree().root.add_child(indicator)
