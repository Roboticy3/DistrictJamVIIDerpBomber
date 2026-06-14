extends RigidBody3D

@export var cancel_rotation := false

@export var health:Range
var immortal := false

@export var ammos:Array[Range]

func _ready() -> void:
	health.value_changed.connect(_on_health_changed)

func _on_health_changed(new_value:float):
	if new_value <= health.min_value and !immortal:
		queue_free() 

func _integrate_forces(state):
	if cancel_rotation:
		state.angular_velocity = Vector3.ZERO

func give_immortal(seconds:float):
	immortal = true
	var t := create_tween()
	
	t.tween_property(health, "value", health.max_value, 1.0)
	t.tween_property(self, "immortal", false, 1.0)

func give_ammo(amount := -1, index := -1):
	if index < 0:
		for i in ammos.size():
			give_ammo(amount, i)
		return
	elif index > ammos.size():
		return
	
	var ammo := ammos[index]
	if !is_instance_valid(ammo):
		return
	
	var target_ammo := ammo.value + amount
	if amount < 0:
		target_ammo = ammo.max_value
		
	var t := create_tween()
	t.tween_property(ammo, "value", target_ammo, 1.0)
