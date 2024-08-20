extends CPUParticles2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var initiated = false

# Called when the node enters the scene tree for the first time.
func _ready():
	emitting = true
	initiated = true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if emitting == false and initiated:
		queue_free()
		print(name+" queue_free")
	pass
