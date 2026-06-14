extends Node

@export var weapons:Array[Node]

var current_weapon := 0
func set_weapon(to:int):
	if weapons.is_empty():
		return
	
	to = to % weapons.size()
	current_weapon = to
	for w in weapons:
		w.set("visible", false)
		w.process_mode = Node.PROCESS_MODE_DISABLED
	
	var w := weapons[current_weapon]
	w.set("visible", true)
	w.process_mode = Node.PROCESS_MODE_INHERIT

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_weapon(0)

func next():
	set_weapon(current_weapon + 1)

func previous():
	set_weapon(current_weapon - 1)

func _input(event:InputEvent):
	if event.is_action_pressed("ars_down"):
		previous()
	elif event.is_action_pressed("ars_up"):
		next()
