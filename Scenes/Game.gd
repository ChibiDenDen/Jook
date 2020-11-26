extends Node2D

const EventTrigger := preload("res://Objects/EventTrigger/EventTrigger.gd")

onready var tween : Tween = $Tween

var tween_time := 1.5

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func change_music(stream : AudioStream):
	$Music.stream = stream
	$Music.play()
	tween.interpolate_property($Music, "volume_db", -10, 0, tween_time, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()

func on_trigger(event_trigger : EventTrigger):
	tween.interpolate_property($Music, "volume_db", 0, -10, tween_time, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	var _ok
	if event_trigger.pass_bit:
		_ok = tween.interpolate_callback(self, tween_time, "change_music", event_trigger.in_stream)
	else:
		_ok = tween.interpolate_callback(self, tween_time, "change_music", event_trigger.out_stream)

	_ok = tween.start()
