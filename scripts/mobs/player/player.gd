extends KinematicBody2D

export var invinsivle = false
export var controls_checked = false
var is_alive = true
export var base_speed = 10000
export var dodge_speed = 20000
var is_in_dash = false
var can_shoot = true
var can_dash = true
var basic_bullet_tscn = load("res://tscns/projectiles/player/basic_bullet.tscn")
var sword_tscn = load("res://tscns/projectiles/player/sword.tscn")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
func kill():
	if !invinsivle:
		$sounds/death.play()
		is_alive = false
		$death_revive.play("death")
	pass

func revive():
	$sounds/revive.play()
	is_alive = true
	$death_revive.play("revive")

# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalSceneScript.player_node = self
	randomize()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$spr/flashing_images.texture = $spr.texture
	if is_alive:
		if !is_in_dash:
			collision_layer = 3
			collision_mask = 3
		else:
			collision_layer = 4
			collision_mask = 4
		GlobalSceneScript.player_position = global_position
		if GlobalSceneScript.current_weapon == "blaster":
			if Input.is_action_just_pressed("m1"):
				shoot_bullet()
			if Input.is_action_pressed("m1") and can_shoot:
				shoot_bullet()
		if GlobalSceneScript.current_weapon == "sword":
			if Input.is_action_pressed("m1") and can_shoot:
				swing_sword()
		if Input.is_action_just_pressed("dodge") and $timers/dash_timer.time_left == 0 and can_dash:
			is_in_dash = true
			can_dash = false
			$timers/dash_timer.start()
			$timers/dash_cd_timer.start()
		$spr.look_at(get_global_mouse_position())
		var vec = Vector2.ZERO
		vec.x = int(Input.is_action_pressed("ui_right"))-int(Input.is_action_pressed("ui_left"))
		vec.y = int(Input.is_action_pressed("ui_down"))-int(Input.is_action_pressed("ui_up"))
		if vec.length() > 0 and !controls_checked:
			$controls/end.play("end")
		move_and_slide(vec*delta*(int(is_in_dash)*dodge_speed+base_speed))
		$spr/flashing_images.emitting = is_in_dash
	pass

func shoot_bullet():
	var basic_bullet = basic_bullet_tscn.instance()
	basic_bullet.global_position = global_position
	basic_bullet.direction = global_position.direction_to(get_global_mouse_position())
	can_shoot = false
	$timers/shoot_timer.start()
	get_parent().add_child(basic_bullet)
	pass

func swing_sword():
	var sword = sword_tscn.instance()
	sword.direction = global_position.direction_to(get_global_mouse_position())
	can_shoot = false
	$timers/sword_cd_timer.start()
	add_child(sword)
	sword.look_at(get_global_mouse_position())
	pass


func _on_dash_timer_timeout():
	is_in_dash = false
	pass # Replace with function body.


func _on_dash_cd_timer_timeout():
	can_dash = true
	pass # Replace with function body.


func _on_shoot_timer_timeout():
	can_shoot = true
	pass # Replace with function body.





func _on_sword_cd_timer_timeout():
	can_shoot = true
	pass # Replace with function body.
