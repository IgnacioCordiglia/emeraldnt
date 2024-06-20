extends Node

@onready var textBoxScene = preload("res://textbox.tscn")

var dialogueLines: Array[String] = []
var currentLineIndex = 0
var textbox
var isDialogueActive = false
var canAdvanceLine = false

func startDialogue(lines: Array[String]):
	if isDialogueActive:
		return
		
	dialogueLines = lines
	
	showTextBox()
	
	isDialogueActive = true
	
	
func showTextBox():
	textbox = textBoxScene.instantiate()
	textbox.finished_displaying.connect(onTextBoxFinishedDisplaying)
	get_tree().root.add_child(textbox)
	
	
