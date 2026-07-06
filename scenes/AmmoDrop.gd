extends Area2D

var weapon_type = randi() % 3

func _ready():
	add_to_group("pickups")
	connect("body_entered", self, "_on_body_entered")

func _on_body_entered(body):
	if body.is_in_group("player"):
		body.add_ammo(weapon_type, 20)
		queue_free()
