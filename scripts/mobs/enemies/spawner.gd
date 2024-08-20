extends Sprite

export(int) var max_spawn = 1
export(Array) var enemies

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	global_position = Vector2(rand_range(15,1009),rand_range(15,585))
	pass # Replace with function body.

func spawn_enemy():
	var enemy = enemies[int(rand_range(0, max_spawn))].instance()
	enemy.global_position = global_position
	enemy.global_scale = Vector2(1,1)
	enemy.global_rotation = 0
	GlobalSceneScript.add_child(enemy)
	queue_free()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if global_position.distance_to(GlobalSceneScript.player_position) < 170:
		global_position = Vector2(rand_range(15,1009),rand_range(15,585))
	pass
