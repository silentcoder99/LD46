extends Node2D

export (int) var spawn_amount
export (int) var spawn_area
export (Array, PackedScene) var Partiers
export (Array, AudioStream) var songs
export (Array, int) var tempos
export var time_limit = 100

var fade_amount = 1
var transparent
var opaque
var fade_rate = 0.7

var restart_time = 5
var is_game_over = false

var time = 10
var time_suffix = "PM"

var frame_time
var switched = false

func play_song(index):
	$MusicPlayer.stop()
	$MusicPlayer.stream = songs[index]
	$MusicPlayer.play()
	
	set_bpm(tempos[index])

func set_bpm(bpm):
	var beats_per_second = bpm / 60.0
	var seconds_per_beat = 1.0 / beats_per_second
	frame_time = seconds_per_beat / 2.0
	
	print("BPS: %s" % str(beats_per_second))
	print("SPB: %s" % str(seconds_per_beat))
	print("Frame time: %s" % str(frame_time))
	
	update_animators()
	
func update_animators():
	for animator in get_tree().get_nodes_in_group("animated"):
		animator.update_frame_time(frame_time)

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
		
	play_song(0)
		
func _process(delta):
	time_limit -= delta
	if time_limit <= 0:
		get_tree().reload_current_scene()
		
	$UI/MoneyLabel.text = "Cash $" + str($YSort/Player.money)
	$UI/ComplaintsLabel.text = "Complaints " + str($YSort/Player.complaints) + "/10"
	$UI/TimeLabel.text = "Time " + str(time) + " " + time_suffix
	
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
		
	if time == 2 and not switched:
		switched = true
		play_song(1)
		
	if time == 5 and time_suffix == "AM":
		game_over("CONGRATULATIONS", "Your party was a success!")
	
func game_over(title, message):
	if not is_game_over:
		is_game_over = true
		
		$UI/GameOverLabel.text = title
		$UI/GameOverSubLabel.text = message
		$UI/GameOverScore.text = $UI/ScoreLabel.text
		$UI/GameOverLabel.show()
		$UI/GameOverSubLabel.show()
		$UI/GameOverScore.show()

func _on_Clock_timeout():
	time += 1
	if time >= 12:
		time_suffix = "AM"
		
	if time > 12:
		time = 1
