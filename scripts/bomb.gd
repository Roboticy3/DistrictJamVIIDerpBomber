extends Area3D

@export var base_damage := 1.0
@export var base_radius := 1.0
@export_flags_3d_physics var explosion_mask:int =2

@export var sensitive := false

@export var explosion:PackedScene

func _ready():
	if sensitive:
		body_entered.connect(_on_body_entered)

func _on_body_entered(_body):
	explode()

func explode():
	#emit an explosion and die
	var instance := explosion.instantiate()
	instance.set("transform", global_transform)
	instance.set("radius", base_radius)
	instance.set("damage", base_damage)
	instance.set("collision_mask", explosion_mask)
	get_tree().root.add_child(instance)
