extends Node2D

const Player := preload("res://Objects/Player/Player.gd")

var BackMenu : Control

export var PlayerPath : NodePath
var player : Player

func _ready():
	$hud/menus/MainMenu.visible = true
	player = get_node_or_null(PlayerPath)

func quit():
	get_tree().quit()

func _process(_delta):
	pass

func get_fuel():
	return $hud/Control/Fuel

func show():
	$hud/menus/MainMenu.visible = true

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
