extends RigidBody2D


const CrashedPlayerScene := preload("res://Objects/CrashedPlayer/CrashedPlayer.tscn")
const CrashedPlayer := preload("res://Objects/CrashedPlayer/CrashedPlayer.gd")
const BoostFartsScene := preload("res://Objects/Particles/BoostFarts.tscn")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var thrust = Vector2.UP * 500
export var boost_thrust = 25
export var torque = 5000

var crashed_player : CrashedPlayer = null
var crashed := false

export var camera_zoom_scale := 100
export var camera_zoom_speed := 1
export var min_camera_zoom := 1
export var max_camera_zoom := 3
var last_camera_zoom : Vector2
var target_camera_zoom : float
var last_applied_force : Vector2
var last_linear_velocity : Vector2
const survivable_hit_force := 100.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_camera_zoom(zoom : Vector2):
	$Camera2D.zoom = zoom

func _process(delta):
	var zoom_step = camera_zoom_speed * delta
	if ($Camera2D.zoom.x > target_camera_zoom):
		zoom_step *= -1

	$Camera2D.zoom.x = min(max(min_camera_zoom, $Camera2D.zoom.x + zoom_step), max_camera_zoom)
	$Camera2D.zoom.y = min(max(min_camera_zoom, $Camera2D.zoom.y + zoom_step), max_camera_zoom)
	last_linear_velocity = linear_velocity

func _integrate_forces(state):
	if crashed:
		return
	if Input.is_action_pressed("ui_up"):
		var cur_thrust = thrust
		if last_applied_force == Vector2() and $BoostTimer.is_stopped():
			$BoostTimer.start()
			cur_thrust *= boost_thrust
			var farts = BoostFartsScene.instance()
			add_child(farts)
			$Tween.interpolate_callback(farts, 1, "queue_free")
			$Tween.start()
		applied_force = cur_thrust.rotated(rotation)
		$Particles2D.emitting = true
	else:
		applied_force = Vector2()
		$Particles2D.emitting = false
	last_applied_force = applied_force
	var rotation_dir = 0
	if Input.is_action_pressed("ui_right"):
		rotation_dir += 1
	if Input.is_action_pressed("ui_left"):
		rotation_dir -= 1
	applied_torque = rotation_dir * torque
	target_camera_zoom = linear_velocity.length() / camera_zoom_scale
	last_camera_zoom = $Camera2D.zoom

func _on_Player_body_entered(body):
	print_debug((last_linear_velocity - linear_velocity).length())
	if body.is_in_group("Crash") and crashed_player == null and (last_linear_velocity - linear_velocity).length() > survivable_hit_force:
		crashed_player = CrashedPlayerScene.instance()
		crashed_player.player = self
		crashed_player.global_position = global_position
		crashed_player.camera_zoom = last_camera_zoom
		get_parent().call_deferred("add_child", crashed_player)
		crashed_player.call_deferred("on_start")
		crashed = true
		applied_force = Vector2(0, 0)
		applied_torque = 0
		rotation = 0
		set_process(false)
		sleeping = true
		visible = false
