extends Node2D

@export var dialogueJson: JSON
@onready var state = {}

func _ready():
	($EzDialogue as EzDialogue).start_dialogue(dialogueJson, state)

# Called when the node enters the scene tree for the first time.
func addText(text: String):
	$VBoxContainer/Text.text = text
	pass
	
func addChoice(text: String):
	pass


func _on_ez_dialogue_dialogue_generated(response):
	addText(response.text)
	
