extends Control

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_pause"):
		var new_pause_state = not get_tree().paused
		get_tree().paused = not get_tree().paused
		visible = new_pause_state
