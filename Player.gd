extends Area2D

export var speed = 100

var nearby_enemies = 0
var boundary = 285

func _process(delta):
	
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
	
	#Draw attraction radius
	#update()
	
func _input(event):
	pass

func _on_ProximityArea_body_entered(body):
	if is_body_enemy(body):
		body.agro()

func _on_ProximityArea_body_exited(body):
	if is_body_enemy(body):
		body.unagro()

func is_body_enemy(body):
	return "enemy" in body.get_groups()