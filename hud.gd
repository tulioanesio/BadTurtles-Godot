extends Node2D

# Nosso HUD nao tem nenhum processamento. Ele serve
# apenas para visualizacao das informacoes. Veja que
# a cada game loop buscamos as informacoes do World
# com get_parent() e colocamos elas nos Labels
func _physics_process(_delta: float) -> void:
	$InfoScore.text = str(get_parent().score)
	$InfoTimeout.text = str(int(get_parent().get_node("Timer").time_left))
