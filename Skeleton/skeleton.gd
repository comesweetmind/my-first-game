extends CharacterBody2D

# Гравітація з глобальних налаштувань
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Швидкість пересування ворога
@export var speed := 100

# Чи ворог переслідує гравця
var chase := false

# Посилання на гравця
var player: Node2D


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
		var direction_x = sign(player.position.x - position.x)
		velocity.x = direction_x * speed
	else:
		velocity.x = 0

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
