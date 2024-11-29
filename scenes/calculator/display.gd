class_name Display
extends MarginContainer

var all_labels: Array[Node] = []

@onready var mode_label: Label = %ModeLabel
@onready var pos_neg_label: Label = %PosNegLabel
@onready var warn_label: Label = %WarnLabel
@onready var instruction_label: Label = %InstructionLabel
@onready var center_result_label: Label = %CenterResultLabel
@onready var prompt_line_edit: LineEdit = %PromptLineEdit
@onready var type_label_left: Label = %TypeLabelLeft
@onready var type_label_middle: Label = %TypeLabelMiddle
@onready var type_label_right: Label = %TypeLabelRight
@onready var aux_label_middle: Label = %AuxLabelMiddle
@onready var aux_label_bottom: Label = %AuxLabelBottom


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	all_labels = get_tree().get_nodes_in_group("DisplayLabels")
	
	power_on()


###################################################################################################
########################################## Math Functions #########################################
###################################################################################################

func display_result(result) -> void:
	center_result_label.text = str(result)


func update_prompt(prompt: String) -> void:
	prompt_line_edit.text = prompt
	prompt_line_edit.caret_column = prompt.length()


###################################################################################################
######################################## Utility Functions ########################################
###################################################################################################

func power_off() -> void:
	for label: Label in all_labels:
		label.text = ""
	
	prompt_line_edit.editable = false


func power_on() -> void:
	clear_display()
	
	instruction_label.text = "Choose mode"
	center_result_label.text = "0"
	prompt_line_edit.editable = true


func clear_display() -> void:
	for label in all_labels:
		label.text = ""
	
	instruction_label.text = "Enter Prompt"
	center_result_label.text = "0"
	prompt_line_edit.text = ""


func on_error(error: CalculatorError) -> void:
	instruction_label.text = error.error_name
	center_result_label.text = error.error_desc
	warn_label.text = "Err"


func clear_error() -> void:
	instruction_label.text = "Enter Prompt"
	center_result_label.text = "0"
	warn_label.text = ""
