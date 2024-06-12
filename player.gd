extends CharacterBody3D

@export var animationFrame = 0

var SPEED
var direction
var facing = 0

func _physics_process(delta):
	var isRunning
	if Input.is_action_pressed("running"):
		SPEED = 35.0
		isRunning = 1
	else: 
		SPEED = 15.0 
		isRunning = 0
	
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	var directionV2 = Vector2(direction.x,direction.z)
	handle_movement_animation(directionV2, isRunning)
	move_and_slide()


func handle_movement_animation(direction, running):
	
	if direction == Vector2(0,0) && $AnimationPlayer.is_playing() == true:
		$AnimationPlayer.stop()
		animationFrame = 1
	else: $AnimationPlayer.play("walk")
	
	if direction.y  > 0: #Abajo
		facing = 0
	elif direction.y < 0: #Arriba
		facing = 2
	elif direction.x == 1: #Derecha
		facing = 3
	elif direction.x == -1: #Izquierda
		facing = 1
	
	const FRAMES = 3
	
	print(animationFrame + (facing * FRAMES) + (running*11))
	$Sprite3D.frame = animationFrame + (facing * FRAMES) + (running*12)
