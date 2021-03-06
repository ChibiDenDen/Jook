extends RigidBody2D


const CrashedPlayerScene := preload("res://Objects/CrashedPlayer/CrashedPlayer.tscn")
const CrashedPlayer := preload("res://Objects/CrashedPlayer/CrashedPlayer.gd")
const BoostFartsScene := preload("res://Objects/Particles/BoostFarts.tscn")

export var DifficultyPath : NodePath
var DifficultySlider : Node

onready var camera := get_node("../Anchor/Camera2D")

export var thrust = Vector2.UP * 300
export var boost_thrust = 25
export var torque = 5000
export(NodePath) var last_checkpoint
export var orig_gravity_scale := 1.0

var crashed := false

export var camera_zoom_scale := 100
export var camera_zoom_speed := 1
export var min_camera_zoom := 0.7
export var max_camera_zoom := 4.0/3.0
export var zoom_step_thresh := 1.5
var last_camera_zoom : Vector2
var target_camera_zoom : float = 1.0
var last_applied_force : Vector2
var last_linear_velocity : Vector2
export var survivable_hit_force := 160.0

export var use_fuel := true
export var max_fuel := 50.0
export var fuel_empty_time := 1.0
export var fuel_fill_time := 0.5
var filling_fuel := false
var cur_fuel := 50.0
var shield_timer := 0.0

var fuel_progress : ProgressBar
const RED_COLOR := Color(0.67, 0.14, 0.14)
const BLUE_COLOR := Color(0.14, 0.14, 0.67)

var active_input := true
var teleporting := false

var brows_index := 0
var lens_index := 0
var misc_index := 3

var move_up := false
var move_left := false
var move_right := false

# Called when the node enters the scene tree for the first time.
func _ready():
	var ui = get_tree().current_scene.get_node("UI")
	gravity_scale = 0
	fuel_progress = ui.get_fuel()
	change_fuel_use()
	stop_fly()
	# Phone Specific
	if OS.get_name() in ["Android", "iOS"]:
		max_camera_zoom = 1.0
	DifficultySlider = ui.get_node_or_null("hud/menus/SettingsMenu/Menu/Difficulty")
	if DifficultySlider != null:
		DifficultySlider.player = self

func change_fuel_use():
	if use_fuel:
		fuel_progress.max_value = max_fuel
	fuel_progress.visible = use_fuel

func choose_difficulty(difficulty := 0):
	Global.difficulty = difficulty
	use_fuel = false
	change_fuel_use()
	survivable_hit_force = 160.0
	if difficulty >= 1:
		use_fuel = true
		change_fuel_use()
	if difficulty >= 2:
		survivable_hit_force = 80.0

func teleport(target_pos : Vector2):
	gravity_scale = 0
	sleeping = true
	reset(false)
	teleporting = true
	$AnimationPlayer.play("teleport")
	$Tween.interpolate_callback(self, 1, "move_to", target_pos)
	$Tween.start()

func change_color(in_color):
	$Wings.self_modulate = in_color

func stop_fly():
	sleeping = true

func reset(rotate_p := true):
	$Particles2D.restart()
	cur_fuel = max_fuel
	fuel_progress.value = max_fuel
	gravity_scale = 0
	applied_force = Vector2(0, 0)
	applied_torque = 0
	if rotate_p:
		rotation = 0

func move_to(pos : Vector2):
	global_position = pos
	sleeping = false
	teleporting = false

func set_camera_zoom(zoom : Vector2):
	camera.zoom = zoom

