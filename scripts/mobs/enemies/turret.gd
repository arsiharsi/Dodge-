extends KinematicBody2D

var vec = Vector2.ZERO
var dir = Vector2.ZERO
var last_player_pos = Vector2.ZERO
export var lives = 3
export var max_speed = 20000
export var acceleration = 500
var can_shoot = false
var bullet_scene = load("res://tscns/projectiles/enemies/bullet.tscn")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func enemy():
	pass
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if can_shoot:
		emit()
		$sounds/shoot.play()
		can_shoot = false
	look_at(GlobalSceneScript.player_position)
	vec = last_player_pos.direction_to(GlobalSceneScript.player_position)
	if lives <= 0 or GlobalSceneScript.kill_em_all:
		queue_free()
		GlobalSceneScript.score += 100
		GlobalSceneScript.camera_shake(0.5,0.5)
	dir += acceleration*vec*delta
	dir.clamped(max_speed)
	dir = move_and_slide(dir)
	last_player_pos = GlobalSceneScript.player_position
	pass


func emit():
	var bullet = bullet_scene.instance()
	bullet.direction = global_position.direction_to(GlobalSceneScript.player_position)
	bullet.global_position = global_position
	GlobalSceneScript.main_node.add_child(bullet)
	bullet.initate()


func _on_cd_timeout():
	can_shoot = true
	pass # Replace with function body.
