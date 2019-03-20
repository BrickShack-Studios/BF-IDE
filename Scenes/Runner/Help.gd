extends MenuButton

onready var menu := get_popup() as PopupMenu

signal optionPressed

func _ready() -> void:
	#menu.add_item("Tutorial")
	#menu.add_item("Example Programs")
	menu.add_item("About")
	
	menu.connect("id_pressed", self, "_on_item_pressed")
	return

func _on_item_pressed(ID : int) -> void:
	match ID:
		0: # Other features unimplemented
			emit_signal("optionPressed", "about")#emit_signal("optionPressed", "tutorial")
		1:
			emit_signal("optionPressed", "examplePrograms")
		2:
			emit_signal("optionPressed", "about")
		var id:
			print("Error: " + str(id) + " is an unknown option. How did you click that?")
	return