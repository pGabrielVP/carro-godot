extends Node3D

@onready var ball: RigidBody3D = $RigidBody3D
@onready var car_mesh: Node3D = $suv
@onready var ground_ray: RayCast3D = $suv/RayCast3D
@onready var right_wheel: MeshInstance3D = $"suv/wheel-front-right"
@onready var left_wheel: MeshInstance3D = $"suv/wheel-front-left"
@onready var body_mesh: MeshInstance3D = $"suv/body"

var sphere_offset: Vector3 = Vector3(0.0, -1.0, 0.0)
var acceleration: int = 50
var steering: int = 21
var turn_speed: int = 5
var turn_stop_limit: float = 0.75
var body_tilt: int = 35

var speed_input: float = 0.0
var rotate_input: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ground_ray.add_exception(ball)

func _physics_process(_delta: float) -> void:
	car_mesh.transform.origin = ball.transform.origin + sphere_offset
	ball.apply_central_force(car_mesh.global_transform.basis.z * speed_input)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not ground_ray.is_colliding():
		print("How does debugging works")
		return
	speed_input = 0
	speed_input += Input.get_action_strength("acelerar_arcade")
	speed_input -= Input.get_action_strength("re_arcade")
	speed_input *= acceleration
	rotate_input = 0
	rotate_input += Input.get_action_strength("esquerda_arcade")
	rotate_input -= Input.get_action_strength("direita_arcade")
	rotate_input *= deg_to_rad(steering)
	
	right_wheel.rotation.y = rotate_input
	left_wheel.rotation.y = rotate_input
	
	if ball.linear_velocity.length() > turn_stop_limit:
		var new_basis = car_mesh.global_transform.basis.rotated(car_mesh.global_transform.basis.y, rotate_input)
		car_mesh.global_transform.basis = car_mesh.global_transform.basis.slerp(new_basis, turn_speed * delta)
		car_mesh.global_transform = car_mesh.global_transform.orthonormalized()
		
		var t = -rotate_input * ball.linear_velocity.length() / body_tilt
		body_mesh.rotation.z = lerp(body_mesh.rotation.z, t, 10 * delta)

	var n = ground_ray.get_collision_normal()
	var xform = align_with_y(car_mesh.global_transform, n.normalized())
	car_mesh.global_transform = car_mesh.global_transform.interpolate_with(xform, 10 * delta)
	
func align_with_y(xform: Transform3D, new_y: Vector3) -> Transform3D:
	xform.basis.y = new_y
	xform.basis.x = -xform.basis.z.cross(new_y)
	xform.basis = xform.basis.orthonormalized()
	return xform
