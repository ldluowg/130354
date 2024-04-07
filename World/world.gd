extends Node2D

var _cap = 0.1
var _start_current_map=Vector2(0,0)
var _end_current_map=Vector2(0,0)
@export var _tree_spawn_rate = 5
@export var _bush_spawn_rate = 10
@export var _grass_spawn_rate = 15
@export var _coral_spawn_rate = 0.5
@export var _oxi_spawn_rate = 1

#var _noise = FastNoiseLite.new()

var _range_x = null
var _range_y = null
var _tree_array = ["tree","tree1","tree2"]
var _bush_array = ["bush","bush1","bush2","bush3","bush4","bush5"]
enum MapType {
	GROUND,
	WATER
}
@export var _map:MapType = MapType.GROUND
@onready var _view_size=get_viewport_rect().size
@onready var _tile_size = Vector2(64,64)
@onready var _player= Player.getPlayer()
# Called when the node enters the scene tree for the first time.

func set_map(_map_type):
	if(_map_type == 0):
		_map = MapType.GROUND
	elif (_map_type == 1):
		_map = MapType.WATER
	else:
		print("Map ",MapType," khong ton tai")

func _ready():
	_start_current_map = Vector2(0-_view_size.x*2,0-_view_size.y*2)
	_end_current_map = Vector2(_view_size.x*2,_view_size.y*2)
	_gen_map(Vector2(-2000,-2000),Vector2(2000,2000))
	if _map == MapType.GROUND:
		add_child(load("res://World/background.tscn").instantiate())
	elif _map == MapType.WATER:
		add_child(load("res://World/backwater.tscn").instantiate())
		_player.get_node("OxiBar").visible = true
		_player.get_node("TimerGroup").get_node("OxiTimer").start()
func _process(delta):
	_update_map()
func _gen_map(_start:Vector2,_end:Vector2):
#	_noise.seed = randi()
	_range_x = range(int(_start.x/_tile_size.x),int(_end.x/_tile_size.x))
	_range_y = range(int(_start.y/_tile_size.y),int(_end.y/_tile_size.y))
	if _map == MapType.GROUND:
		for x in _range_x:
			for y in _range_y:
#				var a = _noise.get_noise_2d(x,y)
				if(randf_range(0,100)<_tree_spawn_rate):
						var tree = load("res://Textures/Map/"+_tree_array[randi()%_tree_array.size()]+".tscn").instantiate()
						tree.global_position = Vector2(x*_tile_size.x + _tile_size.x, y*_tile_size.y+ _tile_size.y*0.5)
						add_child(tree)
				elif(randf_range(0,100)<_bush_spawn_rate):
						var bush = load("res://Textures/Map/"+_bush_array[randi()%_bush_array.size()]+".tscn").instantiate()
						bush.global_position = Vector2(x*_tile_size.x + _tile_size.x, y*_tile_size.y + _tile_size.y*0.5)
						add_child(bush)
			
					
#				if(randf_range(0,100)<_tree_spawn_rate):
#						var grass = load("res://Textures/Map/grass.tscn").instantiate()
#						grass.global_position = Vector2(x*_tile_size.x*cliff.scale.x + _tile_size.x*cliff.scale.x*0.5, y*_tile_size.y*cliff.scale.y + _tile_size.y*0.5*cliff.scale.y)
#						add_child(grass)
#				if(a<_cap):
#					_cells.append(Vector2(x,y))
#					if(randf_range(0,100)<_tree_spawn_rate):
#						var tree = load("res://Textures/Map/"+_tree_array[randi()%_tree_array.size()]+".tscn").instantiate()
#						tree.global_position = Vector2(x*_tile_size.x*cliff.scale.x + _tile_size.x*cliff.scale.x*0.5, y*_tile_size.y*cliff.scale.y + _tile_size.y*0.5*cliff.scale.y)
#						add_child(tree)
#				else:
#					if(randf_range(0,100)<_bush_spawn_rate):
#						var bush = load("res://Textures/Map/"+_bush_array[randi()%_bush_array.size()]+".tscn").instantiate()
#						bush.global_position = Vector2(x*_tile_size.x*cliff.scale.x + _tile_size.x*cliff.scale.x*0.5, y*_tile_size.y*cliff.scale.y + _tile_size.y*0.5*cliff.scale.y)
#						add_child(bush)
#					cliff.set_cell(0,Vector2(x,y),0,Vector2(0,4),0)
	
	
	elif _map == MapType.WATER:
		for x in range(int(_start.x/_tile_size.x),int(_end.x/_tile_size.x)):
			for y in range(int(_start.y/_tile_size.y),int(_end.y/_tile_size.y)):
