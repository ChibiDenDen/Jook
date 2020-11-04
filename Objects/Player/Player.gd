extends RigidBody2D


const CrashedPlayerScene := preload("res://Objects/CrashedPlayer/CrashedPlayer.tscn")
const CrashedPlayer := preload("res://Objects/CrashedPlayer/CrashedPlayer.gd")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var thrust = Vector2.UP * 500
export var torque = 5000

var crashed_player : CrashedPlayer = null
var crashed := false

export var camera_zoom_scale := 200
export var min_camera_zoom := 1
export var max_camera_zoom := 3
var last_camera_zoom : Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _integrate_forces(state):
	if crashed:
		return
	if Input.is_action_pressed("ui_up"):
		applied_force = thrust.rotated(rotation)
	else:
		applied_force = Vector2()
	var rotation_dir = 0
	if Input.is_action_pressed("ui_right"):
		rotation_dir += 1
	if Input.is_action_pressed("ui_left"):
		rotation_dir -= 1
	applied_torque = rotation_dir * torque
	var normalized_velocity = linear_velocity.length() / camera_zoom_scale
	last_camera_zoom = $Camera2D.zoom
	$Camera2D.zoom.x = min(max(min_camera_zoom, normalized_velocity), max_camera_zoom)
	$Camera2D.zoom.y = min(max(min_camera_zoom, normalized_velocity), max_camera_zoom)

func _on_Player_body_entered(body):
	if body.is_in_group("Crash") and crashed_player == null:
		crashed_player = CrashedPlayerScene.instance()
		crashed_player.player = self
		crashed_player.global_position = global_position
		crashed_player.camera_zoom = last_camera_zoom
		get_parent().add_child(crashed_player)
		crashed_player.on_start()
		crashed = true
		applied_force = Vector2(0, 0)
		applied_torque = 0
		rotation = 0
		sleeping = true
		visible = false
