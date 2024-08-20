extends Node

var game_ready = false
var player_node
var kill_em_all = false
var score = 0
var money = 0
var highscore = 0
var unlocked_cosm = ["base"]
var sword_unlocked = 0
var current_cosm = "base"
var current_weapon = "blaster"
var player_position = Vector2.ZERO
var main_node
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
func save():
	print("saving cosm...")
	Bridge.storage.set(["money", "highscore", "sword_unlocked", "current_weapon", "current_cosm", "unlocked_cosm"], 
	[str(money), str(highscore),str(sword_unlocked) ,current_weapon, current_cosm, marchalize_cosmetis(unlocked_cosm)], funcref(self, "_on_storage_set_completed"))
#	var marchalized =  marchalize_cosmetis(unlocked_cosm)
#	Bridge.storage.set("unlocked_cosm", str(marchalized), funcref(self, "_on_storage_set_completed"))
	pass

func load_s():
	Bridge.storage.get(["money", "highscore", "sword_unlocked", "current_weapon", "current_cosm",
	 "unlocked_cosm"], funcref(self, "_on_storage_get_completed"))
	pass

func _on_storage_set_completed(success):
	print("save: "+str(success))

func _on_storage_get_completed(success, data):
	if success:
		if data[0] != null:
			money = int(data[0])
			print("money: ", data[0])
		else:
			# Данных по ключу money нет
			print("money is null")
		if data[1] != null:
			highscore = int(data[1])
			print("highscore: ", data[1])
		else:
			# Данных по ключу highscore нет
			print("highscore is null")
		if data[2] != null:
			sword_unlocked = int(data[2])
			if data[2] == "True":
				sword_unlocked = 0
			print("sword_unlocked: ", data[2])
		else:
			# Данных по ключу sword_unlocked нет
			print("sword_unlocked is null")
		if data[3] != null:
			current_weapon = data[3]
			print("current_weapon: ", data[3])
		else:
			# Данных по ключу current_weapon нет
			print("current_weapon is null")
		if data[4] != null:
			current_cosm = data[4]
			print("current_cosm: ", data[4])
		else:
			# Данных по ключу current_cosm нет
			print("current_cosm is null")
		if data[5] != null:
			unlocked_cosm = demarchalize_cosmetisc(data[5])
			print("unlocked_cosm: ", data[5])
		else:
			# Данных по ключу unlocked_cosm нет
			unlocked_cosm = ["base"]
			print("unlocked_cosm is null")


func camera_shake(force, time):
	if main_node.get_parent().has_method("start_camera_shake"):
		main_node.get_parent().start_camera_shake(force, time)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func marchalize_cosmetis(cosmetics:Array):
	if cosmetics != null:
		if cosmetics.size() >= 1:
			var new_string = ""
			for i in range(0, cosmetics.size()-1):
				new_string += cosmetics[i]+"1"
			new_string += cosmetics[cosmetics.size()-1]
			return new_string
	return ""


func demarchalize_cosmetisc(cosmetics:String):
	if cosmetics != null:
		if cosmetics.length() >= 1:
			var splitted = cosmetics.split("1",false)
			return splitted
	return []
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
