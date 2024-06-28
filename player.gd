extends CharacterBody3D

@export var animationFrame = 0
var SPEED
var canMove : bool = true
var direction
var facing = 0
var canInteract : bool = false
var bodyInRangeToInteractWith : detectableBody = null
@onready var raycast : RayCast3D = $RayCast3D
@onready var walkingSound : AudioStreamPlayer3D = $playerSounds/walkingSound
@onready var runningSound : AudioStreamPlayer3D = $playerSounds/runningSound

enum {
	DOWN = 0,
	LEFT = 1,
	UP = 2,
	RIGHT = 3
}

func _physics_process(delta):
	var isRunning
	if raycast.is_colliding() && bodyInRangeToInteractWith == null && raycast.get_collider().get_class() == "CharacterBody3D" :
		bodyInRangeToInteractWith = raycast.get_collider()
		inInteractionRange(bodyInRangeToInteractWith)
		canInteract = true
	elif !raycast.is_colliding() && bodyInRangeToInteractWith != null:
		noLongerInInteractionRange()
		canInteract = false
		
	if(canInteract && Input.is_action_pressed("interact")):
		interact(bodyInRangeToInteractWith)
		
	if Input.is_action_pressed("running"):
		SPEED = 12.0
		isRunning = 1
	else: 
		SPEED = 7.0 
		isRunning = 0
	
	var direction
	
	if(isMovementEnabled()):
		var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	else: direction = Vector3(0,0,0)

	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		isRunning = 0
		
	var	directionV2 = Vector2(direction.x,direction.z)
	
	handle_movement_animation(directionV2, isRunning)
	move_and_slide()

func handle_movement_animation(direction, running):
	if direction == Vector2(0,0) && $AnimationPlayer.is_playing() == true:
		$AnimationPlayer.stop()
		animationFrame = 1
	
	if running == 1: 
		$AnimationPlayer.play("run")
	elif running == 0:
		$AnimationPlayer.play("walk")
	
	if direction.y  > 0 && abs(direction.y) >= abs(direction.x): #DOWN
		facing = DOWN
		raycast.rotation_degrees = Vector3(0, -90, 0)
	elif direction.y < 0 && abs(direction.y) >= abs(direction.x): #UP
		facing = UP
		raycast.rotation_degrees = Vector3(0, 90, 0)
	elif direction.x > 0 && abs(direction.y) <= abs(direction.x): #RIGHT
		facing = RIGHT
		raycast.rotation_degrees = Vector3(0, 0, 0)
	elif direction.x < 0 && abs(direction.y) <= abs(direction.x): #LEFT
		facing = LEFT
		raycast.rotation_degrees = Vector3(0, 180, 0)
	
	const FRAMES = 3
	
	$Sprite3D.frame = animationFrame + (facing * FRAMES) + (running*12)
	
	
func inInteractionRange(collider : detectableBody) :
	collider.inRangeToInteract()
	
func playRunningSound():
	runningSound.pitch_scale = randf_range(0.8, 1.2)
	runningSound.play()
	
func playWalkingSound():
	walkingSound.pitch_scale = randf_range(0.8, 1.2)
	walkingSound.play()
	
func noLongerInInteractionRange() :
	bodyInRangeToInteractWith.noLongerInRange()
	bodyInRangeToInteractWith = null

func interact(collider : detectableBody):
	collider.interactedWith(facing)
	canMove = false
	canInteract = false
	Dialogic.signal_event.connect(newDialogicSignal)

func newDialogicSignal(arg: String):
	Dialogic.signal_event.disconnect(newDialogicSignal)
	canMove = true
	canInteract = true
	
func isMovementEnabled():
	return canMove
