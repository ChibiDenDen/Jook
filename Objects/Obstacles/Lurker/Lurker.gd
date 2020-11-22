extends Node2D


var lurking := true
export(float) var attack_tell_time = 0.5
export(float) var attack_time = 0.3
export(float) var recover_time = 2.5
var retract_time = 0.1
var player

# Called when the node enters the scene tree for the first time.
func _ready():
	lurk()

func attack():
	if $Area2D.overlaps_body(player):
		player.get_hit()
	$Tween.interpolate_property($Sprite, "scale", Vector2.ONE, Vector2.ZERO, retract_time, Tween.TRANS_LINEAR,Tween.EASE_IN_OUT, recover_time*0.5 - retract_time)
	$Tween.interpolate_callback(self, recover_time, "lurk")
	$Tween.start()

func lurk():
	$Sprite.scale = Vector2.ZERO
	lurking = true
	($Area2D/CollisionShape2D.shape as CircleShape2D).radius = 100.0

func _on_Area2D_body_entered(body):
	if !body.is_in_group("Player"):
		return
	player = body
	if lurking:
		lurking = false
		$Tween.interpolate_property($Sprite, "scale", Vector2.ZERO, Vector2.ONE*0.3, retract_time)
		$Tween.interpolate_property($Sprite, "scale", Vector2.ONE*0.3, Vector2.ONE, attack_time, Tween.TRANS_LINEAR,Tween.EASE_IN_OUT, attack_tell_time)
		$Tween.interpolate_callback(self, attack_tell_time + attack_time, "attack")
		($Area2D/CollisionShape2D.shape as CircleShape2D).radius = 30.0
		$Tween.start()
