extends Node

@export var pips:Array[Node]
@export var ammo:Range

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ammo.value_changed.connect(_on_value_changed)

func _on_value_changed(new_value:float):
	print("bomb ammo: ", new_value)
	for i in pips.size():
		if !is_instance_valid(pips[i]):
			continue
		if i < new_value:
			pips[i].set("visible", true)
		else:
			pips[i].set("visible", false)
