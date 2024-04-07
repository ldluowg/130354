extends StaticBody2D
class_name Coral

var _coral_array = ["coral_1","coral_2","coral_3","coral_4","coral_5","coral_6"]
static var _size = 1280 #pixel
var _distance = 128#pixel
var _coral_spawn_rate = 10
# Called when the node enters the scene tree for the first time.
func _ready():
	for x in range(0,int(_size/_distance)):
		for y in range(0,int(_size/_distance)):
			if(randf_range(0,100)<_coral_spawn_rate):
				var coral = load("res://Textures/Map/"+_coral_array[randi()%_coral_array.size()]+".tscn").instantiate()
				coral.global_position = Vector2i(x*_distance*randf_range(0.25,0.75), y*_distance*randf_range(0.25,0.75))
				add_child(coral)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
