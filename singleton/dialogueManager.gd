extends Node

@onready var textBoxScene = preload("res://textbox.tscn")

var dialogueLines: Array[String] = []
var currentLineIndex = 0
var textbox
var isDialogueActive = false
var canAdvanceLine = false

signal interactionFinished()

func startDialogue(lines: Array[String]):
	if isDialogueActive:
		return
	
	dialogueLines = lines
	showTextbox()
	isDialogueActive = true
	
	
func showTextbox():
	textbox = textBoxScene.instantiate()
	textbox.finishedDisplaying.connect(onTextBoxFinishedDisplaying)
	get_tree().root.add_child(textbox)
	textbox.displayText(dialogueLines[currentLineIndex])
	canAdvanceLine = false
	
func onTextBoxFinishedDisplaying():
	canAdvanceLine = true
	
func _unhandled_input(event):
	
	if (
		event.is_action_pressed("advanceDialogue") && isDialogueActive && canAdvanceLine
	):
		textbox.queue_free()
		

		currentLineIndex += 1
	
		if currentLineIndex >= dialogueLines.size():
			isDialogueActive = false
			currentLineIndex = 0
			interactionFinished.emit()
			return
		
		showTextbox()

