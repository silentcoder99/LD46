extends CanvasLayer

func _ready():
	OS.set_window_maximized(true)
	select($Start)
	$Start.grab_focus()

func select(label):
	$Start.modulate.a = 0.5
	$Exit.modulate.a = 0.5
	$Tutorial.modulate.a = 0.5
	
	label.modulate.a = 1
	$BearCursor.position.y = label.rect_position.y + 5
	$BearCursor.show()

func _on_Start_mouse_entered():
	select($Start)

func _on_Start_focus_entered():
	select($Start)

func _on_Exit_mouse_entered():
	select($Exit)

func _on_Exit_focus_entered():
	select($Exit)


func _on_Start_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			get_tree().change_scene("res://scenes/Main.tscn")


func _on_Exit_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			get_tree().quit()

func _on_Tutorial_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			get_tree().change_scene("res://scenes/Tutorial.tscn")

func _on_Tutorial_mouse_entered():
	select($Tutorial)
