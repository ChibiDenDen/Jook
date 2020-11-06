extends Control

var target_position = Vector2.ZERO
var noise := OpenSimplexNoise.new()
var time := 0.0

func _process(delta):
	time += delta
	target_position = get_viewport().get_mouse_position()
	var target_rotation = rad2deg((target_position - rect_position).angle() + PI/2)
	var max_rotation = wrapf(wrapf(rect_rotation, 0, 360) - wrapf(target_rotation, 0, 360), 0, 360)
	if max_rotation > 180.0:
		max_rotation -= 360.0
	if Input.get_mouse_button_mask() == BUTTON_LEFT:
		print_debug(target_position)
		print_debug(rect_position)
		print_debug(target_rotation)
	get_parent().find_node("dbg").text = str(target_position) + ":" + str(rect_rotation) + ">" + str(target_rotation)+ ">" + str(max_rotation)
	rect_rotation = rect_rotation - min(abs(max_rotation), 600.0 * delta) * sign(max_rotation)
	var lateral_movement = \
		delta*400*Vector2.RIGHT.rotated(deg2rad(rect_rotation)) * noise.get_noise_1d(time*200)
	rect_position += lateral_movement + Vector2.UP.rotated(deg2rad(rect_rotation)) * delta * 400
