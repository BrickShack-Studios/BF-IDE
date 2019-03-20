extends MenuButton

onready var menu := get_popup() as PopupMenu

signal optionPressed

func _ready() -> void:
	menu.add_item("Open")
	menu.add_item("Save As")
	
	menu.connect("id_pressed", self, "_on_item_pressed")
	return

func _on_item_pressed(ID : int) -> void:
	match ID:
		0:
			emit_signal("optionPressed", "open")
		1:
			emit_signal("optionPressed", "saveAs")
		var id:
			print("Error: " + str(id) + " is an unknown option. How did you click that?")
	return