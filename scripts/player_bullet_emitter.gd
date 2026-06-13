extends Node3D

@export var spread := 0.0
@export var speed := 20.0
@export var lifetime := 1.0
@export var direction := Vector3.FORWARD

@export var bullet_model:Mesh
@export var bullet_shape:Shape3D
@export var bullet_scale := Vector3.ONE * 0.2

@export var emitter_timer:Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	emitter_timer.timeout.connect(_on_bullet_time)

func _on_bullet_time():
	print("shooting bullet")
	
	var bullet := Node.new()
	var body := RigidBody3D.new()
	var model := MeshInstance3D.new()
	var shape := CollisionShape3D.new()
	var timer := Timer.new()
	
	bullet.set_script(load("res://scripts/bullet.gd"))
	bullet.model = model
	bullet.body = body
	
	body.gravity_scale = 0.0
	body.continuous_cd = true
	body.transform = global_transform
	
	var d := direction
	var v := Vector3(randf_range(-1, 1), randf_range(-1, 1), randf_range(-1, 1))
	d += v.normalized() * randf_range(0.0, spread)
	body.linear_velocity = body.basis * d * speed 
	body.angular_velocity = Vector3.ZERO
	
	model.mesh = bullet_model
	model.scale = bullet_scale
	
	shape.shape = bullet_shape
	
	timer.one_shot = true
	timer.autostart = true
	timer.wait_time = lifetime
	timer.timeout.connect(bullet.queue_free)
	
	body.add_child(model)
	body.add_child(shape)
	bullet.add_child(body)
	bullet.add_child(timer)
	
	
	
	
	get_tree().root.add_child(bullet)
