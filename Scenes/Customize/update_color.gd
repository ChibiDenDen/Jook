extends Sprite



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

export(Gradient) var colors_map:Gradient


func _on_topHSlider_value_changed(value):
	$top.self_modulate = colors_map.interpolate(value)

func _on_midHSlider_value_changed(value):
	$mid.self_modulate = colors_map.interpolate(value)
	get_tree().current_scene.get_node("Player/PlayerFly").change_color($mid.self_modulate)

func _on_lowHSlider_value_changed(value):
	$low.self_modulate = colors_map.interpolate(value)
