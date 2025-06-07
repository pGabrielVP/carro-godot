extends CanvasLayer

func atualizar_marcha(marcha: int) -> void:
	match marcha:
		-1:
			$Marcha.text = "R"
		0:
			$Marcha.text = "N"
		_:
			$Marcha.text = str(marcha)


func atualizar_info(velocidade: float, rpm: float) -> void:
	var velocidade_km = velocidade * 3.6
	var texto =  "%.3f km/h : %.0f rpm"
	$Info.text = texto % [velocidade_km, rpm]
