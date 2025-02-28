extends CharacterBody2D

# Constantes de direcoes
const DOWN: int = 0            # Para baixo
const RIGHT: int = 1           # Para a direita
const UP: int = 2              # Para cima
const LEFT: int = 3            # Para a esquerda

var SPEED: int = 100           # Velocidade
var direction: int = DOWN      # Direcao
var screensize: Vector2        # Tamanho da tela

# Metodo chamado ao criar o objeto
func _ready() -> void:
	screensize = get_viewport_rect().size # pega o tamanho da tela do jogo
	randomize()                           # executa o randomizador
	new_goal()                            # inicia com um novo objetivo

# Cria um novo objetivo para o objeto
func new_goal() -> void:
	direction = randi() % 4               # Pega uma direcao aleatoria
	$Timer.start((randi() % 20) / 10.0)   # Um timeout aleatorio de 0.0 a 2.0

# Metodo para matar o personagem
func kill() -> void:
	hide()                                # Esconde o objeto
	$CollisionShape2D.disabled = true     # Desabilita as colisoes
	$SoundKill.play()                     # Toca o som de morte do personagem

# Metodo que executa as fisicas do objeto
func _physics_process(delta) -> void:
	# Inicialmente vamos seguir conforme a direcao objetivo ja definida
	# Entao criamos um vetor vel para pegar as informacoes de direcao
	var vel = Vector2()                   # Criamos um Vetor 2D
	if direction == DOWN:                 # Se direcao pra baixo
		vel.y += SPEED                    # Adicionamos SPEED ao y do vetor
		rotation_degrees = 0              # E rotacionamos para 0
	elif direction == RIGHT:              # Senao, se for para a direita
		vel.x += SPEED                    # Aumentamos o x
		rotation_degrees = -90            # E rotacionamos 90 graus negativos
	elif direction == UP:                 # Senao, se for para cima
		vel.y -= SPEED                    # Diminuimos y, ficando negativo
		rotation_degrees = 180            # E rotacionamos para 180 graus
	elif direction == LEFT:               # Senao se direcao eh para a esquerda
		vel.x -= SPEED                    # Diminuimos SPEED de x
		rotation_degrees = 90             # E rotacionamos 90 graus
	# Move o objeto conforme direcao multiplicado pelo delta
	var obj = move_and_collide(vel * delta)     # Movemos e detectamos colisao
	if obj:                                     # se colidirmos, temos um obj
		if 'Player' in obj.get_collider().name: # Se no nome do obj tiver Player
			var other = obj.get_collider()      # Pegamos com quem colidimos
			if other.super_power:               # Se ele estiver no modo super
				kill()                          # Essa Turtle morre
			else:                               # Senao
				other.kill()                    # Matamos o Player
		else:                                   # Se colidiu e nao eh o Player
			new_goal()                          # Altera o objetivo
	$AnimatedSprite2D.play()                    # Da play na animacao
	# Se sair da tela, eixo x ou y, volta pra tela
	position.x = clamp(position.x, 25, screensize.x - 25)
	position.y = clamp(position.y, 25, screensize.y - 25)

# Funcao chamada quando der timeout no Timer
func _on_timer_timeout() -> void:
	new_goal()               # Gera um novo objetivo
