extends RigidBody2D

export var speed = 400
export var agro_force = 0.1
export var min_move_time = 0.5
export var max_move_time = 1
export var distance_scale = 0
export var max_health = 3

var screen_size

var agro_old = false
var agro = false
var near_player = false
var agro_timer = 0

var health = max_health
var is_immune = false

var player
var attraction

func agro():
	near_player = true
	
func unagro():
	near_player = false

func _draw():
	var color = Color.orange
	if agro:
		color = Color.red
		
	draw_circle(Vector2(), 10, color)
	
func _process(delta):
	update()
	
	if near_player or agro_timer > 0:
		agro = true
	else:
		agro = false
	
	if not agro_old and agro:
		player.nearby_enemies += 1
		
	if agro_old and not agro:
		player.nearby_enemies -= 1
		
	agro_old = agro
	
	agro_timer -= delta
	if agro_timer < 0:
		agro_timer = 0
		
func _physics_process(delta):
	if agro:
		apply_central_impulse(position.direction_to(player.position) * agro_force)

func _ready():
	screen_size = get_viewport_rect().size
	player = get_tree().get_nodes_in_group("player")[0]
	
	$MoveTimer.wait_time = rand_range(0, max_move_time)
	$MoveTimer.start()
	
func go_immune():
	is_immune = true
	$ImmuneTimer.start()

func _on_MoveTimer_timeout():
	if not agro:
		attraction = max(player.attraction - position.distance_to(player.position) * distance_scale, 0.00001)
		
		var move_direction = calc_move_direction()
		apply_impulse(Vector2(), move_direction * speed)
	
	$MoveTimer.wait_time = rand_range(min_move_time, max_move_time)
	$MoveTimer.start()
	
func calc_move_direction():
	#Calculates the direction relative to the player's direction to move in
	#This angle is random but becomes more biased towards the player as the enemy is more attracted
	
	var uniform_sample = randf()
	var angle_offset = inverse_f(uniform_sample, -attraction)
	var flip_sample = randf()
	
	if flip_sample < 0.5:
		angle_offset = -angle_offset
	
	var player_direction = position.direction_to(player.position)
	var move_direction = player_direction.rotated(angle_offset)
	
	return move_direction
	
func inverse_f(b, m):
	#Inverse of the cumalative distribution function
	#Used to convert the uniform distribution of randf() to the one calculated below
	var c = calc_c(m)
	return (-c + sqrt(c * c + 2 * m * -b)) / m
	
func calc_c(m):
	#Random distribution function of the angle defined as mx+c
	#This calculates the c required to keep the area under the line 1 for any m
	return (2 - m * PI * PI) / (2 * PI)

func _on_ImmuneTimer_timeout():
	is_immune = false
