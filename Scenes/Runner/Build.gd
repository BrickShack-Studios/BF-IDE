extends MenuButton

onready var menu := get_popup() as PopupMenu

signal optionPressed

func _ready() -> void:
	menu.add_item("Transpile to C")
	
	menu.connect("id_pressed", self, "_on_item_pressed")
	return

func _on_item_pressed(ID : int) -> void:
	match ID:
		0:
			emit_signal("optionPressed", "transpileC")
		var id:
			print("Error: " + str(id) + " is an unknown option. How did you click that?")
	return