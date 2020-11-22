extends KinematicBody2D


export var walking_speed := 250
export var falling_acc := 500
export var acc := 500

var player : Node2D
var drop := false
var move_vec := Vector2()
var slide_down := false

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("walk")

func will_drop():
	return is_on_wall() or is_on_ceiling()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("action"):
		Engine.time_scale = 4
	else:
		Engine.time_scale = 1
	move_vec += Vector2.DOWN * falling_acc * delta
	if is_on_floor():
		$AnimationPlayer.play("walk")
		# Make sure we keep sliding down
		var dir = 1
		if slide_down:
			dir = -1
		move_vec += Vector2.RIGHT * acc * delta * dir
		if move_vec.length() > walking_speed:
			move_vec = move_vec.normalized() * walking_speed
	else:
		# After falling backwards, keep going to the right
		if slide_down:
			move_vec.x = 0
		slide_down = false
		$AnimationPlayer.stop()
	move_vec = move_and_slide_with_snap(move_vec, Vector2(0, 32), Vector2.UP)
	if move_vec.x < -3:
		slide_down = true
	if get_slide_count() == 0 or will_drop():
		drop = true
	for i in range(get_slide_count()):
		var collider = get_slide_collision(i).get_collider()
		if collider.is_in_group("Checkpoint"):
			player.global_position = global_position - Vector2(0, 5)
			player.set_process(true)
			player.crashed = false
			player.visible = true
			player.sleeping = false
			Engine.time_scale = 1
			queue_free()
	if is_on_wall():
		slide_down = not slide_down
	player.global_position = global_position - Vector2(0, 5)
