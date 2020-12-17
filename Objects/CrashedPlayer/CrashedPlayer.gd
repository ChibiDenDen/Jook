extends KinematicBody2D


export var walking_speed := 250
export var falling_acc := 500
export var acc := 500

var player : Node2D
var drop := false
var move_vec := Vector2()
var slide_down := false
var time := 0.0

var brows_index := 0
var lens_index := 0
var misc_index := 3

var speedup := false

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite/Eyebrows.texture = load("res://Resources/Jook/Customize/eyebrows/SIDE " + str(brows_index) + ".png")
	$Sprite/Lens.texture = load("res://Resources/Jook/Customize/lens/SIDE " + str(lens_index) + ".png")
	$Sprite/Misc.texture = load("res://Resources/Jook/Customize/misc/side" + str(misc_index) + ".png")
	$AnimationPlayer.play("walk")
	get_tree().current_scene.get_node("UI").change_time = true

func will_drop():
	return is_on_wall() or is_on_ceiling()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
	var label := $SpaceLabel if OS.get_name() != "Android" else $TouchLabel
	if time > 2:
		if time > 4:
			label.modulate.a = lerp(label.modulate.a, 0.0, delta)
		else:
			label.modulate.a = lerp(label.modulate.a, 1.0, delta)
	if Input.is_action_pressed("action") or speedup:
		Engine.time_scale = 4
	else:
		Engine.time_scale = 1
	if time > 20:
		label = $ResetLabel if OS.get_name() != "Android" else $ResetTouchLabel
		label.modulate.a = lerp(label.modulate.a, 1.0, delta)
		if Input.is_key_pressed(KEY_R):
			player.global_position = player.get_node(player.last_checkpoint).global_position
			player.set_process(true)
			player.crashed = false
			player.visible = true
			player.sleeping = false
			Engine.time_scale = 1
			queue_free()
			return
	move_vec += Vector2.DOWN * falling_acc * delta
	if is_on_floor():
		$AnimationPlayer.play("walk")
		# Make sure we keep sliding down
		var dir = 1
		$Sprite.scale.x = abs($Sprite.scale.x)
		if slide_down:
			dir = -1
			$Sprite.scale.x = -1
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
	if is_on_wall():
		slide_down = not slide_down
	player.global_position = global_position - Vector2(0, 10)

func respawn_player(checkpoint : Node2D):
	set_process(false)
	player.global_position = global_position - Vector2(0, 10)
	player.set_process(true)
	player.crashed = false
	player.visible = true
	player.sleeping = false
	player.last_checkpoint = player.get_path_to(checkpoint)
	Engine.time_scale = 1
	queue_free()

func _on_SpeedUp_pressed():
	speedup = true

func _on_SpeedUp_released():
	speedup = false
