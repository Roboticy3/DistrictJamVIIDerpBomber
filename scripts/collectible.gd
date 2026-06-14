extends Area3D

@export var tag := "gold_key"
@export var body:Node3D
@export var model:Node3D

func _ready():
	body_entered.connect(collect)

func collect(to):
	body.queue_free()
	var tag_set = to.get("collectibles")
	if tag_set is PackedStringArray:
		tag_set.push_back(tag)
		print("found item ", tag, " total: ", to.get("collectibles"))
	var visual = to.get("collectibles_visual")
	if visual is Node3D:
		model.transform = Transform3D()
		model.reparent(visual)
