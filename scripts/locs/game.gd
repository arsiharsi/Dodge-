extends Node2D

var spawner_scene = load("res://tscns/mobs/enemies/spawner.tscn")
var dificulty = 1
var consistency_cd = 5.0
var camera_shake_force = 0
var ru_spr = load("res://sprites/menu/ru.png")
var en_spr = load("res://sprites/menu/en.png")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func start_camera_shake(force, time):
	camera_shake_force = force
	$timers/camera_shake_timer.start(time)

func camera_shake(force):
	if force == 0:
		$cam.position = Vector2(512,300)
	else:
		$cam.position = Vector2(512,300)+Vector2(rand_range(-force,force),rand_range(-force,force))
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	if !GlobalSceneScript.game_ready:
		Bridge.platform.send_message("game_ready")
		GlobalSceneScript.game_ready = true
	$fg/menu/cosmetics/body.hide()
	GlobalSceneScript.load_s()
	GlobalSceneScript.score = 0
	TranslationServer.set_locale(Bridge.platform.language)
	randomize()
	GlobalSceneScript.main_node = $action
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("SAVE_MANUALLY"):
		GlobalSceneScript.save()
	if Input.is_action_just_pressed("LOAD_MANUALLY"):
		GlobalSceneScript.load_s()
	$sounds/music.stream_paused = not $action/player.is_alive
	$fg/menu/weapon_shop/choose_blaster/name.text = tr("CHANGE_WEAPON")+tr("BLASTER")
	$fg/menu/weapon_shop/choose_blaster.visible = GlobalSceneScript.current_weapon != "blaster"
	if GlobalSceneScript.sword_unlocked != 1:
		$fg/menu/weapon_shop/buy_choose_sword/name.text = "BUY_SWORD"
	else:
		$fg/menu/weapon_shop/buy_choose_sword/name.text = tr("CHANGE_WEAPON")+tr("SWORD")
		$fg/menu/weapon_shop/buy_choose_sword.visible = GlobalSceneScript.current_weapon != "sword"
	$fg/menu/money.text = tr("MONEY")+str(GlobalSceneScript.money)
	$fg/menu/highscore_menu.text = tr("MAX_SCORE")+str(GlobalSceneScript.highscore)
	$fg/game/score.text = tr("SCORE")+str(GlobalSceneScript.score)
	$timers/enemy_timer.wait_time = consistency_cd
	if TranslationServer.get_locale() == "en":
		$fg/menu/change_language.normal = en_spr
	else:
		$fg/menu/change_language.normal = ru_spr
	camera_shake(camera_shake_force)
	pass


func _on_slider_timer_timeout():
	var fut_pos = Vector2(rand_range(15,1009),rand_range(15,585))
	var spawner = spawner_scene.instance()
	spawner.global_position = fut_pos
	spawner.max_spawn = dificulty
	$action.add_child(spawner)
	pass # Replace with function body.


func _on_camera_shake_timer_timeout():
	camera_shake_force = 0
	pass # Replace with function body.


func _on_change_language_pressed():
	$sounds/accept.play()
	if TranslationServer.get_locale() == "en":
		TranslationServer.set_locale("ru")
	else:
		TranslationServer.set_locale("en")
	pass # Replace with function body.


func _on_start_game_pressed():
	if !$animations/start_end_anim.is_playing():
		$animations/start_end_anim.play("start")
		$sounds/accept.play()
	pass # Replace with function body.


func start_spawner():
	$timers/enemy_timer.start()
	$timers/add_difficulty_timer.start()
	pass


func _on_add_difficulty_timer_timeout():
	if consistency_cd <= 1.0 and dificulty < 3:
		consistency_cd = 5
		dificulty += 1
	elif consistency_cd >= 1.0:
		consistency_cd -= 0.1
	if dificulty == 3:
		consistency_cd = clamp(consistency_cd,1.75,5)
	pass # Replace with function body.



func player_death():
	if !$fg/death_screen/death.is_playing() and !$action/player.invinsivle:
		if GlobalSceneScript.score > GlobalSceneScript.highscore:
			$fg/death_screen/highscore.show()
		$fg/death_screen/death.play("death")
		$action/player.kill()
	pass

func player_revive():
	if !$fg/death_screen/death.is_playing():
		$fg/death_screen/death.play("revive")
		$action/player.revive()

func restart():
	$ad_watcher_sound_muter.show_inter()
	if GlobalSceneScript.score > GlobalSceneScript.highscore:
		GlobalSceneScript.highscore = GlobalSceneScript.score
	GlobalSceneScript.money += GlobalSceneScript.score/2
	GlobalSceneScript.save()
	if !$fg/death_screen/death.is_playing():
		$fg/death_screen/death.play("restart")


func reload():
	get_tree().change_scene_to(load("res://tscns/locs/game.tscn"))


func _on_restart_pressed():
	restart()
	pass # Replace with function body.


func _on_revive_pressed():
	$ad_watcher_sound_muter.show_rewarded()
	pass # Replace with function body.

func kill_em_all():
	GlobalSceneScript.kill_em_all = true

func revive_em_all():
	GlobalSceneScript.kill_em_all = false


func _on_buy_choose_sword_pressed():
	if GlobalSceneScript.sword_unlocked == 0:
		if GlobalSceneScript.money >= 1000:
			GlobalSceneScript.money -= 1000
			GlobalSceneScript.sword_unlocked = 1
			GlobalSceneScript.save()
			$sounds/accept.play()
		else:
			$sounds/deny.play()
	else:
		GlobalSceneScript.current_weapon = "sword"
		GlobalSceneScript.save()
		$sounds/accept.play()
	pass # Replace with function body.


func _on_choose_blaster_pressed():
	$sounds/accept.play()
	GlobalSceneScript.current_weapon = "blaster"
	pass # Replace with function body.


func _on_open_pressed():
	if !$fg/menu/cosmetics/body.visible:
		$sounds/accept.play()
		$fg/menu/cosmetics/open/name.text = "COSMETICS_CLOSE"
	else:
		$sounds/deny.play()
		$fg/menu/cosmetics/open/name.text = "COSMETICS"
	$fg/menu/cosmetics/body.visible = !$fg/menu/cosmetics/body.visible
	$fg/menu/weapon_shop.visible = !$fg/menu/cosmetics/body.visible
	$fg/menu/start_game.visible = !$fg/menu/cosmetics/body.visible
	$fg/menu/highscore_menu.visible = !$fg/menu/cosmetics/body.visible
	$fg/menu/sounds_and_music.visible  = !$fg/menu/cosmetics/body.visible
	pass # Replace with function body.


func _on_sfx_pressed():
	if AudioServer.get_bus_volume_db(1) == 0:
		AudioServer.set_bus_volume_db(1, -100)
	else:
		AudioServer.set_bus_volume_db(1, 0)
	$fg/menu/sounds_and_music/sfx/spr.visible = AudioServer.get_bus_volume_db(1) != 0
	pass # Replace with function body.


func _on_music_pressed():
	if AudioServer.get_bus_volume_db(2) == 0:
		AudioServer.set_bus_volume_db(2, -100)
	else:
		AudioServer.set_bus_volume_db(2, 0)
	$fg/menu/sounds_and_music/music/spr.visible = AudioServer.get_bus_volume_db(2) != 0
	pass # Replace with function body.
