extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var Sprite: Sprite2D = $Sprite2D
@onready var animationPlayer = $AnimationPlayer
@onready var anim_tree: AnimationTree = $AnimationTree

var StateMachine

var is_attacking: bool = false
var attack_timer: float = 0.0

func _ready():
	anim_tree.active = true
	StateMachine = anim_tree.get("parameters/playback")
	animationPlayer.animation_finished.connect(_on_animation_finished)

func _physics_process(delta: float) -> void:
	# 1. Saut — toujours vérifié en premier
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# 2. Gravité
	if not is_on_floor():
		velocity += get_gravity() * delta

	# 3. Attaque — fonctionne au sol ET en l'air
	if is_attacking:
		attack_timer -= delta
		if attack_timer <= 0.0:
			is_attacking = false
			StateMachine.travel("Idle")
		# On garde la gravité et on permet un léger contrôle horizontal
		var dir_air := Input.get_axis("move_left", "move_right")
		if dir_air:
			velocity.x = dir_air * SPEED * 0.5
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
		move_and_slide()
		return

	if Input.is_action_just_pressed("attack"):
		StateMachine.travel("Attack")
		is_attacking = true
		attack_timer = animationPlayer.get_animation("Attack").length
		move_and_slide()
		return

	# 4. Déplacement horizontal
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	Sprite.flip_h = direction < 0

	# 5. Animation
	if not is_on_floor():
		print("Hop!")
	elif direction != 0:
		StateMachine.travel("Run")
	else:
		StateMachine.travel("Idle")

	move_and_slide()

func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Attack":
		is_attacking = false
		StateMachine.travel("Idle")
