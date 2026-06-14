extends Node

@export var bomb_group := &"critter_bomb"
@export var player_group := &"player_body"

@export var fix_ammo := true

func reward():
	get_tree().call_group(player_group, "give_immortal", 1.0)
	
	if fix_ammo:
		get_tree().call_group(player_group, "give_ammo")
	
	get_tree().call_group.call_deferred(bomb_group, "explode")
