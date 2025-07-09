extends "res://Player/states.gd"

func enter():
	player.animated.play("Idle")

func update(delta):
	if not player.is_on_floor():
		player.change_state("JumpState")
	elif Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		player.change_state("RunState")
