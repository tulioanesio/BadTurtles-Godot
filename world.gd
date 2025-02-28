extends Node2D

# variavel contendo nossa pontuacao
var score: int = 0

# Comportamento do jogo quando o Player morre
func game_over() -> void:
	$MusicNormal.stop()               # Para a musica normal
	$MusicSuper.stop()                # Para a musica Super se estiver tocando
	$SoundGameOver.play()             # Toca o som de Game Over
	$GameOverImage.visible = true     # Torna a imagem de Game Over visivel

# Altera o tipo da musica. Se a entrada for True,
# toca a musica Super, senao a musica normal
func change_music(superPower) -> void:
	if superPower:                    # Se esta no modo super
		$MusicNormal.stop()           # Desliga a musica normal
		$MusicSuper.play()            # E liga a musica animada
	else:                             # Senao
		$MusicSuper.stop()            # Desliga a musica animada
		$MusicNormal.play()           # E liga a musica normal

# O Player chama essa funcao quando mata uma tartaruga.
# Nao eh algo muito legal de se fazer, matar tartarugas,
# mas eh soh um jogo de exemplo, entao vamos relevar.
func make_point() -> void:
	$Timer.start($Timer.time_left + 5) # Aumenta o tempo restante em 5
	score += 1                         # Aumenta a pontuacao em 1

# Essa funcao eh chamada quando o Timer chega a 0,
# ou seja, deu timeout.
func _on_timer_timeout() -> void:
	$Player.kill()                     # O Player morre
