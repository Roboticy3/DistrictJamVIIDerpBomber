extends Area3D

signal unlocked()

@export var item_needed := "gold_key"
@export var message:Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	var collectibles = body.get("collectibles")
	if collectibles is PackedStringArray:
		if collectibles.find(item_needed) != -1:
			unlocked.emit()
			queue_free()
		else:
			message.text = item_needed + " required..."

func _on_body_exited(body):
	var collectibles = body.get("collectibles")
	if collectibles is PackedStringArray:
		message.text = ""
