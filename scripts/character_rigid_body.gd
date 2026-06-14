extends RigidBody3D

@export var cancel_rotation := false

@export var health:Range
var immortal := false
@export var damage_sound:AudioStreamPlayer3D
@export var death_explosion:PackedScene
signal died

@export var ammos:Array[Range]

@export var enemy_room_detector:Area3D
var current_enemy_room:Area3D
@export var enemies_remaining_label:Label
@export var enemies_total_label:Label
@export var enemy_group := &"critter"

var is_in_enemy_room := false

@export var collectibles := PackedStringArray()
@export var collectibles_visual:Node3D

func _ready() -> void:
	health.value_changed.connect(_on_health_changed)

func _on_health_changed(new_value:float):
	if !immortal and damage_sound:
		damage_sound.play()
	if new_value <= health.min_value and !immortal:
		queue_free() 
		died.emit()
		if death_explosion:
			var instance := death_explosion.instantiate()
			instance.set("transform", global_transform)
			get_tree().root.add_child(instance)

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
	t.tween_property(ammo, "value", target_ammo, 2.0)

func _physics_process(_delta: float) -> void:
	current_enemy_room = null
	is_in_enemy_room = false
	if is_instance_valid(enemy_room_detector) and is_instance_valid(enemies_remaining_label):
		for a in enemy_room_detector.get_overlapping_areas():
			if !is_instance_valid(a) or !a.has_method("get_critters_remaining"):
				continue
			is_in_enemy_room = true
			current_enemy_room = a
			var result = a.call("get_critters_remaining")
			if result is int:
				enemies_remaining_label.text = str(result)
	
	if is_instance_valid(enemies_total_label):
		var total_enemies := get_tree().get_node_count_in_group(enemy_group)
		enemies_total_label.text = str(total_enemies)
	
	#print("current_enemy_room: ", current_enemy_room)
 
