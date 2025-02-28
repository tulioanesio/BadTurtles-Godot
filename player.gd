extends CharacterBody2D

var SPEED: int = 200          # velocidade
var screensize: Vector2       # tamanho da tela
var super_power: bool = false # modo de super poder

# metodo chamado ao criar o objeto
func _ready() -> void:
	screensize = get_viewport_rect().size

# metodo chamado para matar o personagem
func kill() -> void:
	hide()                             # deixamos ele invisivel
	$CollisionShape2D.disabled = true  # desabilitamos as colisoes
	get_parent().game_over()            # avisamos ao World que morremos

# Entramos em modo de super poder
func do_super() -> void:
	super_power = true                      # sabemos que temos super poderes
	SPEED += 10                             # a velocidade eh incrementada
	$AnimatedSprite2D.animation = "super"   # alteramos a animacao para super
	get_parent().change_music(true)         # mudamos para musica mais animada
	$Timer.start()                          # iniciamos um timeout de super

# Essa funcao processa a fisica do jogo e sera chamada
# a cada frame do jogo. Eh parte do game loop
func _physics_process(delta) -> void:
	var vel = Vector2()                         # Crio um vetor 2D
	if Input.is_action_pressed("ui_down"):      # Se digitada tecla para baixo
		vel.y += SPEED                          # Aumenta y do vetor
		rotation_degrees = 0                    # Rotaciona a imagem 0 graus
	elif Input.is_action_pressed("ui_right"):   # Senao, se tecla para direita
		vel.x += SPEED                          # Aumenta x do vetor
		rotation_degrees = -90                  # Rotaciona a imagem -90 graus
	elif Input.is_action_pressed("ui_up"):      # Senao se tecla para cima
		vel.y -= SPEED                          # Diminui y do eixo vertical
		rotation_degrees = 180                  # Rotaciona para 180 graus
	elif Input.is_action_pressed("ui_left"):    # Senao se tecla para esquerda
		vel.x -= SPEED                          # Diminui x do eixo horizontal
		rotation_degrees = 90                   # Rotaciona a imagem 90 graus
	# Se movimentou, o vetor vel sera maior que zero
	if vel.length() > 0:                            
		var obj = move_and_collide(vel * delta)     # move e pega colisao
		if obj:                                     # se colidiu, retorna em obj
			if 'Turtle' in obj.get_collider().name: # Se for Turtle
				if super_power:                     # Se estiver no modo super
					var other = obj.get_collider()  # Pega o objeto Turtle
					other.kill()                    # E mata ele
					get_parent().make_point()       # Faz ponto no jogo
				else:                               # Senao
					kill()                          # Morre
			elif 'Candy' in obj.get_collider().name:# Se for um Candy
				var other = obj.get_collider()      # Pega o objeto Candy
				other.kill()                        # Mata o Candy
				do_super()                          # E entra no modo super
		$AnimatedSprite2D.play()   # Da play na animacao
	else:                          # Senao, se nao movimentou, vel = 0     
		$AnimatedSprite2D.stop()   # E para a animacao
	# Se sair da tela, eixo x ou y, volta pra tela
	position.x = clamp(position.x, 25, screensize.x - 25)
	position.y = clamp(position.y, 25, screensize.y - 25)

# Essa funcao eh chamada quando o timeout do modo super
# chega a zero, voltando entao para o modo normal.
func _on_timer_timeout() -> void:
	super_power = false                     # Desliga o modo super
	SPEED -= 10                             # Volta a velocidade normal
	$AnimatedSprite2D.animation = "normal"  # Volta a animacao normal
	get_parent().change_music(false)        # E volta a musica mais calma
