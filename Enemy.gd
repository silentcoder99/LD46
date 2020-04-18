extends RigidBody2D

export var speed = 400
export var min_move_time = 0.5
export var max_move_time = 1

var screen_size

var agro_old = false
var agro = false
var near_player = false

var player
var attraction

func agro():
	near_player = true
	
func unagro():
	near_player = false
	
func _process(delta):
	
	if near_player:
		agro = true
	else:
		agro = false
	
	if not agro_old and agro:
		player.nearby_enemies += 1
		
	if agro_old and not agro:
		player.nearby_enemies -= 1
		
	agro_old = agro

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