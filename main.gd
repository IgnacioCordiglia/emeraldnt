extends CanvasLayer

class_name main

@export var dialogueJson : JSON
@onready var state = {}
@onready var dialogueBox = $UIContainer/dialogueViewport/dialogueBoxContainer/textbox



func _ready():
	dialogueBox.visible = false


func dialogueBoxRequested(dialogNodeName: String): 
	($EzDialogue as EzDialogue).start_dialogue(dialogueJson,state,dialogNodeName)
	dialogueBox.visible = true
	
func dialogueBoxFinished():
	dialogueBox.displayText("")
	dialogueBox.visible = false

func _on_ez_dialogue_dialogue_generated(response):
	dialogueBox.displayText(response.text)
