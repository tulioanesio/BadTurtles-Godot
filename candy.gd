extends StaticBody2D

# funcao chamada para excluir o objeto do jogo
func kill() -> void:
	hide()                                        # escondemos o objeto
	$CollisionShape2D.disabled = true             # desabilitamos as collisoes
