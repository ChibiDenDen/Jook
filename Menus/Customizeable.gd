extends Node2D

enum CUSTOM_TYPE {
	BROWS,
	LENS
	MISC
}

export(CUSTOM_TYPE) var type = CUSTOM_TYPE.BROWS

var cur_index := 0
var player

func type_enum_str():
	if type == CUSTOM_TYPE.BROWS:
		return "BROWS"
	elif type == CUSTOM_TYPE.LENS:
		return "LENS"
	elif type == CUSTOM_TYPE.MISC:
		return "MISC"

func update_player():
	if type == CUSTOM_TYPE.BROWS:
		player.brows_index = cur_index
	elif type == CUSTOM_TYPE.LENS:
		player.lens_index = cur_index
	elif type == CUSTOM_TYPE.MISC:
		player.misc_index = cur_index

func get_anim_name():
	return type_enum_str() + str(cur_index)

func update_anim():
	$AnimationPlayer.play(get_anim_name())

# Called when the node enters the scene tree for the first time.
func _ready():
	update_anim()
	player = get_tree().current_scene.get_node("Player/PlayerFly")

func _on_Next_pressed():
	cur_index += 1
	if !$AnimationPlayer.get_animation(get_anim_name()):
		cur_index -= 1
	update_anim()
	update_player()

func _on_Prev_pressed():
	cur_index -= 1
	if !$AnimationPlayer.get_animation(get_anim_name()):
		cur_index += 1
	update_anim()
	update_player()
