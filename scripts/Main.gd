extends Node2D

export (int) var spawn_amount
export (int) var spawn_area
export (Array, PackedScene) var Partiers
export var time_limit = 100

var fade_amount = 1
var transparent
var opaque
var fade_rate = 0.7

var restart_time = 4

var is_game_over = false

func _ready():
	OS.set_window_maximized(true)
	
	randomize()
	
	transparent = $UI/FadeRect.color
	opaque = Color(transparent.r, transparent.g, transparent.b, 0.6)
	
	for i in range(spawn_amount):
		var spawn_position = Vector2()
		spawn_position.x = randi() % (spawn_area * 2) - spawn_area
		spawn_position.y = randi() % (spawn_area * 2) - spawn_area
		
		var partier = Partiers[rand_range(0, len(Partiers))].instance()
		$YSort.add_child(partier)
		partier.position = spawn_position
		
func _process(delta):
	time_limit -= delta
	if time_limit <= 0:
		get_tree().reload_current_scene()
		
	$UI/DebugLabel.text = str($YSort/Player.nearby_partiers) + '\n'
	$UI/MoneyLabel.text = "Cash $" + str($YSort/Player.money)
	$UI/ComplaintsLabel.text = "Complaints " + str($YSort/Player.complaints) + "/10"
	
	if fade_amount >= 0 and is_game_over:
		$UI/FadeRect.color = opaque.linear_interpolate(transparent, fade_amount)
		fade_amount -= delta * fade_rate
		
	if is_game_over:
		restart_time -= delta
		if restart_time <= 0:
			get_tree().reload_current_scene()
		
	if $YSort/Player.complaints >= 10:
		game_over("Your party was shut down!")
	
func game_over(message):
	is_game_over = true
	
	$UI/GameOverSubLabel.text = message
	$UI/GameOverLabel.show()
	$UI/GameOverSubLabel.show()
	