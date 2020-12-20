extends Sprite


const SplashScene := preload("res://Objects/Particles/Splash.tscn")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Area2D_body_entered(body):
	var splash = SplashScene.instance()
	get_tree().current_scene.add_child(splash)
	splash.global_position = body.global_position - Vector2(0, -20)
	$Tween.interpolate_callback(splash, 0.5, "queue_free")
	$Tween.start()
