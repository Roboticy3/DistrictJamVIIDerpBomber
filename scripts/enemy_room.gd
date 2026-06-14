extends Area3D

#look for enemy bodies and repeat the count to a ui element
#when no enemies are left, emit a signal.

var critters:Array[Node] = []
var registered := false
signal completed

# Called when the node enters the scene tree for the first time.
func _physics_process(delta: float) -> void:
	if !critters.is_empty():
		registered = true
		set_physics_process(false)
		print("enemy room ", self, " registered enemies ", critters)
		return
	for b in get_overlapping_bodies():
		critters.push_back(b)
	

func _process(delta: float) -> void:
	var complete := registered
	for b in critters:
		if is_instance_valid(b):
			complete = false
		if !complete:
			break
	
	if complete:
		print("completing enemy room ", self)
		completed.emit()
		RewardComplex.reward()
		queue_free()
