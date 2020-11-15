extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_Shield_body_entered(body):
	# assume body is player
	body.pickup_shield()
	queue_free()
