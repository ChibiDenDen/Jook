extends Node2D

const Player := preload("res://Objects/Player/Player.gd")

var BackMenu : Control

export var PlayerPath : NodePath
var player : Player

var playing := false
const TIME_FORMAT = "Time: {time}"

func _ready():
	$hud/menus/MainMenu.visible = true
	player = get_node_or_null(PlayerPath)
	if !(OS.get_name() in ["Android", "iOS"]):
		$hud/Control/MoveLeft.visible = false
		$hud/Control/MoveRight.visible = false
		$hud/Control/Esc.visible = false

func _process(delta):
	if playing:
		Global.time_played += delta
		$hud/Control/Time.text = TIME_FORMAT.format({"time": stepify(Global.time_played, 0.1)})

func quit():
	get_tree().quit()

func get_fuel():
	return $hud/Control/Fuel

func show():
	$hud/menus/MainMenu.visible = true
	playing = false

func is_shown():
	return $hud/menus/MainMenu.visible

func _on_MoveLeft_button_down():
	if player == null:
		return
	player.update_moves(true, true)


func _on_MoveLeft_button_up():
	if player == null:
		return
	player.update_moves(true, false)

func _on_MoveRight_button_down():
	if player == null:
		return
	player.update_moves(false, true)


func _on_MoveRight_button_up():
	if player == null:
		return
	player.update_moves(false, false)


func _on_MoveRight_pressed():
	if player == null:
		return
	player.update_moves(false, true)


func _on_MoveRight_released():
	if player == null:
		return
	player.update_moves(false, false)


func _on_MoveLeft_pressed():
	if player == null:
		return
	player.update_moves(true, true)


func _on_MoveLeft_released():
	if player == null:
		return
	player.update_moves(true, false)


func _on_Esc_pressed():
	player.stop_fly()
	show()
