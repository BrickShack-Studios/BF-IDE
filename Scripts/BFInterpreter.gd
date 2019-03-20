extends Node

class_name BFInterpreter

var ram     := [0]
var ramPtr  := 0
var codePtr := 0

onready var codeText     := $GUI/Window/IO/CodeBox as TextEdit
onready var outputText   := $GUI/Window/IO/RightPane/Output as TextEdit
onready var charText     := $GUI/Window/IO/RightPane/CharEntry/CharEnter as LineEdit

onready var loadDialogue := $GUI/CenterContainer/LoadFile as FileDialog
onready var saveDialogue := $GUI/CenterContainer/SaveFile as FileDialog

onready var aboutPopup   := $GUI/CenterContainer/About as AcceptDialog

onready var exportC      := $GUI/CenterContainer/ExportC as FileDialog

# Resets all values in the interpreter back to a clean slate
func reset() -> void:
	ramPtr = 0
	codePtr = 0
	
	for i in range(65535):
		ram[i] = 0
	
	outputText.text = ""
	
	return

func _ready() -> void:
	for i in range(65535):
		ram.append(0)
	
	return

# Displays a section of RAM
func printRamUpTo(n : int) -> void:
	var string := ""
	for i in range(n):
		string += str(ram[i]) + ' '
	
	print(string)
	return

# Runs a BF program encoded as a string
func run(program : String) -> void:
	while (codePtr < len(program)):
		match program[codePtr]:
			' ': pass
			'\n': pass
			'\t': pass
			
			'>':
				ramPtr += 1
			'<':
				ramPtr -= 1
			
			'+':
				ram[ramPtr] += 1
			'-':
				ram[ramPtr] -= 1
			
			'.':
				outputText.text += fromASCII(ram[ramPtr])
			',':
				codePtr += 1
				charText.text = "Enter a character!"
				return
				
			'[':
				if (ram[ramPtr] == 0):
					var brackets := 0
					while (codePtr < len(program)):
						codePtr += 1
						
						match program[codePtr]:
							'[':
								brackets += 1
							']':
								if (brackets == 0):
									break
								else:
									brackets -= 1
							_: pass
			']':
				if (ram[ramPtr] != 0):
					var brackets := 0
					while (codePtr >= 0):
						codePtr -= 1
						
						match program[codePtr]:
							']':
								brackets += 1
							'[':
								if (brackets == 0):
									break
								else:
									brackets -= 1
							_: pass
			
			var ins:
				pass #print("Warning: " + ins + " is an unsupported instruction!")
		
		codePtr += 1
	
	print("Program completed")
	return

func fromASCII(n : int) -> String:
	return PoolByteArray([n]).get_string_from_ascii()[0]

func toASCII(chr : String) -> int:
	return chr[0].to_ascii()[0]

func _on_RunCode_pressed() -> void:
	reset()
	run(codeText.text)
	return


func _on_CharButton_pressed() -> void:
	ram[ramPtr] = toASCII(charText.text[0])
	run(codeText.text)
	return


func _on_File_optionPressed(ID : String) -> void:
	match ID:
		"open":
			loadDialogue.popup()
		"saveAs":
			saveDialogue.popup()
	return

func _on_Build_optionPressed(ID : String) -> void:
	match ID:
		"transpileC":
			exportC.popup()
	
	return

func _on_Help_optionPressed(ID : String) -> void:
	match ID:
		"about":
			aboutPopup.popup()
		_: pass
	return

func _on_LoadFile_file_selected(path : String) -> void:
	var file := File.new()
	file.open(path, File.READ)
	codeText.text = file.get_as_text()
	file.close()

	return


func _on_SaveFile_file_selected(path : String) -> void:
	var file := File.new()
	file.open(path, File.WRITE)
	file.store_string(codeText.text)
	file.close()
	
	return


func _on_ExportC_file_selected(path : String) -> void:
	var results  := "#include <stdio.h>\nint main(){char arr[10000]={0};char* ptr=arr;"
	var contents := codeText.text
	var pos      := 0
	
	while (pos < len(contents)):
		match contents[pos]:
			">": results += "++ptr;"
			"<": results += "--ptr;"
			"+": results += "++*ptr;"
			"-": results += "--*ptr;"
			".": results += "putchar(*ptr);"
			",": results += "*ptr=getchar();"
			"[": results += "while(*ptr){"
			"]": results += "}"
			_  : pass
		
		pos += 1
	
	results += "return 0;}"
	
	var file := File.new()
	file.open(path, File.WRITE)
	file.store_string(results)
	file.close()
	
	return
