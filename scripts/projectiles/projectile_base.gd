extends Area2D
class_name Projectile


export(float) var speed
export(Vector2) var direction
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_node_or_null("spr"):
		get_node("spr").rotation = direction.angle()
	global_position += direction*speed*delta
	pass
