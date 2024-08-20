extends Projectile


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var hit_parts = load("res://tscns/misc/time_particles.tscn")
func add_hit_parts():
	var parts = hit_parts.instance()
	parts.global_position  = global_position
	GlobalSceneScript.main_node.add_child(parts)
# Called when the node enters the scene tree for the first time.
func _ready():
	$anim.play(str(int(rand_range(0,2))))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_sword_body_entered(body):
	if body.has_method("enemy"):
		body.lives -= 5
		add_hit_parts()
	elif body.has_method("enemy_bullet"):
		body.queue_free()
	pass # Replace with function body.


func _on_sword_area_entered(area):
	if area.has_method("enemy_bullet"):
		area.queue_free()
		add_hit_parts()
	pass # Replace with function body.
