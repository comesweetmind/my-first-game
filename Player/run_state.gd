extends "res://Player/states.gd"

func enter():
	player.animated.play("Run")

func update(delta):
	var direction = 0
	if Input.is_action_pressed("move_left"):
		direction -= 1
	if Input.is_action_pressed("move_right"):
		direction += 1

	player.velocity.x = direction * player.SPEED
	player.animated.flip_h = direction < 0


	# Перехід у JumpState при стрибку
	if Input.is_action_just_pressed("jump"):
		player.change_state("JumpState")
	elif direction == 0:
		player.change_state("IdleState")
	elif not player.is_on_floor():
		player.change_state("JumpState")
