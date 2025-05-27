extends CharacterBody3D

var velocidade_maxima: int = 25
@export var angulo_roda: int = 35

var velocidade_alvo = Vector3.ZERO
func _physics_process(delta: float) -> void:
	var direcao = Vector3.ZERO
	
	if Input.is_action_pressed("virar_esquerda"):
		pass
	if Input.is_action_pressed("virar_direita"):
		pass
