extends RigidBody3D

@export var cancel_rotation := false

@export var health:Range

func _ready() -> void:
	health.value_changed.connect(_on_health_changed)

func _on_health_changed(new_value:float):
	if new_value <= health.min_value:
		queue_free() 

func _integrate_forces(state):
	if cancel_rotation:
		state.angular_velocity = Vector3.ZERO
