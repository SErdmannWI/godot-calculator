extends Node2D

var prompt_buffer: String = ""
var buffer_number: String = ""
var buffer_value: float = 0.0
var is_powered_on: bool = false
var buffer_number_complete: bool = false

# Buttons
@onready var upper_button_grid_container: GridContainer = %UpperButtonGridContainer
@onready var left_button_grid_container: GridContainer = %LeftButtonGridContainer
@onready var central_button_grid_container: GridContainer = %CentralButtonGridContainer
@onready var right_button_grid_container: GridContainer = %RightButtonGridContainer

# Display
@onready var display: Display = %Display



func _ready() -> void:
	for child: Button in upper_button_grid_container.get_children():
		child.button_down.connect(_on_button_pressed.bind(child))
	
	for child: Button in central_button_grid_container.get_children():
		child.button_down.connect(_on_button_pressed.bind(child))
	
	for child: Button in left_button_grid_container.get_children():
		child.button_down.connect(_on_button_pressed.bind(child))
	
	for child: Button in right_button_grid_container.get_children():
		child.button_down.connect(_on_button_pressed.bind(child))


###################################################################################################
########################################### UI Functions ##########################################
###################################################################################################


func _on_button_pressed(button: Button) -> void:
	display.clear_error()
	is_powered_on = true
	
	var value: String = ""
	
	if button.has_meta("Operator"):
		value = button.get_meta("Operator")
	else:
		value = button.text
	
	# Add next digit onto buffer number, if button is number
	# TODO- separate functions between numbers and operators
	if button.is_in_group(Constants.GROUP_NAME_NUMBER_BUTTONS):
		_on_number_button_pressed(value)

	if button.is_in_group(Constants.GROUP_NAME_OPERATOR_BUTTONS):
		_add_to_prompt(value)
	
	if button.is_in_group(Constants.GROUP_NAME_FUNCTION_BUTTONS):
		_on_function_button_pressed(value)
	
	if not (button.is_in_group(Constants.GROUP_NAME_NUMBER_BUTTONS) or button.is_in_group(Constants.GROUP_NAME_FUNCTION_BUTTONS)
	or button.is_in_group(Constants.GROUP_NAME_OPERATOR_BUTTONS)):
		var error: CalculatorError = CalculatorError.new(Constants.ERROR_NAME_INVALID_BUTTON, Constants.ERROR_DESC_INVALID_BUTTON % value)
		display.on_error(error)


func _on_number_button_pressed(value: String) -> void:
	if !buffer_number_complete:
		buffer_number += value


func _add_to_prompt(value: String) -> void:
	print("Buffer: %s" % prompt_buffer)
	prompt_buffer += value
	display.update_prompt(prompt_buffer)


func _on_function_button_pressed(value: String) -> void:
	print("Function pressed: %s" % value)
	if is_powered_on:
		match value:
			"POWER":
				if is_powered_on:
					display.power_off()
				else:
					display.power_on()
			"Mode":
				_on_mode_pressed()
			"=":
				print("Equals")
				_on_equals()
			"Clear":
				_on_clear_pressed()
			_:
				print(value)


###################################################################################################
########################################## Math Functions #########################################
###################################################################################################
func _on_equals() -> void:
	var expression = Expression.new()
	print("Parsing expression: %s" % prompt_buffer)
	var error = expression.parse(prompt_buffer)
	
	if error != OK:
		var description: String = "Expression could not be parsed: %s" % prompt_buffer
		var parse_error: CalculatorError = CalculatorError.new(error, description)
		
		display.on_error(parse_error)
		return
	
	var result = expression.execute()
	print("Result: %s" %result)
	
	if not expression.has_execute_failed():
		print("Printing result")
		display.display_result(result)
	else:
		print("Execute failed")


###################################################################################################
######################################## Utility Functions ########################################
###################################################################################################

func _on_clear_pressed() -> void:
	prompt_buffer = ""
	display.clear_display()


func _on_mode_pressed() -> void:
	get_tree().change_scene_to_file(FilePaths.SCENE_PATH_CALCULATOR)
