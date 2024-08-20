extends Node

export var is_real = false
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
func show_rewarded():
	Bridge.advertisement.show_rewarded()

func show_inter():
	Bridge.advertisement.show_interstitial(true) 
# Called when the node enters the scene tree for the first time.
func _ready():
	Bridge.game.connect("visibility_state_changed", self, "_on_visibility_state_changed")
	Bridge.advertisement.connect("interstitial_state_changed", self, "_on_interstitial_state_changed")
	Bridge.advertisement.connect("rewarded_state_changed", self, "_on_rewarded_state_changed")
	pass # Replace with function body.

func _on_visibility_state_changed(state):
	#visible, hidden
	AudioServer.set_bus_mute(0, state == "hidden")


func _on_rewarded_state_changed(state):
	print(state)
	if state == "opened":
		get_tree().paused = true
	elif state == "closed" or state == "failed":
		get_tree().paused = false
	elif state == "rewarded" and !is_real:
		print("revive")
		GlobalSceneScript.main_node.get_parent().player_revive()


func _on_interstitial_state_changed(state):
	if state == "opened":
		get_tree().paused = true
	else:
		get_tree().paused = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
