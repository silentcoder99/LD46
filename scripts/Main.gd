extends Node2D

export (int) var spawn_amount
export (int) var spawn_area
export (Array, PackedScene) var Partiers
export var time_limit = 100

var fade_amount = 1
var transparent
var opaque
var fade_rate = 0.7

var restart_time = 5
var is_game_over = false

var time = 1

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
		
	$UI/MoneyLabel.text = "Cash $" + str($YSort/Player.money)
	$UI/ComplaintsLabel.text = "Complaints " + str($YSort/Player.complaints) + "/10"
	$UI/TimeLabel.text = "Time " + str(time) + " AM"
	
	if not is_game_over:
		$UI/ScoreLabel.text = "Score " + str($YSort/Player.score)
	
	if fade_amount >= 0 and is_game_over:
		$UI/FadeRect.color = opaque.linear_interpolate(transparent, fade_amount)
		fade_amount -= delta * fade_rate
		
	if is_game_over:
		restart_time -= delta
		if restart_time <= 0:
			get_tree().reload_current_scene()
		
	if $YSort/Player.complaints >= 10:
		game_over("GAME OVER", "Your party was shut down!")
		
	if time >= 6:
		game_over("CONGRATULATIONS", "Your party was a success!")
	
func game_over(title, message):
	is_game_over = true
	
	$UI/GameOverLabel.text = title
	$UI/GameOverSubLabel.text = message
	$UI/GameOverScore.text = $UI/ScoreLabel.text
	$UI/GameOverLabel.show()
	$UI/GameOverSubLabel.show()
	$UI/GameOverScore.show()
	

func _on_Clock_timeout():
	time += 1
