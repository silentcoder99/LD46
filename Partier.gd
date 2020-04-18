extends RigidBody2D

export var speed = 400
export var min_move_time = 0.5
export var max_move_time = 1

var screen_size

var dancing_old = false
var dancing = false
var near_player = false

var player
var attraction

func start_dancing(animTime):
	near_player = true
	$AnimationPlayer.play("dance")
	$AnimationPlayer.seek(animTime, true);
	
func stop_dancing():
	near_player = false
	
func _process(delta):
	if near_player:
		dancing = true
	else:
		dancing = false
	
	if not dancing_old and dancing:
		player.nearby_partiers += 1
		
		
	if dancing_old and not dancing:
		player.nearby_partiers -= 1
		$AnimationPlayer.stop()
		$AnimationPlayer.seek(0, true)
		
	dancing_old = dancing

func _ready():
	screen_size = get_viewport_rect().size
	player = get_tree().get_nodes_in_group("player")[0]
	
	$MoveTimer.wait_time = rand_range(0, max_move_time)
	$MoveTimer.start()

func _on_MoveTimer_timeout():
	var move_direction = Vector2(1, 0).rotated(randf() * 2 * PI);
	apply_impulse(Vector2(), move_direction * speed)
	
	$MoveTimer.wait_time = rand_range(min_move_time, max_move_time)
	$MoveTimer.start()