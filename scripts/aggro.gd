extends Node

@export var aggro_group := &"player_body"
@export var aggro_timer:Timer
@export var fire_timer:Timer
@export var anger_animator:AnimationPlayer

@export var body:RigidBody3D
@export var base_fire_rate := 1.0
@export var anger_max := 20.0
@export var fire_rate_max := 10.0
@export var anger_anim_max := 4.0

@export var min_target_distance := 3.0
@export var fear_force := 100.0

@export var emitter:Node

var current_target:RigidBody3D
var anger := 0.0

func _ready():
	aggro_timer.timeout.connect(_on_process_aggro)
	fire_timer.timeout.connect(_on_process_fire)

func _on_process_aggro() -> void:
	var old_target := current_target
	var target_found := false
	for p in get_tree().get_nodes_in_group(aggro_group):
		if p is RigidBody3D:
			var state := body.get_world_3d().direct_space_state
			var query := PhysicsRayQueryParameters3D.new()
			query.from = body.global_position
			query.to = p.global_position
			query.collision_mask = 1 | 3 | 7 #Terrain, props, and fog can block the way
			query.exclude = [body, p]
			
			var result := state.intersect_ray(query)
			if !result.is_empty():
				continue
			
			if p != current_target:
				print(self, " aquiring target ", p)
			current_target = p
			target_found = true
			break
	
	if !target_found:
		#print(self, " lost eyes on target ", current_target)
		current_target = null
	
	if current_target != null and old_target == null:
		#print(current_target, ", ", old_target)
		fire_timer.start()
	elif current_target == null:
		fire_timer.stop()

func _physics_process(delta: float) -> void:
	if current_target:
		anger += delta
		if anger > anger_max:
			anger = anger_max
	else:
		anger -= delta
		if anger < 0.0:
			anger = 0.0
	
	anger_animator.speed_scale = lerpf(0.0, anger_anim_max, anger / anger_max)
	
	#print(fire_timer.time_left)

func _on_process_fire():
	#fire the cube's "gun" vaguely in the direction of the player
	#print(self, " is shooting at ", current_target, "!")
	
	var fire_rate := lerpf(base_fire_rate, fire_rate_max, anger / anger_max)
	fire_timer.wait_time = 1.0 / fire_rate
	
	if current_target:
		var bv := current_target.global_position - body.global_position
		if bv.length() < min_target_distance:
			body.apply_central_force(bv.reflect(Vector3.UP).normalized() * fear_force)
			anger *= 0.5
			return
		
		var d:Vector3 = emitter.global_position.direction_to(current_target.global_position)
		
		emitter.set("direction", emitter.global_basis.inverse() * d)
		emitter.call_deferred("_on_bullet_time")
