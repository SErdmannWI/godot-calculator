extends Node2D

var prompt_display_text: String = ""

# Display
@onready var function_label: Label = %FunctionLabel
@onready var pos_neg_label: Label = %PosNegLabel
@onready var warn_label: Label = %WarnLabel
@onready var upper_result_label: Label = %UpperResultLabel
@onready var center_result_label: Label = %CenterResultLabel
@onready var prompt_label: RichTextLabel = %PromptLabel
@onready var label_1: Label = %Label
@onready var label_2: Label = %Label2
@onready var label_3: Label = %Label3
@onready var label_4: Label = %Label4
@onready var label_5: Label = %Label5


@onready var upper_button_grid_container: GridContainer = %UpperButtonGridContainer
@onready var central_button_grid_container: GridContainer = %CentralButtonGridContainer2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_clear_display()
	
	for child: Button in upper_button_grid_container.get_children():
		child.pressed.connect(_on_button_pressed.bind(child))
	
	for child: Button in central_button_grid_container.get_children():
		child.pressed.connect(_on_button_pressed.bind(child))

func _on_button_pressed(button: Button) -> void:
	var value: String = ""
	value = button.text
	
	if button.is_in_group(Constants.GROUP_NAME_TEXT_BUTTONS):
		_on_text_button_pressed(value)
	elif button.is_in_group(Constants.GROUP_NAME_FUNCTION_BUTTONS):
		_on_function_button_pressed(value)
	else:
		on_error("Invalid Button")


func _on_text_button_pressed(value: String) -> void:
	prompt_display_text = prompt_label.text + value
	prompt_label.text = "[right]%s[/right]" % prompt_display_text


func _on_function_button_pressed(value: String) -> void:
	pass


func on_error(error: String) -> void:
	warn_label.text = "ERR"
	center_result_label.text = error


func _clear_display() -> void:
	function_label.text = ""
	pos_neg_label.text = ""
	warn_label.text = ""
	upper_result_label.text = ""
	center_result_label.text = "0"
	prompt_label.text = ""
	label_1.text = ""
	label_2.text = ""
	label_3.text = ""
	label_4.text = ""
	label_5.text = ""



func _power_off() -> void:
	pass


func _power_on() -> void:
	pass
