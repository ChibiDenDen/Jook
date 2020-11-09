extends Area2D

func _ready():
	pass # Replace with function body.

func _on_Fuel_body_entered(body):
	body.pickup_fuel()
	queue_free()
	
