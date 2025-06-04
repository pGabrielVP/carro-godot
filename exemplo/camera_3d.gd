extends Camera3D

@onready var carro: CollisionShape3D = get_node("../CollisionShape3D")
@onready var carro_raiz: VehicleBody3D = get_node("../../VehicleBody3D")

var fov_base: float = 51.1
var distancia_padrao_camera: float = 4.4

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var distancia_camera: float = distancia_padrao_camera + (carro_raiz.linear_velocity.length()/70)
	position = lerp(position, carro.position - Vector3(0, -2.6, distancia_camera), 1) 
	fov = fov_base + (carro_raiz.linear_velocity.length()/2)
