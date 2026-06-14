extends Node

@export var ammo_depletion_rate := 10
@export var ammo_cost := 1
@export var ammo_bank:Range
@export var emitters:Array[Node]

@export var full_auto := true

var firing := false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var should_fire :=  false
	if full_auto:
		should_fire = Input.is_action_pressed("fire")
	else:
		should_fire = Input.is_action_just_pressed("fire")
	
	var has_ammo := !is_instance_valid(ammo_bank) or ammo_bank.value > 0.0 
	
	if should_fire and has_ammo:
		if full_auto:
			firing = true
			if is_instance_valid(ammo_bank):
				ammo_bank.value -= ammo_depletion_rate * delta
		else:
			for e in emitters:
				if is_instance_valid(e):
					e.call("_on_bullet_time")
			if is_instance_valid(ammo_bank):
				ammo_bank.value -= ammo_cost
		
	elif full_auto:
		firing = false
		
	if full_auto:
		update_emitters()

func update_emitters():
	if firing:
		for e in emitters:
			if !is_instance_valid(e):
				continue
			e.process_mode = Node.PROCESS_MODE_INHERIT
	else:
		for e in emitters:
			if !is_instance_valid(e):
				continue
			e.process_mode = Node.PROCESS_MODE_DISABLED
