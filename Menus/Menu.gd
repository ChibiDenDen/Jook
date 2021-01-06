extends Control

const UI := preload("res://Objects/UI/UI.gd")

export var SettingsPath : NodePath
export var CustomizePath : NodePath
var Settings : Control
var Customize: Control
export var UiPath : NodePath
var Ui : UI
export var AboutPath : NodePath
var About : Control
export var HelpPath : NodePath
var Help : Control
var player

func _ready():
	Settings = get_node_or_null(SettingsPath)
	Customize = get_node_or_null(CustomizePath)
	Ui = get_node_or_null(UiPath)
	About = get_node_or_null(AboutPath)
	Help = get_node_or_null(HelpPath)
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
		"Play":
			player.sleeping = false
			visible = false
			Ui.playing = true
		"Settings":
			change_menu(Settings)
		"Back":
			change_menu(Ui.BackMenu)
		"Customize":
			change_menu(Customize)
		"About":
			change_menu(About)
		"Help":
			change_menu(Help)
		"Quit":
			get_tree().quit()
