extends "res://Player/states.gd"

func enter():
	player.animated.play("Jump")
	player.velocity.y = player.JUMP_VELOCITY

func update(delta):
	# Не дозволяй стрибати знову в повітрі
	if player.is_on_floor():
		player.change_state("IdleState")
