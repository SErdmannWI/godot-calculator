extends Node2D

# Math Functions
# Absolute Value- abs(x: Variant)
# Exponent- pow(base, exponent)
# Square Root- sqrt(x: float)
# Floating Point Remainder- fmod(x: float, y: float)
# Sine- sin(angle_rad: float)
# Cosine- cos(angle_rad: float)
# Tangent- tan(angle_rad: float)
# Arc Sine- asin(x: float)
# Arc Cosine- acos(x: float)
# Arc Tangent- atan(x: float)
# Arc Tangent Cartesian- atan2(y: float, x: float)
# Hyperbolic Sine- sinh(x: float)
# Hyperbolic Cosine- cosh(x: float)
# Hyperbolic Tangent- tanh(x: float)
# Inverse Hyp Sine- asinh(x: float)
# Inverse Hyp Cosine- acosh(x: float)
# Inverse Hyp Tangent- atanh(x: float)
# Euler's Exponent- exp(x: float)
# Logarithm- log(x: float)
# Degrees to Radians- deg_to_rad(deg: float)
# Radians to Degrees- rad_to_deg(rad: float)


var prompt_display_text: String = ""
var buffer_number: String = ""
var buffer_value: float = 0.0
var is_powered_on: bool = false
var buffer_number_complete: bool = false

var regex = RegEx.new()

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

# Button Containers
@onready var upper_button_grid_container: GridContainer = %UpperButtonGridContainer
@onready var left_button_grid_container: GridContainer = %LeftButtonGridContainer
@onready var central_button_grid_container: GridContainer = %CentralButtonGridContainer
@onready var right_button_grid_container: GridContainer = %RightButtonGridContainer


# Set up regex, reset display, connect buttons to functions
func _ready() -> void:
	regex.compile("\\[.*?\\]")
	
	_clear_display()
	_power_on()
	
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
	_clear_error()
	
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
	
	if not (button.is_in_group(Constants.GROUP_NAME_TEXT_BUTTONS) or button.is_in_group(Constants.GROUP_NAME_FUNCTION_BUTTONS)):
		_on_error("Invalid Button")


func _on_number_button_pressed(value: String) -> void:
	if !buffer_number_complete:
		buffer_number += value


func _add_to_prompt(value: String) -> void:
	prompt_display_text = prompt_label.text + value
	prompt_label.text = "[right]%s[/right]" % prompt_display_text
	print("Prompt = %s" % prompt_display_text)


func _on_function_button_pressed(value: String) -> void:
	if is_powered_on:
		match value:
			"POWER":
				if is_powered_on:
					_power_off()
				else:
					_power_on()
			"=":
				print("Equals")
				_on_equals()
			"%":
				_on_percentage()
			"Clear":
				_clear_display()
			_:
				print(value)


###################################################################################################
########################################## Math Functions #########################################
###################################################################################################


func _on_equals() -> void:
	# Remove BBCode tags
	var text_without_tags: String = regex.sub(prompt_display_text, "", true)
	
	var expression = Expression.new()
	var error = expression.parse(text_without_tags)
	
	if error != OK:
		print("Error")
		print(expression.get_error_text())
		return
	
	var result = expression.execute()
	print("Result: %s" %result)
	
	if not expression.has_execute_failed():
		print("Printing result")
		center_result_label.text = str(result)
	else:
		print("Execute failed")


# Get buffer number, apply percentage to that and get a value. Add value to prompt
func _on_percentage() -> void:
	var percentage = buffer_number
	
	


func _apply_percentage() -> float:
	return 0.0


###################################################################################################
######################################## Utility Functions ########################################
###################################################################################################


func _clear_display() -> void:
	function_label.text = ""
	pos_neg_label.text = ""
	warn_label.text = ""
	upper_result_label.text = ""
	center_result_label.text = "0"
	prompt_label.text = ""
	prompt_display_text = prompt_label.text
	label_1.text = ""
	label_2.text = ""
	label_3.text = ""
	label_4.text = ""
	label_5.text = ""


func _on_error(error: String) -> void:
	warn_label.text = "ERR"
	center_result_label.text = error


func _clear_error() -> void:
	warn_label.text = ""
	center_result_label.text = "0"


func _power_off() -> void:
	is_powered_on = false
	_clear_display()
	center_result_label.text = ""


func _power_on() -> void:
	is_powered_on = true
	_clear_display()
