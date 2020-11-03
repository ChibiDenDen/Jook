extends Area2D

export var rot_speed = 2.6
export var thrust = 500
export var max_vel = 400
export var friction = 0.65

var screen_size := Vector2()
var pos := Vector2()
var vel := Vector2()
var acc := Vector2()
var rot := 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	pos = screen_size / 2
	position = pos

func handle_input(delta):
	if Input.is_action_pressed("player_left"):
		rot -= rot_speed * delta
	if Input.is_action_pressed("player_right"):
		rot += rot_speed * delta
	if Input.is_action_pressed("player_thrust"):
		acc = Vector2(thrust, 0).rotated(rot)
	else:
		acc = Vector2(0, 0)

func move(delta):
	acc += vel * (-friction)
	vel += acc * delta
	pos += vel * delta
	position = pos
	rotation = (rot + PI/2)

func _process(delta):
	handle_input(delta)
	move(delta)
