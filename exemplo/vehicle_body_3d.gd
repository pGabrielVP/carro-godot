extends VehicleBody3D

var torque: int = 500
var drive: float = 4.20
var gears: Array[float] = [3.30, 2.20, 1.80, 1.50, 1.30]
var reverse_gear: float = -3.0
var current_gear = 0
const wheel_radius: float = 0.255

var MAX_ENGINE_FORCE: float = 700.0
var MAX_ENGINE_RPM: float = 8000.0
@export var power_curve: Curve = null
 
const STEER_SPEED:float  = 1.0
const STEER_LIMIT:float = 0.2
var steer_target:float = 0

var acelerador: float = 0

func calculate_rpm() -> float:
	if current_gear == 0:
		return 0.0
	
	var wheel_circunference: float = 2.0 * PI * wheel_radius
	var wheel_rotation_speed: float = 60 * linear_velocity.length() / wheel_circunference
	var drive_shaft_rotation_speed: float =wheel_rotation_speed * drive
	if current_gear == -1:
		return drive_shaft_rotation_speed * -reverse_gear
	elif current_gear <= gears.size():
		return drive_shaft_rotation_speed * gears[current_gear-1]
	return 0
  
func _physics_process(delta: float) -> void:
	acelerador = 0 
	if Input.is_action_just_pressed("marcha_cima") && current_gear < (gears.size()):
		current_gear+=1
	if Input.is_action_just_pressed("marcha_baixo") && current_gear > -1:
		current_gear-=1

	steer_target = Input.get_action_strength("virar_esquerda") - Input.get_action_strength("virar_direita")
	steer_target *= STEER_LIMIT

	if Input.is_action_pressed("acelerador_leve"):
		acelerador += 0.1
	if Input.is_action_pressed("acelerador_medio"):
		acelerador += 0.2
	if Input.is_action_pressed("acelerador_pesado"):
		acelerador += 0.4
	
	var rpm = calculate_rpm()
	var rpm_factor = clamp(rpm/MAX_ENGINE_RPM, 0.0, 1.0)
	var power_factor = power_curve.sample_baked(rpm_factor)

	if acelerador > 0:
		acelerador += 0.3 # 0.4, 0.5, 0.7 ;; sem essa linha é impossivel chegar a 1.0
		if current_gear == -1:
			engine_force = acelerador * power_factor * reverse_gear * drive * MAX_ENGINE_FORCE
		elif current_gear > 0 and current_gear <= gears.size():
			engine_force = acelerador * power_factor * gears[current_gear-1] * drive * MAX_ENGINE_FORCE
	else:
		engine_force = 0
	
	steering = move_toward(steering, steer_target, STEER_SPEED * delta)
