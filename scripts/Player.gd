extends RigidBody2D

export var speed = 1000


var nearby_partiers = 0
var boundary = 285

var money = 0
var dancing = false

var complaints = 0
var score = 0

func play_tip_sound():
	if not $TipSound.playing:
		$TipSound.play()

func _physics_process(delta):
	
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
	
func update_frame_time(frame_time, offset):
	var animation_speed = 1 / frame_time
	$AnimationPlayer.set_speed_scale(animation_speed)
	$AnimationPlayer.seek(offset, true)
	
func start_dancing():
	var time = $AnimationPlayer.get_current_animation_position()
	$AnimationPlayer.play("dance")
	$AnimationPlayer.seek(time, true)

func stop_dancing():
	var time = $AnimationPlayer.get_current_animation_position()
	$AnimationPlayer.play("idle")
	$AnimationPlayer.seek(time, true)
	
func _input(event):
	#Stop dancing if player attempts to move
	if event.is_action_pressed("ui_up") or \
			event.is_action_pressed("ui_down") or \
			event.is_action_pressed("ui_left") or \
			event.is_action_pressed("ui_right"):
		if dancing:
			dancing = false
			stop_dancing()
	
	if event.is_action_pressed("dance"):
		dancing = !dancing
		
		if dancing:
			start_dancing()
		else:
			stop_dancing()
			
	if event.is_action_pressed("shoo"):
		if dancing:
			dancing = false
			stop_dancing()
		
		$ShooSound.play()
		$ShooAnimator.play("shoo")
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