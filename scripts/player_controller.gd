extends Node

@export var sensor:RayCast3D
@export var body:RigidBody3D

@export var sensor_terrain_distance := 1.5
@export var speed_neutral := 2.0
@export var speed_reverse := -0.5
@export var speed_forward := 3.0
@export var acceleration := 5.0

@export var current_up := Vector3.UP

@export var garbage:Node3D
@export var gun:Node

@export var body_group := &"player_body"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body.add_to_group(body_group)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	pass # Replace with function body.

func get_body_transform() -> Transform3D:
	return body.global_transform

func get_sensor_position() -> Vector3:
	return sensor.get_collision_point()

func is_sensor_terrain() -> bool:
	var d := get_body_transform().origin.distance_to(sensor.get_collision_point())
	return d < sensor_terrain_distance

func get_forward_vector() -> Vector3:
	return -get_body_transform().basis.z

var desired_mouse_velocity := Vector2.ZERO
func _input(event:InputEvent):
	if event is InputEventMouseMotion:
		var mouse_rel:Vector2 = -event.screen_relative * SettingsStore.mouse_sensitivity
		desired_mouse_velocity = mouse_rel

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var target_velocity := Vector3.ZERO
	if is_sensor_terrain():
		target_velocity = get_forward_vector() * speed_reverse
	elif gun.get("firing"):
		target_velocity = get_forward_vector() * speed_neutral
	else:
		target_velocity = get_forward_vector() * speed_forward
	
	var current_velocity := body.linear_velocity
	var next_velocity := current_velocity.move_toward(target_velocity, delta * acceleration)
	body.linear_velocity = next_velocity
	
	if Input.is_action_pressed("alt_plane"):
		body.rotate(get_body_transform().basis.z, desired_mouse_velocity.x)
		
	else:
		body.rotate(current_up, desired_mouse_velocity.x)
	current_up = get_body_transform().basis.y
	body.rotate(get_body_transform().basis.x, desired_mouse_velocity.y)
	desired_mouse_velocity *= 0.6
