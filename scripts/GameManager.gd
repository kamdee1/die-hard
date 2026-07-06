extends Node

var score = 0
var lives = 3
var current_level = 1
var total_levels = 3
var paused = false

signal score_changed(score)
signal lives_changed(lives)
signal level_changed(level)
signal game_over
signal level_complete

func _ready():
	add_to_group("game_manager")
	emit_signal("score_changed", score)
	emit_signal("lives_changed", lives)
	emit_signal("level_changed", current_level)

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		toggle_pause()

func add_score(amount):
	score += amount
	emit_signal("score_changed", score)

func lose_life():
	lives -= 1
	emit_signal("lives_changed", lives)
	
	if lives <= 0:
		emit_signal("game_over")
		get_tree().reload_current_scene()
	else:
		# Restart current level
		get_tree().reload_current_scene()

func next_level():
	if current_level < total_levels:
		current_level += 1
		emit_signal("level_changed", current_level)
		emit_signal("level_complete")
		# Load next level scene
		get_tree().change_scene("res://scenes/Level%d.tscn" % current_level)
	else:
		# Game won!
		emit_signal("game_over")
		get_tree().change_scene("res://scenes/GameWon.tscn")

func toggle_pause():
	paused = !paused
	get_tree().paused = paused

func reset_game():
	score = 0
	lives = 3
	current_level = 1
	emit_signal("score_changed", score)
	emit_signal("lives_changed", lives)
	emit_signal("level_changed", current_level)
	get_tree().reload_current_scene()
