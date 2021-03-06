extends RigidBody2D

export var speed = 400
export var min_move_delay = 0.5
export var max_move_delay = 1
export var min_move_duration = 0.5
export var max_move_duration = 2
export var chatter_chance = 0.005
export var tip_amount = 1
export (PackedScene) var TipAnimation

var screen_size

var dance_time_offset;

var dancing_old = false
var dancing = false
var near_player = false

var move_direction
var moving

var player
var attraction

func start_dancing(animTime):
	dance_time_offset = animTime;
	near_player = true
	
func stop_dancing():
	near_player = false
	
func update_frame_time(frame_time, offset):
	var animation_speed = 1 / frame_time
	$AnimationPlayer.set_speed_scale(animation_speed)
	$AnimationPlayer.seek(offset, true)
	
func give_tip():
	player.play_tip_sound()
	player.money += tip_amount
	player.score += tip_amount
	var tip_animation = TipAnimation.instance()
	tip_animation.set_amount(tip_amount)
	tip_animation.rect_position = position + Vector2(0, -36)
	get_tree().get_root().add_child(tip_animation)
	#add_child(tip_animation)
	
func chatter():
	if randf() <= chatter_chance:
		$ChatterSound.play()	

func _process(delta):
	if near_player && player.dancing:
		dancing = true
	else:
		dancing = false
	
	if not dancing_old and dancing:
		var time = $AnimationPlayer.get_current_animation_position()
		$AnimationPlayer.play("dance")
		$AnimationPlayer.seek(time, true);
		player.nearby_partiers += 1
		
		
	if dancing_old and not dancing:
		player.nearby_partiers -= 1
		var time = $AnimationPlayer.get_current_animation_position()
		$AnimationPlayer.play("idle")
		$AnimationPlayer.seek(time, true);
		
	dancing_old = dancing

func _physics_process(delta):
	if moving:
		apply_impulse(Vector2(), move_direction * speed)

func _ready():
	screen_size = get_viewport_rect().size
	player = get_tree().get_nodes_in_group("player")[0]
	
	$MoveDurationTimer.wait_time = rand_range(min_move_duration, max_move_duration)
	$MoveTimer.wait_time = rand_range(0, max_move_delay)
	$MoveTimer.start()

func shoo(direction):
	$MoveTimer.stop()
	move_direction = direction
	moving = true
	$MoveDurationTimer.wait_time = rand_range(min_move_duration, max_move_duration)
	$MoveDurationTimer.start()

func hurt():
	$HurtSound.play()
	$HurtAnimation.play("hurt")
	player.complaints += 1
	player.score -= 5

func _on_MoveTimer_timeout():	
	move_direction = Vector2(1, 0).rotated(rand_range(0, 2 * PI));
	moving = true
	$MoveDurationTimer.wait_time = rand_range(min_move_duration, max_move_duration)
	$MoveDurationTimer.start()

func _on_MoveDurationTimer_timeout():
	moving = false
	
	var move_delay = rand_range(min_move_delay, max_move_delay)
	if dancing:
		move_delay *= 2
		
	$MoveTimer.wait_time = move_delay
	$MoveTimer.start()
