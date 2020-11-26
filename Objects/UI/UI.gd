extends Node2D

var BackMenu : Control

func _ready():
	$hud/menus/MainMenu.visible = true

func _process(_delta):
	pass

func get_fuel():
	return $hud/Control/Fuel

func show():
	$hud/menus/MainMenu.visible = true

func is_shown():
	return $hud/menus/MainMenu.visible
