extends KinematicBody2D

# Movement
const SPEED = 100
const GRAVITY = 800
var velocity = Vector2.ZERO

# AI
var patrol_left = 0
var patrol_right = 500
var direction = 1
var can_see_player = false
var player = null
const VISION_RANGE = 300
const VISION_HEIGHT = 200

# Combat
var max_health = 50
var health = max_health
var attack_cooldown = 0
const ATTACK_DELAY = 2.0
var shoot_range = 250

# Animation
var animated_sprite = null
var facing_right = true

# Rewards
var score_value = 100
var health_drop_chance = 0.3
var ammo_drop_chance = 0.5

signal died

func _ready():
	animated_sprite = $AnimatedSprite
	add_to_group("enemies")
	health = max_health

func _physics_process(delta):
	# Find player
	if player == null:
		player = get_tree().get_first_node_in_group("player")
	
	# Apply gravity
	velocity.y += GRAVITY * delta
	
	# AI behavior
	update_vision()
	
	if can_see_player:
		attack_behavior(delta)
	else:
		patrol_behavior()
	
	# Update animation
	if velocity.x != 0:
		animated_sprite.animation = "walk"
		animated_sprite.flip_h = (velocity.x < 0)
		facing_right = (velocity.x > 0)
	else:
		animated_sprite.animation = "idle"
	
	# Move
	velocity = move_and_slide(velocity, Vector2.UP)
	
	# Update cooldowns
	if attack_cooldown > 0:
		attack_cooldown -= delta

func update_vision():
	if player == null:
		can_see_player = false
		return
	
	var distance = player.global_position - global_position
	
	# Check if player is in vision range
	if abs(distance.x) < VISION_RANGE and abs(distance.y) < VISION_HEIGHT:
		can_see_player = true
	else:
		can_see_player = false

func patrol_behavior():
	# Simple left-right patrol
	if global_position.x < patrol_left:
		direction = 1
	elif global_position.x > patrol_right:
		direction = -1
	
	velocity.x = direction * SPEED

func attack_behavior(delta):
	var player_dir = sign(player.global_position.x - global_position.x)
	
	# Chase player
	velocity.x = player_dir * SPEED * 1.5
	
	# Shoot at player
	if attack_cooldown <= 0 and abs(player.global_position.x - global_position.x) < shoot_range:
		shoot_at_player()
		attack_cooldown = ATTACK_DELAY

func shoot_at_player():
	# Fire projectile at player
	var projectile = preload("res://scenes/EnemyProjectile.tscn").instance()
	get_parent().add_child(projectile)
	projectile.global_position = global_position + Vector2(20, 0)
	
	var direction = (player.global_position - global_position).normalized()
	projectile.velocity = direction * 150
	projectile.damage = 10

func take_damage(amount):
	health -= amount
	
	if health <= 0:
		die()

func die():
	# Drop rewards
	if randf() < health_drop_chance:
		spawn_health_drop()
	
	if randf() < ammo_drop_chance:
		spawn_ammo_drop()
	
	# Emit signal for score
	get_tree().get_first_node_in_group("game_manager").add_score(score_value)
	
	emit_signal("died")
	queue_free()

func spawn_health_drop():
	var drop = preload("res://scenes/HealthDrop.tscn").instance()
	get_parent().add_child(drop)
	drop.global_position = global_position

func spawn_ammo_drop():
	var drop = preload("res://scenes/AmmoDrop.tscn").instance()
	get_parent().add_child(drop)
	drop.global_position = global_position

func set_patrol_range(left, right):
	patrol_left = left
	patrol_right = right
