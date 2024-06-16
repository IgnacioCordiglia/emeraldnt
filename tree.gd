extends Node3D

@export var animationFrame = 0

func _physics_process(delta):
	$AnimationPlayer.play("wind")
	handle_animation()

func handle_animation():
	$Sprite3D.frame = animationFrame
