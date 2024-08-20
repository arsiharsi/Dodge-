extends Node2D
export(Texture) var texture
export(float) var time
export(float) var cd
export(bool) var emitting
var can_emit = true
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if can_emit and emitting:
		emit()
		$cd.start(cd)
		can_emit = false
	pass

func emit():
	if GlobalSceneScript.main_node:
		var spr = $spr_base.duplicate()
		spr.texture = texture
		spr.time = time
		spr.global_position = global_position
		spr.global_rotation = global_rotation
		spr.global_scale = global_scale
		GlobalSceneScript.main_node.add_child(spr)
		spr.inititate()
	pass


func _on_cd_timeout():
	can_emit = true
	pass # Replace with function body.
