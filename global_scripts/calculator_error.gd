class_name CalculatorError
extends Node

var error_name: String
var error_desc: String

func _init(name: String, description: String) -> void:
	error_name = name
	error_desc = description
