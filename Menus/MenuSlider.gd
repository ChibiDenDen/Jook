extends HSlider

var OrigVolumes : Array
const MUTE_VALUE = -30

func _ready():
	self.connect("value_changed", self, "_on_value_changed", [])
	for i in AudioServer.get_bus_count():
		OrigVolumes.append(AudioServer.get_bus_volume_db(i))
	_on_value_changed(5.0)

func _on_value_changed(value : float):
	_volume_changed(value)

func _volume_changed(value : float):
	var index := AudioServer.get_bus_index($Label.text.trim_suffix(" Volume"))
	var db_step = (OrigVolumes[index] + MUTE_VALUE) / max_value
	if value == 0:
		AudioServer.set_bus_mute(index, true)
		return
	AudioServer.set_bus_mute(index, false)
	AudioServer.set_bus_volume_db(index, MUTE_VALUE - (value * db_step))