#				var a = _noise.get_noise_2d(x,y)
				if(randf_range(0,100)<_oxi_spawn_rate):
						var newOxi = load("res://Textures/Map/oxi_bubble.tscn").instantiate()
						newOxi.global_position = Vector2(x*_tile_size.x + _tile_size.x, y*_tile_size.y + _tile_size.y)
						add_child(newOxi)
				if(randf_range(0,100)<_coral_spawn_rate):
						var newCoral = load("res://Textures/Map/coral.tscn").instantiate()
						newCoral.global_position = Vector2(x*_tile_size.x + _tile_size.x, y*_tile_size.y + _tile_size.y)
						add_child(newCoral)
#			
		
		
func _update_map():
	
	var _start_trigger_zone = Vector2(_start_current_map.x + _view_size.x,_start_current_map.y + _view_size.y)
	var _end_trigger_zone = Vector2(_end_current_map.x - _view_size.x,_end_current_map.y - _view_size.y)
	if(_player.global_position.x<=_start_trigger_zone.x):  
		if(_player.global_position.y>=(_start_trigger_zone.y+_end_trigger_zone.y)/2):
			_gen_map(Vector2(_start_current_map.x-_view_size.x,_start_current_map.y),Vector2(_start_current_map.x,_start_current_map.y+_view_size.y*3))
		else:
			_gen_map(Vector2(_start_current_map.x-_view_size.x,_start_current_map.y-_view_size.y),Vector2(_start_current_map.x,_start_current_map.y+_view_size.y*2))
		_start_current_map=Vector2(_start_current_map.x-_view_size.x,_start_current_map.y)
		_end_current_map = Vector2(_end_current_map.x-_view_size.x,_end_current_map.y)
	if(_player.global_position.x>= _end_trigger_zone.x):
		if(_player.global_position.y>=(_start_trigger_zone.y+_end_trigger_zone.y)/2):
			_gen_map(Vector2(_end_current_map.x,_end_current_map.y-_view_size.y*2),Vector2(_end_current_map.x+_view_size.x,_end_current_map.y+_view_size.y))
		else:
			_gen_map(Vector2(_end_current_map.x,_end_current_map.y-_view_size.y*3),Vector2(_end_current_map.x+_view_size.x,_end_current_map.y))
		_start_current_map=Vector2(_start_current_map.x+_view_size.x,_start_current_map.y)
		_end_current_map = Vector2(_end_current_map.x+_view_size.x,_end_current_map.y)
	if(_player.global_position.y<= _start_trigger_zone.y):
		if(_player.global_position.x>=(_start_trigger_zone.x+_end_trigger_zone.x)/2):
			_gen_map(Vector2(_start_current_map.x,_start_current_map.y-_view_size.y),Vector2(_start_current_map.x+_view_size.x*3,_start_current_map.y))
		else:
			_gen_map(Vector2(_start_current_map.x-_view_size.x,_start_current_map.y-_view_size.y),Vector2(_start_current_map.x+_view_size.x*2,_start_current_map.y))
		_start_current_map=Vector2(_start_current_map.x,_start_current_map.y-_view_size.y)
		_end_current_map = Vector2(_end_current_map.x,_end_current_map.y-_view_size.y)
	if(_player.global_position.y>= _end_trigger_zone.y):
		if(_player.global_position.x>=(_start_trigger_zone.x+_end_trigger_zone.x)/2):
			_gen_map(Vector2(_end_current_map.x-_view_size.x*2,_end_current_map.y),Vector2(_end_current_map.x+_view_size.x,_end_current_map.y+_view_size.y))
		else:
			_gen_map(Vector2(_end_current_map.x-_view_size.x*3,_end_current_map.y),Vector2(_end_current_map.x,_end_current_map.y+_view_size.y))
		_start_current_map=Vector2(_start_current_map.x,_start_current_map.y+_view_size.y)
		_end_current_map = Vector2(_end_current_map.x,_end_current_map.y+_view_size.y)
