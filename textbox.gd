extends Control

@onready var label = $MarginContainer/textbox/Label
@onready var timer = $letterDisplayTimer

const MAX_WIDTH = 872

var text = ""
var letterIndex = 0
var letterTime = 0.03
var spaceTime = 0.03
var punctuationTime = 0.02

signal finishedDisplaying()

func displayText(textToDisplay: String):
	text = textToDisplay
	label.text = textToDisplay
	label.text = ""
	displayLetter()
	
	
func displayLetter():
	label.text += text[letterIndex]
	letterIndex = letterIndex + 1

	if letterIndex >= text.length():
		finishedDisplaying.emit()
		return
		
	match text[letterIndex]:
		"!", ".", ",", "?":
			timer.start(punctuationTime)
		" ":
			timer.start(spaceTime)
		_:
			timer.start(letterTime)

func _on_letter_display_timer_timeout():
	displayLetter()

