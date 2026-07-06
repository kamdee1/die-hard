extends Area2D

var velocity = Vector2.ZERO
var projectile_type = 0  # 0: normal, 1: laser
var damage = 10
var lifetime = 5.0

func _ready():
	add_to_group("projectiles")
	connect("body_entered", self, "_on_body_entered")
	connect("area_entered", self, "_on_area_entered")

func _physics_process(delta):
	global_position += velocity * delta
	lifetime -= delta
	
	if lifetime <= 0:
		queue_free()

func _on_body_entered(body):
	if body.is_in_group("enemies"):
		body.take_damage(damage)
		queue_free()
	elif body.is_in_group("walls"):
		queue_free()

func _on_area_entered(area):
	if area.is_in_group("enemies"):
		area.take_damage(damage)
		queue_free()
