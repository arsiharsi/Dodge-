extends Line2D
export var max_points = 10

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	global_position = Vector2.ZERO
	global_rotation = 0
	global_scale = Vector2(1,1)
	add_point(get_parent().global_position)
	if get_point_count() > max_points:
		remove_point(0)
	pass
