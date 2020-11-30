extends Control

const UI := preload("res://Objects/UI/UI.gd")

export var SettingsPath : NodePath
export var CustomizePath : NodePath
var Settings : Control
var Customize: Control
export var UiPath : NodePath
var Ui : UI
var player

func _ready():
	Settings = get_node_or_null(SettingsPath)
	Customize = get_node_or_null(CustomizePath)
	Ui = get_node_or_null(UiPath)
	player = Ui.get_parent().get_node("Player/PlayerFly")
	for item in $Menu.get_children():
		if item is Button:
			item.connect("pressed", self, "_on_pressed", [item.get_node("Label").text])

func change_menu(menu : Control):
	Ui.BackMenu = self
	menu.visible = true
	visible = false

func _on_pressed(text):
	match text:
		"Start Game":
			player.sleeping = false
			visible = false
		"Settings":
			change_menu(Settings)
		"Back":
			change_menu(Ui.BackMenu)
		"Customize":
			change_menu(Customize)
		"Quit":
			get_tree().quit()
