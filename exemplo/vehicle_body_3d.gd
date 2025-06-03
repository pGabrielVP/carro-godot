extends VehicleBody3D

var torque: int = 500
var drive: float = 4.20
var gears: Array[float] = [3.30, 2.20, 1.80, 1.50, 1.30]
var current_gear = 0
const wheel_radius: float = 0.255

const STEER_SPEED:float  = 1.5
const STEER_LIMIT:float = 0.4
var steer_target:float = 0

var acelerador: float = 0

func _physics_process(delta: float) -> void:
	acelerador = 0 
	if Input.is_action_just_pressed("marcha_cima") && current_gear < (gears.size()-1):
		current_gear+=1
	if Input.is_action_just_pressed("marcha_baixo") && current_gear > 0:
		current_gear-=1

	steer_target = Input.get_action_strength("virar_esquerda") - Input.get_action_strength("virar_direita")
	steer_target *= STEER_LIMIT

	if Input.is_action_pressed("acelerador_leve"):
		acelerador += 0.1
	if Input.is_action_pressed("acelerador_medio"):
		acelerador += 0.2
	if Input.is_action_pressed("acelerador_pesado"):
		acelerador += 0.4
	
	if acelerador > 0:
		acelerador += 0.3 # 0.4, 0.5, 0.7 ;; sem essa linha é impossivel chegar a 1.0
		engine_force = (torque * acelerador * (gears[current_gear] * drive))
	else:
		engine_force = 0
	
	steering = move_toward(steering, steer_target, STEER_SPEED * delta)
