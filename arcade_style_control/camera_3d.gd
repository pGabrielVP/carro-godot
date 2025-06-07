extends Camera3D

@onready var carro: Node3D = $"../suv"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position = lerp(position, carro.position + Vector3(0.0, 2.27, -3.568), 10 * delta)
	
