extends HSlider

const Player := preload("res://Objects/Player/Player.gd")

var OrigVolumes : Array
const MUTE_VALUE = -30
export var volume := true
var player : Player
var prev_value := 0

var HelpInc := ["", "Add limited fuel\nand occasional boost", "Softer shell"]
var HelpDec := ["", "Remove fuel and boost", "Harder shell"]
func _ready():
	self.connect("value_changed", self, "_on_value_changed", [])
	if !volume:
		$Help.visible = false
		return
	for i in AudioServer.get_bus_count():
		OrigVolumes.append(AudioServer.get_bus_volume_db(i))
	_on_value_changed(5.0)


func display_help(value := 0):
	$Help.modulate.a = 1
	$Help.text = HelpInc[value] if prev_value < value else HelpDec[prev_value]
	$Help.visible = true
	prev_value = value
	$Tween.interpolate_property($Help, "modulate", $Help.modulate, Color(1,1,1,0), 2.0)
	$Tween.interpolate_property($Help, "visible", true, false, 2.0)
	$Tween.start()

func _on_value_changed(value : float):
	if volume:
		_volume_changed(value)
		return
	if player != null:
		display_help(int(value))
		player.choose_difficulty(int(value))

func _volume_changed(value : float):
	var index := AudioServer.get_bus_index($Label.text.trim_suffix(" Volume"))
	var db_step = (OrigVolumes[index] + MUTE_VALUE) / max_value
	if value == 0:
		AudioServer.set_bus_mute(index, true)
		return
	AudioServer.set_bus_mute(index, false)
	AudioServer.set_bus_volume_db(index, MUTE_VALUE - (value * db_step))
