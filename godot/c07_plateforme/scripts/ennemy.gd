extends Node2D

@export var speed : float = 60
@onready var detecteurDroit : RayCast2D = $DetecteurDroit
@onready var detecteurGauche : RayCast2D = $DetecteurGauche
@onready var detecteurPlancer : RayCast2D= $DetecteurPlancher
@onready var animatedSprite : AnimatedSprite2D = $AnimatedSprite2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if not detecteurPlancer.is_colliding() :
		speed = -speed
		animatedSprite.flip_h = not animatedSprite.flip_h
	
	if detecteurDroit.is_colliding() or detecteurGauche.is_colliding():
		speed = -speed
		animatedSprite.flip_h = not animatedSprite.flip_h
	position.x += speed * delta
	pass

func reverse()-> void:
	speed = -speed
	animatedSprite.flip_h = not animatedSprite.flip_h
	
	
