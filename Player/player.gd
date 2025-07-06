# player.gd (на CharacterBody2D)
extends CharacterBody2D

@onready var animated = $AnimatedSprite2D

# швидкість руху
const SPEED = 200
# сила стрибка
const JUMP_VELOCITY = -400
# гравітація
const GRAVITY = 1200



func _physics_process(delta):
	# Горизонтальний рух (ліва/права)
	var direction = 0
	var state = ""

	
	if Input.is_action_pressed("move_left"):
		direction -= 1
	if Input.is_action_pressed("move_right"):
		direction += 1

	
	
	if direction < 0:
		animated.flip_h = true
	elif direction > 0:
		animated.flip_h = false
	
	velocity.x = direction * SPEED
	
	
	# Стрибок
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			velocity.y = JUMP_VELOCITY
	else:
		# Додаємо гравітацію
		velocity.y += GRAVITY * delta
	
	# Вибір анімації
	if not is_on_floor():
		state = "Jump"
	elif direction != 0:
		state = "Run"
	else:
		state = "Idle"
		
	# Програвання анімації лише при зміні
	if animated.animation != state:
		animated.play(state)
	
	print(state)
	# Застосовуємо рух
	self.velocity = velocity
	move_and_slide()
