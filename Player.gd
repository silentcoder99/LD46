extends Area2D

export var speed = 100
export var attraction_scale = 0.0005
export var max_attraction = 0.02

export var bullet_spread = 20
export var bullet_count = 5
export var cooldown_time = 0.25

export var health = 3
export var immune_time = 1

export var life_time = 10

var is_immune = false

var min_attraction = 0.0001
#var min_attraction = 0.00001
var attraction = min_attraction

var nearby_enemies = 0
var attacking = false
var cooldown = 0

var boundary = 285

var bullet_scene = load("res://Bullet.tscn")

func _ready():
	bullet_spread = deg2rad(bullet_spread)
	$ImmuneTimer.wait_time = immune_time
	$LifeTimeLabel.set_as_toplevel(true)

func _process(delta):
	#attraction = min(min_attraction + attraction_scale * nearby_enemies, max_attraction)
	attraction = max_attraction
	
	var velocity = Vector2()
	
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
		
	position += velocity.normalized() * speed * delta
	
	position.x = clamp(position.x, -boundary, boundary)
	position.y = clamp(position.y, -boundary, boundary)
	
	var mouse_position = get_global_mouse_position()
	look_at(mouse_position)
	
	cooldown -= delta
	if cooldown <= 0:
		cooldown = 0
		$BodyArea/BodyPolygon.color = "#02f200"
	else:
		$BodyArea/BodyPolygon.color = Color.blue
		
#	life_time -= delta
#	$LifeTimeLabel.text = "%.2f" % life_time
#	if life_time <= 0:
#		get_tree().reload_current_scene()
		
	$LifeTimeLabel.rect_position = position + Vector2(-20, -33)
	
	#Draw attraction radius
	#update()
	
func _physics_process(delta):
	if attacking and cooldown <= 0:
		for i in range(bullet_count):
			var bullet = bullet_scene.instance()
			var rotation_offset = -bullet_spread / 2 + bullet_spread / (bullet_count - 1) * i
			bullet.transform = Transform2D(rotation + rotation_offset, position)
			get_parent().add_child(bullet)
			
		cooldown = cooldown_time	
		attacking = false
		
	else:
		attacking = false
	
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			attacking = true

func _on_ProximityArea_body_entered(body):
	if is_body_enemy(body):
		body.agro()

func _on_ProximityArea_body_exited(body):
	if is_body_enemy(body):
		body.unagro()

func is_body_enemy(body):
	return "enemy" in body.get_groups()

func _on_BodyArea_body_entered(body):
	if is_body_enemy(body) and not is_immune:
		take_damage()

func _on_ImmuneTimer_timeout():
	is_immune = false
	
	#Check for enemies already on player
	for body in $BodyArea.get_overlapping_bodies():
		if is_body_enemy(body):
			take_damage()
			break
			
func take_damage():
	is_immune = true
	$ImmuneTimer.start()
	get_parent().damage_splash()
	health -= 1
	
	if health <= 0:
		get_tree().reload_current_scene()