func _process(delta):
	$Misc.texture = load("res://Resources/Jook/Customize/misc/back" + str(misc_index) + ".png")
	active_input = !get_tree().current_scene.get_node("UI").is_shown()
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().current_scene.get_node("UI").show()
		stop_fly()
	if crashed:
		camera.zoom = lerp(camera.zoom, Vector2.ONE, 0.25)
		return

	if shield_timer > 0:
		shield_timer -= delta
		modulate = Color.blue
	else:
		modulate = Color.white
	var zoom_step = camera_zoom_speed * delta
	if (camera.zoom.x > target_camera_zoom):
		zoom_step *= -1

	if (abs(abs(target_camera_zoom) - abs(camera.zoom.x)) >= zoom_step_thresh):
		var zoom_target = clamp(camera.zoom.x + zoom_step, min_camera_zoom, max_camera_zoom) * Vector2.ONE
		camera.zoom = lerp(camera.zoom, Vector2.ONE * zoom_target, 0.25)
		last_linear_velocity = linear_velocity

	fuel_progress.value = cur_fuel
	if use_fuel and $BoostTimer.is_stopped() and !filling_fuel:
		fuel_progress.get_stylebox("fg").set_bg_color(BLUE_COLOR)

func _integrate_forces(state):
	if crashed:
		return

	if active_input and (move_up or Input.is_action_pressed("ui_up")) and cur_fuel > 0 and !filling_fuel:
		$AnimationPlayer.play("fly")
		gravity_scale = orig_gravity_scale
		if use_fuel:
			cur_fuel = max(0, cur_fuel - (max_fuel * state.get_step()) / fuel_empty_time)
		var cur_thrust = thrust
		if last_applied_force == Vector2() and use_fuel and $BoostTimer.is_stopped():
			if use_fuel:
				cur_fuel = max_fuel
				fuel_progress.get_stylebox("fg").set_bg_color(RED_COLOR)
			$BoostTimer.start()
			cur_thrust *= boost_thrust
			var farts = BoostFartsScene.instance()
			add_child(farts)
			farts.emitting = true
			$Tween.interpolate_callback(farts, 1, "queue_free")
			$Tween.start()
		applied_force = cur_thrust.rotated(rotation)
		$Particles2D.emitting = true
	else:
		if !teleporting:
			$AnimationPlayer.stop()
		if use_fuel:
			cur_fuel = min(max_fuel, cur_fuel + (max_fuel * state.get_step()) / fuel_fill_time)
			filling_fuel = cur_fuel != max_fuel
		applied_force = Vector2()
		$Particles2D.emitting = false
	last_applied_force = applied_force
	var rotation_dir = 0
	if active_input and (move_right or Input.is_action_pressed("ui_right")):
		rotation_dir += 1
	if active_input and (move_left or Input.is_action_pressed("ui_left")):
		rotation_dir -= 1
	applied_torque = rotation_dir * torque
	target_camera_zoom = linear_velocity.length() / camera_zoom_scale
	last_camera_zoom = camera.zoom

func pickup_fuel():
	cur_fuel = 50.0

func pickup_shield():
	shield_timer = 5.0

func get_hit():
	var crashed_player = CrashedPlayerScene.instance()
	crashed_player.brows_index = brows_index
	crashed_player.lens_index = lens_index
	crashed_player.misc_index = misc_index
	crashed_player.modulate = get_parent().modulate
	crashed_player.player = self
	get_tree().current_scene.call_deferred("add_child", crashed_player)
	# Place them to be in front of bg and behind water
	get_tree().current_scene.call_deferred("move_child", crashed_player, 1)
	crashed_player.global_position = global_position
	crashed_player.get_node("Sprite/Wings").self_modulate = $Wings.self_modulate
	crashed = true
	visible = false
	reset()
	stop_fly()

func _on_Player_body_entered(body: Node2D):
	if crashed:
		return

	if shield_timer > 0:
		return

	var force := (last_linear_velocity - linear_velocity).length()

	if body.is_in_group("Breakable"):
		if force > body.break_force:
			body.will_break()
		return

	if force > survivable_hit_force:
		get_hit()

func _on_moon_body_entered(body):
	if !body.is_in_group("Player"):
		return
	get_tree().change_scene("res://Video3.tscn")

# Handle touch controls
func update_moves(is_left := false, value := false):
	if is_left:
		move_left = value
	else:
		move_right = value
	move_up = move_left and move_right
