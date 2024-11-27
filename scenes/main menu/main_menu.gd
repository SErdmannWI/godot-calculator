extends Node2D

@onready var button_open_calculator_button: Button = %OpenCalculatorButton
@onready var button_settings_button: Button = %SettingsButton
@onready var button_exit_button: Button = %ExitButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	button_exit_button.pressed.connect(_on_exit_pressed)
	button_open_calculator_button.pressed.connect(_on_open_calclulator_pressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_open_calclulator_pressed() -> void:
	get_tree().change_scene_to_file(FilePaths.SCENE_PATH_CALCULATOR)


func _on_settings_pressed() -> void:
	pass


func _on_exit_pressed() -> void:
	get_tree().quit()
