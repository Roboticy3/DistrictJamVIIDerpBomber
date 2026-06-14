extends Node

@export var level:PackedScene
@export var load_scene:PackedScene
@export var preload_level := true

var instance:Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if preload_level:
		load_level()

func load_level():
	print("summoning loader")
	var loading := load_scene.instantiate()
	await get_tree().process_frame
	get_tree().root.add_child(loading)
	
	print("loading level")
	instance = level.instantiate()
	
	await get_tree().process_frame
	
	loading.queue_free()
	print("done loading, removing loader")

func mount_level():
	if !instance:
		await load_level()
	
	get_tree().change_scene_to_node(instance)
