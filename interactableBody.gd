extends CharacterBody3D

class_name detectableBody

@onready var nodo = get_parent().get_parent()

func inRangeToInteract():
	nodo.inRangeToInteract()

func noLongerInRange():
	nodo.noLongerInRange()

