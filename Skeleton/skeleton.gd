extends CharacterBody2D

# Гравітація з глобальних налаштувань
var gravity : float = ProjectSettings.get_setting("physics/2d/default_gravity")

# Швидкість пересування ворога
@export var speed := 100

# Чи ворог переслідує гравця
var chase := false

var alive = true
# Посилання на гравця
var player: Node2D

@onready var anim = $AnimatedSprite2D

func _ready() -> void:
	# Знаходимо гравця в дереві сцени
	player = get_node_or_null("../Player/Player")
	
	if player == null:
		push_warning("⚠️ Гравця не знайдено! Перевір шлях: ../Player/Player")


func _physics_process(delta: float) -> void:
	# Застосовуємо гравітацію, якщо не на землі
	if not is_on_floor():
		velocity.y += gravity * delta

	# Якщо гравця немає — не робимо нічого
	if player == null:
		return

	# Якщо гравець у зоні переслідування — рухаємось до нього
	if chase:
		var direction_x: float = sign(player.position.x - position.x)
		velocity.x = direction_x * speed
	else:
		velocity.x = 0


	if alive == true:
		if  velocity.x != 0:
			$AnimatedSprite2D.flip_h = velocity.x < 0
			anim.play("Run")
		else:
			anim.play("Idle")

	# Рух ворога
	move_and_slide()


# Сигнал входу гравця в зону детекції (Area2D → body_entered)
func _on_detector_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		chase = true


# Сигнал виходу гравця з зони детекції
func _on_detector_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		chase = false


func _on_death_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.velocity.y -= 200
		death()
		
func death ():
	alive = false
	anim.play("Hit")
	await anim.animation_finished
	queue_free()


func _on_death_2_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		if alive == true:
			body.health -=40
		death()
