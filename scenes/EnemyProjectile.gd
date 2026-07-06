extends Area2D

var velocity = Vector2.ZERO
var damage = 5
var lifetime = 3.0

func _ready():
	connect("body_entered", self, "_on_body_entered")

func _physics_process(delta):
	global_position += velocity * delta
	lifetime -= delta
	if lifetime <= 0:
		queue_free()

func _on_body_entered(body):
	if body.is_in_group("player"):
		body.take_damage(damage)
		queue_free()
