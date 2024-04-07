extends CanvasLayer

var currentTarget = null
var previosAnime = ""

func _ready():
	$AnimationTransition.play("RESET")

func change_scene(target:String)->void:	
	$AnimationTransition.play('ShadeIn')
	currentTarget = target
	previosAnime = "ShadeIn"

func _on_animation_transition_animation_finished(anim_name):
	if !currentTarget : return
	if "ShadeOut" == anim_name : return
	get_tree().change_scene_to_file(currentTarget)
	$AnimationTransition.play('ShadeOut')
	previosAnime = "ShadeOut"
