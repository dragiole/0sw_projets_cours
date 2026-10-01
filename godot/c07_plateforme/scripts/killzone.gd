extends Area2D


@onready var timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	print("Man im dead...")
	$Timer.start()
	pass # Replace with function body.

func _on_timer_timeout() -> void:
	get_tree().reload_current_scene()
