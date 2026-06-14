extends Node

@export var body:RigidBody3D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_instance_valid(body) and body.get("is_in_enemy_room"):
		set("visible", true)
	else:
		set("visible", false)
