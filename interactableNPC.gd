extends Node3D

class_name interactableNPC

enum {
	IDLE,
	NEW_DIR,
	MOVE,
	TALK
}

const lines : Array[String] = [
	"If you use a PC, you can store items 
	and POKéMON",
	"The power of science is staggering!"
]

const speed = 3
var currentState = IDLE
var dir = Vector3.FORWARD
var startPos
var interactable = false
@onready var characterAnimations : AnimatedSprite3D = $body
@onready var speechBubbleAnimation : AnimatedSprite3D = $interactableBox

func _ready():
	randomize()
	startPos = position

func  _physics_process(delta):
	
	match currentState:
		IDLE:
			handleIdleAnimation(dir)
			pass
		NEW_DIR:
			dir = choose([Vector3.LEFT, Vector3.RIGHT, Vector3.FORWARD, Vector3.BACK])
		MOVE:
			move(delta)
			var movement = move(delta)
			if movement == true:
				handleWalkingAnimation(dir)
			else: currentState = IDLE
		TALK:
			currentState = IDLE

func move(delta):
	var validMovement = true
	
	position += dir * speed * delta
	
	if position.x >= startPos.x + 3.00001:
		currentState = IDLE
		position.x = startPos.x + 3
		validMovement = false
	elif position.x <= startPos.x - 3.00001:
		currentState = IDLE
		position.x = startPos.x - 3
		validMovement = false
	elif position.z >= startPos.z + 3.00001:
		currentState = IDLE
		position.z = startPos.z + 3
		validMovement = false
	elif position.z <= startPos.z - 3.00001:
		currentState = IDLE
		position.z = startPos.z - 3
		validMovement = false
		
	return validMovement

func choose(array):
	array.shuffle()
	return array.front()
	
func handleIdleAnimation(dire):
	match dire:
		Vector3.LEFT:
			characterAnimations.play("idleSideways")
			characterAnimations.flip_h = false
		Vector3.RIGHT:
			characterAnimations.play("idleSideways")
			characterAnimations.flip_h = true
		Vector3.BACK:
			print("bro is playing the back animation")
			characterAnimations.play("idle")
		Vector3.FORWARD:
			characterAnimations.play("idleBackwards")

func handleWalkingAnimation(dire):
	match dire:
		Vector3.LEFT:
			characterAnimations.play("walkSideways")
			characterAnimations.flip_h = false
		Vector3.RIGHT:
			characterAnimations.play("walkSideways")
			characterAnimations.flip_h = true
		Vector3.BACK:
			characterAnimations.play("walk")
		Vector3.FORWARD:
			characterAnimations.play("walkBackwards")

func _on_timer_timeout():
	$Timer.wait_time = 1
	currentState = choose([IDLE, NEW_DIR, MOVE])
	
func inRangeToInteract():
	interactable = true
	speechBubbleAnimation.visible = true
	speechBubbleAnimation.play("appear")
	
func noLongerInRange():
	interactable = false
	speechBubbleAnimation.play("disappear")
		
func interactedWith(facing):
	if interactable:
		currentState = TALK
		interactable = false
		handleFacingPlayer(facing)
		DialogueManager.startDialogue(lines)
		DialogueManager.interactionFinished.connect(onInteractionFinished)
		$Timer.stop()
		
		
		
func onInteractionFinished():
	$Timer.start()
	currentState = IDLE
	
func handleFacingPlayer(facing):
	print(facing)
	match facing:
		0:
			print("bro should be looking backwards")
			dir = Vector3.FORWARD
		1:
			dir = Vector3.RIGHT
		2:
			dir = Vector3.BACK
		3:
			dir = Vector3.LEFT
			
