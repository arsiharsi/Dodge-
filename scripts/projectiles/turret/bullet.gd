extends Projectile


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var save_speed 

func enemy_bullet():
	pass
# Called when the node enters the scene tree for the first time.
func _ready():
	save_speed = speed
	deactivate()
	pass # Replace with function body.

func _physics_process(_delta):
	if GlobalSceneScript.kill_em_all:
		queue_free()

func deactivate():
	speed = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func initate():
	direction = global_position.direction_to(GlobalSceneScript.player_position)
	$coll.set_deferred("disabled", false)
	speed = save_speed

func _on_bullet_body_entered(body):
	if body.name == "player":
		if body.is_alive:
			GlobalSceneScript.main_node.get_parent().player_death()
	queue_free()
	pass # Replace with function body.
