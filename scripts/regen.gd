extends Range

@export var points := 1.0
@export var frequency := 1.0

var time_since_last_regen := 0.0

func _process(delta: float) -> void:
	time_since_last_regen += delta
	if time_since_last_regen > frequency:
		value += points
		time_since_last_regen = 0.0
