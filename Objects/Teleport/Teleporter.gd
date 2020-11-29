extends Sprite

var player_in := false
var player : Node2D
export var connection_path : NodePath
var connection : Node2D
var unlocked := true

# Called when the node enters the scene tree for the first time.
func _ready():
	connection = get_node(connection_path)
	$AnimationPlayer.play("closed")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !connection.unlocked:
		return
	$Label.modulate.a = lerp($Label.modulate.a, 1.0 if player_in else 0.0, 0.2)
	if player_in and Input.is_action_just_pressed("action") and !player.crashed:
		$AnimationPlayer.play("enter")
		player.teleport(connection.global_position)
		player_in = false

func _on_Area2D_body_entered(body):
	if !body.is_in_group("Player"):
		return
	player = body
	unlocked = true
	player_in = true


func _on_Area2D_body_exited(_body):
	player_in = false
