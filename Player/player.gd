# player.gd (на CharacterBody2D)
extends CharacterBody2D

@onready var animated = $AnimatedSprite2D
@onready var states_container = $States

const SPEED = 200
const JUMP_VELOCITY = -400
const GRAVITY = 1200

var current_state
var states = {}

var health = 100 
var gold = 0


func _ready():
	# Підключаємо всі стани
	for state in states_container.get_children():
		if state is State:
			states[state.name] = state
			state.player = self
	change_state("IdleState")


func change_state(state_name: String):
	if current_state:
		current_state.exit()
	current_state = states.get(state_name)
	if current_state:
		current_state.enter()


func _physics_process(delta):
	# Гравітація
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	else:
		velocity.y = 0  # скидаємо вертикальну швидкість на підлозі

	current_state.update(delta)
	
	print(current_state)
	move_and_slide()

	if health <= 0:
		queue_free()
		get_tree().change_scene_to_file("res://menu.tscn")
