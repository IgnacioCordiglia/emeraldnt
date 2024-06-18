extends Node3D

class_name interactableNPC

enum {
	IDLE,
	NEW_DIR,
	MOVE
}

const speed = 3
var currentState = IDLE
var dir = Vector3.FORWARD
var startPos

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
			$body.play("idleSideways")
			$body.flip_h = false
		Vector3.RIGHT:
			$body.play("idleSideways")
			$body.flip_h = true
		Vector3.BACK:
			$body.play("idle")
		Vector3.FORWARD:
			$body.play("idleBackwards")

func handleWalkingAnimation(dire):
	match dire:
		Vector3.LEFT:
			$body.play("walkSideways")
			$body.flip_h = false
		Vector3.RIGHT:
			$body.play("walkSideways")
			$body.flip_h = true
		Vector3.BACK:
			$body.play("walk")
		Vector3.FORWARD:
			$body.play("walkBackwards")

func _on_timer_timeout():
	$Timer.wait_time = 1
	currentState = choose([IDLE, NEW_DIR, MOVE])
	
	
func inRangeToInteract():
	$interactableBox.visible = true
	$interactableBox.play("appear")
	
func noLongerInRange():
	$interactableBox.visible = false

