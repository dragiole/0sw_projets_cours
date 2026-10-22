extends Node2D

@export var speed: float = 60.0
@export var flip_sprite_with_direction: bool = false

@onready var detecteurMur:      RayCast2D = $DetecteurMur
@onready var detecteurPlancher: RayCast2D = $DetecteurPlancher
@onready var animatedSprite:    AnimatedSprite2D = $AnimatedSprite2D

var direction: int = 1        # +1 = right, -1 = left
var can_reverse: bool = true

func _ready() -> void:
	animatedSprite.play("walk")
	_apply_sensor_orientation()

func _process(delta: float) -> void:
	var hit_wall: bool = detecteurMur.is_colliding()
	var at_ledge: bool = not detecteurPlancher.is_colliding()

	if can_reverse and (hit_wall or at_ledge):
		reverse()
		can_reverse = false
	elif not hit_wall and not at_ledge:
		can_reverse = true

	position.x += direction * speed * delta

func reverse() -> void:
	direction *= -1
	animatedSprite.flip_h = (direction == -1) != flip_sprite_with_direction
	_apply_sensor_orientation()

# Mirror the sensors so they always point IN FRONT of the enemy.
func _apply_sensor_orientation() -> void:
	# Wall ray: always points in the walking direction
	detecteurMur.target_position.x = abs(detecteurMur.target_position.x) * direction
	# Floor ray: its X offset is placed in front of the enemy
	detecteurPlancher.position.x = abs(detecteurPlancher.position.x) * direction
