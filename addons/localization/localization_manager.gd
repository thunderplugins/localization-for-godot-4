extends Node

@export var separator: String = ";"
@export var languages: Array[Language]

@onready var os_locale = OS.get_locale()

var texts_arrays = []
var selected_language_position = -1
var default_language_position = 0

func _ready() -> void:
	# Split each texts into arrays and add them to the array of texts
	for language in languages:
		texts_arrays.append(language.texts.split(separator))
		
	# Automatically add the language
	if hasExactOSLanguage():
		selected_language_position = getLanguagePosition(os_locale)
	elif hasOSLanguage():
		selected_language_position = getLanguagePosition(os_locale)
	else:
		selected_language_position = 0

func translate() -> void:
	iterate_tree(get_parent())
	default_language_position = selected_language_position

func translateTo(string: String) -> void:
	# Force language and translate
	selected_language_position = getLanguagePosition(string)
	translate()

func iterate_tree(root: Node):
	# Check if text property exists in root
	if root.get("text") != null:
		# Iterates through each default text
		var default_text_position = -1
		for default_text in texts_arrays[default_language_position]:
			# Save the current position of the default text
			default_text_position += 1
			# Checks if the root text has that default text
			if default_text == root.text:
				root.text = texts_arrays[selected_language_position][default_text_position]
				
	# Iterate through its children
	for child in root.get_children():
		# Recursively call the function for each child node
		iterate_tree(child)

func translated(text: String):
	# Iterates through each default text
	var default_text_positon = -1
	for default_text in texts_arrays[0]:
		# Save the current position of the default text
		default_text_positon += 1
		# Checks if the root text has that default text
		if default_text == text:
			return texts_arrays[selected_language_position][default_text_positon]
	return text

func getLanguagePosition(string: String):
	for pos in languages.size():
		if string == languages[pos].locale:
			return pos 
	return 0

func hasExactOSLanguage():
	for language in languages:
		if os_locale in language.locale:
			return true
	return false

func hasOSLanguage():
	for language in languages:
		if language.locale in os_locale:
			return true
	return false

func hasLanguage(string: String):
	for language in languages:
		if string in language.locale:
			return true
	return false
