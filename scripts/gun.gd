extends Node

@export var ammo_depletion_rate := 10
@export var ammo_bank:Range
@export var emitters:Array[Node]

var firing := false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("fire") and ammo_bank.value > 0.0:
		firing = true
		ammo_bank.value -= ammo_depletion_rate * delta
	else:
		firing = false
	update_emitters()

func update_emitters():
	if firing:
		for e in emitters:
			e.process_mode = Node.PROCESS_MODE_INHERIT
	else:
		for e in emitters:
			e.process_mode = Node.PROCESS_MODE_DISABLED
