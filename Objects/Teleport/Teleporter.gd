extends Sprite

var player_in := false
var player : Node2D
export var connection_path : NodePath
var connection : Node2D
var unlocked := false

# Called when the node enters the scene tree for the first time.
func _ready():
	connection = get_node(connection_path)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !connection.unlocked:
		return
	$Label.modulate.a = lerp($Label.modulate.a, 1.0 if player_in else 0.0, 0.2)
	if player_in and Input.is_action_just_pressed("action"):
		player.move_to(connection.global_position)

func _on_Area2D_body_entered(body):
	player = body
	unlocked = true
	player_in = true


func _on_Area2D_body_exited(body):
	player_in = false
