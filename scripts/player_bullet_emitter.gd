extends Node3D

@export var spread := 0.0
@export var speed := 20.0
@export var direction := Vector3.FORWARD
@export var bullet:PackedScene

@export var emitter_timer:Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	emitter_timer.timeout.connect(_on_bullet_time)

func _on_bullet_time():
	
	var instance := bullet.instantiate()
	
	
	instance.set("transform", global_transform)
	
	var d := direction
	var v := Vector3(randf_range(-1, 1), randf_range(-1, 1), randf_range(-1, 1))
	d += v.normalized() * randf_range(0.0, spread)
	instance.set("linear_velocity", global_transform.basis * d * speed)
	instance.set("angular_velocity", Vector3.ZERO)
	
	get_tree().root.add_child(instance)
