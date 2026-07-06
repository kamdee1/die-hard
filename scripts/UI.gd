extends CanvasLayer

var health_label = null
var ammo_label = null
var score_label = null
var lives_label = null
var level_label = null

func _ready():
	health_label = Label.new()
	ammo_label = Label.new()
	score_label = Label.new()
	lives_label = Label.new()
	level_label = Label.new()
	
	add_child(health_label)
	add_child(ammo_label)
	add_child(score_label)
	add_child(lives_label)
	add_child(level_label)
	
	health_label.rect_position = Vector2(10, 10)
	ammo_label.rect_position = Vector2(10, 40)
	score_label.rect_position = Vector2(10, 70)
	lives_label.rect_position = Vector2(10, 100)
	level_label.rect_position = Vector2(10, 130)
	
	# Connect signals
	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.connect("health_changed", self, "_on_health_changed")
		player.connect("ammo_changed", self, "_on_ammo_changed")
	
	var game_manager = get_tree().get_first_node_in_group("game_manager")
	if game_manager:
		game_manager.connect("score_changed", self, "_on_score_changed")
		game_manager.connect("lives_changed", self, "_on_lives_changed")
		game_manager.connect("level_changed", self, "_on_level_changed")

func _on_health_changed(current, max):
	health_label.text = "Health: %d/%d" % [current, max]

func _on_ammo_changed(ammo):
	ammo_label.text = "Ammo: %d" % ammo

func _on_score_changed(score):
	score_label.text = "Score: %d" % score

func _on_lives_changed(lives):
	lives_label.text = "Lives: %d" % lives

func _on_level_changed(level):
	level_label.text = "Level: %d" % level
