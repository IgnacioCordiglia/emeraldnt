extends CanvasLayer

class_name main

@export var dialogueJson : JSON
@onready var state = {}
@onready var viewportDialogue = $UIContainer



func _ready():
	viewportDialogue.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func dialogueBoxRequested(): 
	viewportDialogue.visible = true
