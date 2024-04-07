extends Node2D

class_name EnemySpawner

## how long this event last
@export var duration = 60
## pool of mobs to spawn
@export var spawns:Array[Spawn_infor] = []
## this event will activate on current event timeout
@export var next_event:Node
## activate on enter scene
@export var activate_on_ready = false

var is_activating = false
@onready var player = Player.getPlayer()

var timer:Timer

func _ready():
	get_groups().push_back("loot")
	set_process(false)
	timer = Timer.new()
	timer.wait_time = duration
	timer.timeout.connect(_on_timer_timeout)
	add_child(timer)
	if activate_on_ready : activate()

func activate():
	set_process(true)
	timer.start()

func _process(delta):
	if !player.is_alive : false
	for i in spawns:
		var waittime =  1.0 / i.spawn_rate
		if i.spam_delay_counter < waittime:
			i.spam_delay_counter += delta
		else:
			i.spam_delay_counter = 0
			var new_enemy = load(str(i.enemy.resource_path))
			var enemy_spawn = new_enemy.instantiate()
			enemy_spawn.global_position = get_random_position()
			add_child(enemy_spawn)

func _on_timer_timeout():
	set_process(false)
	(next_event as EnemySpawner).activate()
				
func get_random_position():
	var vpr = get_viewport_rect().size * randf_range(1.1,1.4)
	var top_left = Vector2(player.global_position.x - vpr.x/2, player.global_position.y - vpr.y/2)
	var top_right = Vector2(player.global_position.x + vpr.x/2, player.global_position.y - vpr.y/2)
	var bottom_left = Vector2(player.global_position.x - vpr.x/2, player.global_position.y + vpr.y/2)
	var bottom_right = Vector2(player.global_position.x + vpr.x/2, player.global_position.y + vpr.y/2)
	var pos_side = ["up","down","right","left"].pick_random()
	var spawn_pos1 = Vector2.ZERO
	var spawn_pos2 = Vector2.ZERO
	
	match pos_side:
		"up":
			spawn_pos1 = top_left
			spawn_pos2 = top_right
		"down":
			spawn_pos1 = bottom_left
			spawn_pos2 = bottom_right
		"right":
			spawn_pos1 = top_right
			spawn_pos2 = bottom_right
		"left":
			spawn_pos1 = top_left
			spawn_pos2 = bottom_left
	var x_spawm = randf_range(spawn_pos1.x, spawn_pos2.x)
	var y_spawn = randf_range(spawn_pos1.y, spawn_pos2.y)
	
	return Vector2(x_spawm, y_spawn)
