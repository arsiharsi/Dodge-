extends KinematicBody2D

export var lives = 3
export var max_speed = 20000
export var acceleration = 500
var actual_speed = 0
var vec = Vector2.ZERO
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
func enemy():
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	vec = global_position.direction_to(GlobalSceneScript.player_position)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if lives <= 0 or GlobalSceneScript.kill_em_all:
		queue_free()
		GlobalSceneScript.score += 10
		GlobalSceneScript.camera_shake(0.5,0.5)
	actual_speed += acceleration
	actual_speed = clamp(actual_speed,0,max_speed)
	move_and_slide(vec*actual_speed*delta)
	pass


func _on_check_body_entered(body):
	if !body.has_method("enemy"):
		if body.name == "player":
			if body.collision_layer != 4 and body.is_alive:
				GlobalSceneScript.main_node.get_parent().player_death()
		else:
			$sounds/crash.play()
			vec = global_position.direction_to(GlobalSceneScript.player_position)
			actual_speed = 0
	pass # Replace with function body.


func _on_add_score_for_dodge_body_entered(body):
	if body.name == "player":
		if body.is_alive:
			GlobalSceneScript.score += 30
	pass # Replace with function body.
