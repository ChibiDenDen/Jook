extends Node2D

var BackMenu : Control

onready var tween : Tween = $Tween

var cutscene_count := 0

func _ready():
	play_first()

func play_first():
	cutscene_count += 1
	$hud/Control/FirstPlayer.visible = true
	$hud/Control/FirstPlayer.play()
	tween.interpolate_callback(self, 10, "play_second")
	tween.start()

func play_second():
	tween.stop_all()
	cutscene_count += 1
	$hud/Control/FirstPlayer.visible = false
	$hud/Control/SecondPlayer.visible = true
	$hud/Control/SecondPlayer.play()
	tween.interpolate_callback(self, 10, "finish_cutscenes")
	tween.start()

func finish_cutscenes():
	$hud/Control/SecondPlayer.visible = false
	$hud/menus/MainMenu.visible = true
	$hud/Control/Button.visible = false

func _process(_delta):
	pass

func get_fuel():
	return $hud/Control/Fuel

func show():
	$hud/menus/MainMenu.visible = true

func is_shown():
	return $hud/menus/MainMenu.visible

func _on_Button_pressed():
	if cutscene_count == 1:
		play_second()
		return
	if cutscene_count == 2:
		finish_cutscenes()
