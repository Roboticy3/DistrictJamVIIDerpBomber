extends Node

var enemies_paused := false
var noclip_enabled := false

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
			noclip_enabled = !noclip_enabled
			if noclip_enabled:
				for p in get_tree().get_nodes_in_group("player_body"):
					p.set("collision_mask", 0)
					p.set("speed_forward", 10.0)
						
				for s in get_tree().get_nodes_in_group("player_sensor"):
					s.set("collision_mask", 0)
				print("noclip enabled")
			else:
				for p in get_tree().get_nodes_in_group("player_body"):
					p.set("collision_mask", 1 | 2 | 3)
					p.set("speed_forward", SettingsStore.player_speed)
				
				for s in get_tree().get_nodes_in_group("player_sensor"):
					s.set("collision_mask", 1)
				print("noclip disabled")
