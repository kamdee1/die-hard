extends Area2D

func _ready():
	add_to_group("pickups")
	connect("body_entered", self, "_on_body_entered")

func _on_body_entered(body):
	if body.is_in_group("player"):
		body.heal(25)
		queue_free()
