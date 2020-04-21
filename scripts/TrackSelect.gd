extends CanvasLayer

func _ready():
	OS.set_window_maximized(true)
	select($Track1)
	$Track1.grab_focus()

func select(label):
	$Track1.modulate.a = 0.5
	$Back.modulate.a = 0.5
	$Track2.modulate.a = 0.5
	
	label.modulate.a = 1
	$BearCursor.position.y = label.rect_position.y + 5
	$BearCursor.show()

func _on_Start_mouse_entered():
	select($Track1)

func _on_Start_focus_entered():
	select($Track1)

func _on_Exit_mouse_entered():
	select($Back)

func _on_Exit_focus_entered():
	select($Back)


func _on_Start_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			Globals.current_song = 0
			get_tree().change_scene("res://scenes/Main.tscn")


func _on_Exit_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			get_tree().change_scene("res://scenes/Menu.tscn")

func _on_Tutorial_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			Globals.current_song = 1
			get_tree().change_scene("res://scenes/Main.tscn")

func _on_Tutorial_mouse_entered():
	select($Track2)
