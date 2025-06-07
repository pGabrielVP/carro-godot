extends Camera3D

@onready var carro: Node3D = $"../suv"
@onready var bola: RigidBody3D = $"../RigidBody3D"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#position = lerp(position, carro.position + Vector3(0.0, 2.27, -3.568), 10 * delta)

	#global_position = bola.global_position + Vector3(8,4,0)
	#global_transform.basis.x = -carro.global_transform.basis.x
	pass
