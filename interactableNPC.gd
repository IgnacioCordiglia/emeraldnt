extends Node3D

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
	
func handleIdleAnimation(dir):
	match dir:
		Vector3.LEFT:
			$AnimatedSprite3D.play("idleSideways")
			$AnimatedSprite3D.flip_h = false
		Vector3.RIGHT:
			$AnimatedSprite3D.play("idleSideways")
			$AnimatedSprite3D.flip_h = true
		Vector3.BACK:
			$AnimatedSprite3D.play("idle")
		Vector3.FORWARD:
			$AnimatedSprite3D.play("idleBackwards")

func handleWalkingAnimation(dir):
	match dir:
		Vector3.LEFT:
			$AnimatedSprite3D.play("walkSideways")
			$AnimatedSprite3D.flip_h = false
		Vector3.RIGHT:
			$AnimatedSprite3D.play("walkSideways")
			$AnimatedSprite3D.flip_h = true
		Vector3.BACK:
			$AnimatedSprite3D.play("walk")
		Vector3.FORWARD:
			$AnimatedSprite3D.play("walkBackwards")

func _on_timer_timeout():
	$Timer.wait_time = 1
	currentState = choose([IDLE, NEW_DIR, MOVE])
	
func interaction():
	$DialogueBox.
