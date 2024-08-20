extends Sprite

var time = 1.0
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
#	$anim.interpolate_property(self, "modulate",modulate, Color(1,1,1,0), 1, Tween.TRANS_LINEAR)
#	$anim.start()
	pass # Replace with function body.

func inititate():
	$anim.interpolate_property(self, "modulate",modulate, Color(1,1,1,0), time, Tween.TRANS_LINEAR)
	$anim.start()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_anim_tween_all_completed():
	queue_free()
	pass # Replace with function body.
