extends CanvasLayer

@export var mouse_sensitivity_slider:Range
@export var affect_mouse_mode := true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	open()
	close()
	
	mouse_sensitivity_slider.value_changed.connect(_on_sensitivity_slider_changed)
	

func open() -> void:
	print("opening settings")
	visible = true
	
	if affect_mouse_mode: Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	Engine.time_scale = 0.0

func close() -> void:
	print("closing setting")
	var tween := create_tween()
	tween.set_ignore_time_scale(true)
	tween.tween_property(Engine, "time_scale", 1.0, 1.0)
	
	visible = false
	if affect_mouse_mode: Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event:InputEvent):
	if event.is_action_pressed("ui_cancel") and event.is_pressed():
		if visible:
			close()
		else:
			open()

func _on_sensitivity_slider_changed(new_value:float):
	SettingsStore.mouse_sensitivity = new_value * 0.0015
