extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var player : Node2D
var drop := false
var move_vec := Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move_vec = Vector2(100, 0)
	if drop:
		move_vec.x = 0
		move_vec.y += 100
	move_and_slide(move_vec, Vector2(0,0))
	if get_slide_count() == 0:
		drop = true
		return
	for i in range(get_slide_count()):
		var collider = get_slide_collision(i).get_collider()
		if collider.is_in_group("Crash"):
			drop = false
			move_vec.y = 0
		if collider.is_in_group("Checkpoint"):
			player.global_position = global_position - Vector2(0, 5)
			player.crashed = false
			player.visible = true
			player.sleeping = false
			queue_free()
