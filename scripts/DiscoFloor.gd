extends Node2D

func update_frame_time(frame_time, offset):
	var animation_speed = 1 / frame_time
	$AnimationPlayer.set_speed_scale(animation_speed)
	$AnimationPlayer.seek(offset, true)