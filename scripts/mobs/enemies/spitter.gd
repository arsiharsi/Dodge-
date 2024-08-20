extends KinematicBody2D

export var is_aiming = false
export var aiming_speed = 0.1
var lives = 10


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
func enemy():
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	rotation_degrees = rand_range(-180,180)
	pass # Replace with function body.

func shake():
	$base.position = Vector2(rand_range(-2,2), rand_range(-2,2))
	pass


func stabilise():
	$base.position = Vector2.ZERO
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if lives <= 0 or GlobalSceneScript.kill_em_all:
		queue_free()
		GlobalSceneScript.score += 30
	$base.flip_v = abs(rotation_degrees) > 90
	if is_aiming:
		var rot_dir = sign(-rotation+global_position.direction_to(GlobalSceneScript.player_position).angle())
		rotate(rot_dir*deg2rad(aiming_speed))
	if $damager.enabled:
		GlobalSceneScript.camera_shake(3,1)
		if $damager.get_collider():
			$damager/spr.region_rect = Rect2(0,0,global_position.distance_to($damager.get_collision_point()),45)
			if $damager.get_collider().name == "player":
				if $damager.get_collider().is_alive:
					GlobalSceneScript.main_node.get_parent().player_death()
	pass
