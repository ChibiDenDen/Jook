extends KinematicBody2D

export var Dir := Vector2(0,0)
export var speed := 250

var move_vec := Vector2(0,0)

var flipx_timeout := 0.0
var flipy_timeout := 0.0
var move_revx := false
var move_revy := false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move_vec = Dir
	flipx_timeout = max(flipx_timeout -delta, 0.0)
	flipx_timeout = max(flipy_timeout -delta, 0.0)
	var dirx = 1
	$Sprite.scale.x = abs($Sprite.scale.x)
	if move_revx:
		dirx = -1
		$Sprite.scale.x = -1
	var diry = 1
	$Sprite.scale.y = abs($Sprite.scale.y)
	if move_revy:
		diry = -1
		$Sprite.scale.y = -1
	move_vec = move_vec.normalized() * speed
	move_vec.x *= dirx
	move_vec.y *= diry
	if name == "astronaut":
		print(move_vec)
	move_vec = move_and_slide(move_vec, Vector2.UP)
	if flipy_timeout > 0:
		return
	if is_on_ceiling() or is_on_floor():
		flipy_timeout = 2.0
		move_revy = not move_revy
	if flipx_timeout > 0:
		return
	if is_on_wall():
		flipx_timeout = 2.0
		move_revx = not move_revx
