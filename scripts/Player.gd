extends RigidBody2D

export var speed = 1000

var nearby_partiers = 0
var boundary = 285

var money = 0;
var dancing = false

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
		
	if(!dancing):
		apply_impulse(Vector2(), velocity.normalized() * speed)
	
func _input(event):
	if event.is_action_pressed("dance"):
		dancing = !dancing
		print("hey!")
		
		if dancing:
			$AnimationPlayer.play("dance")
		else:
			$AnimationPlayer.stop()
			$AnimationPlayer.seek(0, true)
			
	if event.is_action_pressed("shoo"):
		var shooed = $ProximityArea.get_overlapping_bodies()
		for body in shooed:
			if is_body_partier(body):
				body.shoo(position.direction_to(body.position))

func _on_ProximityArea_body_entered(body):
	if is_body_partier(body):
		body.start_dancing($AnimationPlayer.get_current_animation_position())

func _on_ProximityArea_body_exited(body):
	if is_body_partier(body):
		body.stop_dancing()

func is_body_partier(body):
	return "partier" in body.get_groups()