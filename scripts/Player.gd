extends KinematicBody2D

# Movement
const SPEED = 200
const JUMP_FORCE = -400
const GRAVITY = 800
var velocity = Vector2.ZERO
var is_jumping = false
var is_climbing = false

# Shooting
const PROJECTILE_SCENE = preload("res://scenes/Projectile.tscn")
var shoot_cooldown = 0
const SHOOT_DELAY = 0.2
var current_weapon = 0  # 0: Normal, 1: Spread, 2: Laser
var weapon_ammo = [999, 30, 20]  # Ammo for each weapon

# Health
var max_health = 100
var health = 100
var invulnerable_time = 0
const INVULNERABLE_DURATION = 1.0

# Animation
var sprite = null
var animated_sprite = null
var facing_right = true

func _ready():
	sprite = $Sprite
	animated_sprite = $AnimatedSprite
	health = max_health
	emit_signal("health_changed", health, max_health)
	emit_signal("ammo_changed", weapon_ammo[current_weapon])

signal health_changed(current, max)
signal ammo_changed(ammo)
signal died

func _physics_process(delta):
	handle_input()
	
	# Apply gravity if not climbing
	if not is_climbing:
		velocity.y += GRAVITY * delta
	else:
		velocity.y = 0
	
	# Move and slide
	velocity = move_and_slide(velocity, Vector2.UP)
	
	# Update animation
	update_animation()
	
	# Update cooldowns
	if shoot_cooldown > 0:
		shoot_cooldown -= delta
	
	if invulnerable_time > 0:
		invulnerable_time -= delta
		# Flash effect
		if int(invulnerable_time * 10) % 2 == 0:
			modulate.a = 0.5
		else:
			modulate.a = 1.0

func handle_input():
	var input_velocity = Vector2.ZERO
	
	# Check if on ladder
	check_ladder()
	
	if is_climbing:
		# Climbing controls
		if Input.is_action_pressed("ui_up"):
			input_velocity.y = -SPEED
		elif Input.is_action_pressed("ui_down"):
			input_velocity.y = SPEED
		
		if Input.is_action_pressed("ui_right"):
			input_velocity.x = SPEED
			facing_right = true
		elif Input.is_action_pressed("ui_left"):
			input_velocity.x = -SPEED
			facing_right = false
		
		velocity.x = input_velocity.x
		velocity.y = input_velocity.y
		
		# Exit ladder
		if Input.is_action_pressed("ui_down") and is_on_floor():
			is_climbing = false
	else:
		# Ground movement
		if Input.is_action_pressed("ui_right"):
			input_velocity.x = SPEED
			facing_right = true
		elif Input.is_action_pressed("ui_left"):
			input_velocity.x = -SPEED
			facing_right = false
		
		velocity.x = input_velocity.x
		
		# Jumping
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_FORCE
			is_jumping = true
	
	# Shooting
	if Input.is_action_pressed("ui_select"):
		shoot()
	
	# Weapon switching
	if Input.is_action_just_pressed("ui_1"):
		switch_weapon(0)
	elif Input.is_action_just_pressed("ui_2"):
		switch_weapon(1)
	elif Input.is_action_just_pressed("ui_3"):
		switch_weapon(2)

func check_ladder():
	# Check if player is touching a ladder area
	var areas = get_overlapping_areas()
	var on_ladder = false
	
	for area in areas:
		if area.is_in_group("ladder"):
			on_ladder = true
			break
	
	if on_ladder and Input.is_action_pressed("ui_up"):
		is_climbing = true
	elif is_on_floor():
		is_climbing = false

func shoot():
	if shoot_cooldown <= 0 and weapon_ammo[current_weapon] > 0:
		shoot_cooldown = SHOOT_DELAY
		weapon_ammo[current_weapon] -= 1
		emit_signal("ammo_changed", weapon_ammo[current_weapon])
		
		match current_weapon:
			0:  # Normal shot
				fire_projectile(0, Vector2(200, 0) if facing_right else Vector2(-200, 0))
			1:  # Spread shot
				fire_projectile(0, Vector2(200, -100) if facing_right else Vector2(-200, -100))
				fire_projectile(0, Vector2(200, 0) if facing_right else Vector2(-200, 0))
				fire_projectile(0, Vector2(200, 100) if facing_right else Vector2(-200, 100))
			2:  # Laser
				fire_projectile(1, Vector2(250, 0) if facing_right else Vector2(-250, 0))

func fire_projectile(type, velocity_override):
	var projectile = PROJECTILE_SCENE.instance()
	get_parent().add_child(projectile)
	projectile.global_position = global_position + Vector2(30 if facing_right else -30, 0)
	projectile.velocity = velocity_override
	projectile.projectile_type = type
	projectile.damage = 10 if type == 0 else 25

func switch_weapon(weapon_index):
	if weapon_index != current_weapon and weapon_ammo[weapon_index] > 0:
		current_weapon = weapon_index
		emit_signal("ammo_changed", weapon_ammo[current_weapon])

func take_damage(amount):
	if invulnerable_time <= 0:
		health -= amount
		invulnerable_time = INVULNERABLE_DURATION
		emit_signal("health_changed", health, max_health)
		
		if health <= 0:
			die()

func heal(amount):
	health = min(health + amount, max_health)
	emit_signal("health_changed", health, max_health)

func add_ammo(weapon_type, amount):
	weapon_ammo[weapon_type] += amount
	if weapon_type == current_weapon:
		emit_signal("ammo_changed", weapon_ammo[current_weapon])

func die():
	emit_signal("died")
	queue_free()

func update_animation():
	if is_climbing:
		animated_sprite.animation = "climb"
	elif not is_on_floor():
		animated_sprite.animation = "jump"
	elif velocity.x != 0:
		animated_sprite.animation = "run"
		animated_sprite.flip_h = not facing_right
	else:
		animated_sprite.animation = "idle"
		animated_sprite.flip_h = not facing_right
