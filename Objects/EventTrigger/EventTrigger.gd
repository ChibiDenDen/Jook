extends Area2D



export var in_stream : AudioStream
export var out_stream : AudioStream
var pass_bit := false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_EventTrigger_body_entered(body):
	if !body.is_in_group("Player"):
		return
	var player = body
	pass_bit = !pass_bit
	get_tree().current_scene.on_trigger(self)

