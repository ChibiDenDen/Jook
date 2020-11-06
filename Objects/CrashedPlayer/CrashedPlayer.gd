extends KinematicBody2D


export var walking_speed := 500
export var falling_acc := 5

var player : Node2D
var drop := false
var move_vec := Vector2()
var camera_zoom := Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func on_start():
	$Tween.interpolate_property($Camera2D, "zoom", camera_zoom, Vector2(1, 1), 1)
	$Tween.start()

func will_drop():
	return is_on_wall() or is_on_ceiling()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	move_vec.x = walking_speed
	if drop:
		move_vec.x = 0
		move_vec.y += falling_acc
	move_and_slide(move_vec, Vector2.UP)
	if get_slide_count() == 0 or will_drop():
		drop = true
	for i in range(get_slide_count()):
		var collider = get_slide_collision(i).get_collider()
		if collider.is_in_group("Crash") and !will_drop():
			drop = false
			move_vec.y = 0
		if collider.is_in_group("Checkpoint"):
			player.global_position = global_position - Vector2(0, 5)
			player.set_process(true)
			player.set_camera_zoom($Camera2D.zoom)
			player.crashed = false
			player.visible = true
			player.sleeping = false
			queue_free()
