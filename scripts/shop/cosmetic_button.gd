extends TouchScreenButton

export(Texture) var skin
export(int) var cost
export(String) var skin_name

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$spr.texture = skin
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not skin_name in GlobalSceneScript.unlocked_cosm:
		$cost.text = str(cost)
	else:
		if GlobalSceneScript.current_cosm != skin_name:
			$cost.text = tr("BOUGHT")
		else:
			$cost.text = tr("CHOSEN")
			if GlobalSceneScript.player_node:
				GlobalSceneScript.player_node.get_node("spr").texture = skin
	pass


func _on_cosmetic_button_pressed():
	if GlobalSceneScript.money >= cost and not skin_name in GlobalSceneScript.unlocked_cosm:
		GlobalSceneScript.money -= cost
		var new_val = GlobalSceneScript.marchalize_cosmetis(GlobalSceneScript.unlocked_cosm)
		new_val += "1"+skin_name
		GlobalSceneScript.unlocked_cosm = GlobalSceneScript.demarchalize_cosmetisc(new_val)
		print("new_val: "+new_val)
		print(GlobalSceneScript.unlocked_cosm)
		GlobalSceneScript.save()
		$accept.play()
	elif skin_name in GlobalSceneScript.unlocked_cosm:
		GlobalSceneScript.current_cosm = skin_name
		print(GlobalSceneScript.current_cosm)
		print(GlobalSceneScript.unlocked_cosm)
		GlobalSceneScript.save()
		$accept.play()
	else:
		$deny.play()
	pass # Replace with function body.
