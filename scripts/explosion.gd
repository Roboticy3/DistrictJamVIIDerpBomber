extends Node


@export var area:Area3D

@export var damage := 1.0
@export var radius := 1.0
@export var force := 200.0
@export_flags_3d_physics var collision_mask:int

@export var timer:Timer

var afflicted_targets:Dictionary[Node, bool] = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area.scale = Vector3.ONE * radius
	area.collision_mask = collision_mask
	
	create_tween().tween_property(area, "scale", Vector3.ZERO, timer.wait_time).set_trans(Tween.TRANS_CIRC)

func _physics_process(_delta: float) -> void:
	for b in area.get_overlapping_bodies():
		if !is_instance_valid(b) or afflicted_targets.get(b):
			continue
		
		#get an associated healthbar
		var health:Range = b.get("health")
		if !(health is Range):
			continue
		
		#check raycast to the body for empty or [body]
		var world := b.get_world_3d()
		var params := PhysicsRayQueryParameters3D.new()
		params.exclude = [b]
		params.from = area.global_position
		params.to = b.global_position
		params.collision_mask = 1 #terrain only
		var result := world.direct_space_state.intersect_ray(params)
		if !result.is_empty():
			#print("explosion ", self, " could not hit ", b, " due to occluder ", result.get("collider"))
			continue
		
		#deal damage
		health.value -= damage
		
		if b is RigidBody3D:
			var distance2 := area.global_position.distance_squared_to(b.global_position)
			var direction := area.global_position.direction_to(b.global_position)
			b.apply_central_force(direction * force / distance2)
		print("explosion ", self, " hit ", b, " for ", damage, " points (remaining: ", health.value, ")")
		afflicted_targets[b] = true
		pass
