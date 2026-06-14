extends Node

var enemies_paused := false
var show_collisions := false

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		if event.keycode == KEY_F1:
			enemies_paused = !enemies_paused
			if enemies_paused:
				for c in get_tree().get_nodes_in_group("critter"):
					c.process_mode = Node.PROCESS_MODE_DISABLED
				print("paused enemies!")
			else:
				for c in get_tree().get_nodes_in_group("critter"):
					c.process_mode = Node.PROCESS_MODE_INHERIT
				print("unpaused enemies!")
		elif event.keycode == KEY_F2:
			show_collisions = !show_collisions
			get_tree().debug_collisions_hint = show_collisions
