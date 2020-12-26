extends Node2D

const EventTrigger := preload("res://Objects/EventTrigger/EventTrigger.gd")

onready var tween : Tween = $Tween
onready var cur_stream : AudioStream = preload("res://Music/Focus on This.ogg")

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
	if cur_stream == event_trigger.pass_stream:
		return
	cur_stream = event_trigger.pass_stream
	tween.interpolate_property($Music, "volume_db", 0, -10, tween_time, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	var _ok = tween.interpolate_callback(self, tween_time, "change_music", cur_stream)
	_ok = tween.start()
