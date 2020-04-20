extends Sprite

export var bpm = 110

func _ready():
	var beats_per_second = bpm / 60.0
	var seconds_per_beat = 1.0 / beats_per_second
	var frame_time = seconds_per_beat / 2.0
	var animation_speed = 1 / frame_time
	$AnimationPlayer.set_speed_scale(animation_speed)
	$AnimationPlayer.play("dance")
	
func update_frame_time(frame_time, offset):
	var animation_speed = 1 / frame_time
	$AnimationPlayer.set_speed_scale(animation_speed)
	$AnimationPlayer.seek(offset, true)
	
func set_animation(animation):
	$AnimationPlayer.play(animation)