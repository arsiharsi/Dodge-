extends "res://scripts/projectiles/projectile_base.gd"


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
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_bullet_body_entered(body):
	if body.name != "player" and !body.has_method("enemy"):
		queue_free()
	elif body.has_method("enemy"):
		add_hit_parts()
		queue_free()
		body.lives -= 1
	pass # Replace with function body.
