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
	await resized
	
	custom_minimum_size.x = min(size.x, MAX_WIDTH)
	
	if size.x > MAX_WIDTH:
		label.autowrap_mode = TextServer.AUTOWRAP_WORD
		await resized
		await resized
		custom_minimum_size.y = size.y
		
	label.text = ""
	displayLetter()
	
	
func displayLetter():
	label.text += text[letterIndex]
	letterIndex+1
	
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

