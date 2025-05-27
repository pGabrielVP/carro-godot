extends VehicleBody3D

enum marcha {neutro=0, primera=10, segunda=30, terceira=60, quarta=80, quinta=150, re=10}

const STEER_SPEED:float  = 1.5
const STEER_LIMIT:float = 0.4
var steer_target:float = 0
var aceleracao:int = 200
var acelerador: float = 0

func _physics_process(delta: float) -> void:
	acelerador = 0

	steer_target = Input.get_action_strength("virar_esquerda") - Input.get_action_strength("virar_direita")
	steer_target *= STEER_LIMIT

	if Input.is_action_pressed("acelerador_leve"):
		acelerador += 10
	if Input.is_action_pressed("acelerador_medio"):
		acelerador += 20
	if Input.is_action_pressed("acelerador_pesado"):
		acelerador += 40

	if acelerador > 0:
		var speed = linear_velocity.length()
		if speed < acelerador:
			engine_force = aceleracao
		else: 
			engine_force = 0
	else:
		engine_force = 0

	steering = move_toward(steering, steer_target, STEER_SPEED * delta)
