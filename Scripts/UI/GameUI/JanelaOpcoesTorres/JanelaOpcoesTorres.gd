extends Window
class_name JanelaOpcoesDeTorres

signal torre_escolhida(torre_info: TorreInfo)

@onready var torres_grid: GridContainer = %TorresGrid
@onready var nome: Label = %Nome
@onready var descricao: Label = %Descricao
@onready var textura: TextureRect = %Textura

@export var torre_opcoes_cena : PackedScene

func configurar_opcoes_de_torres(torres: Array[TorreInfo]) -> void:
	
	for torre in torres:
		var torre_opcoes_instancia : TorreOpcao = \
		 torre_opcoes_cena.instantiate()
		
		torre_opcoes_instancia.configurar(torre.textura, torre.nome, torre.preco)
		
		torres_grid.add_child(torre_opcoes_instancia)
		
		torre_opcoes_instancia.focus_entered.connect(_botao_em_foco.bind(torre))
		torre_opcoes_instancia.pressed.connect(_torre_escolhida.bind(torre))
		
func _botao_em_foco(torre: TorreInfo) -> void:
	nome.text = torre.nome
	textura.texture = torre.textura
	descricao.text = torre.descricao
	
func _torre_escolhida(torre: TorreInfo) -> void:
	torre_escolhida.emit(torre)
	hide()
	
func _on_about_to_popup() -> void:
	torres_grid.get_children()[0].grab_focus()

func configurar_opcoes_de_torres_disponiveis(valor_na_carteira: int) -> void:
	for torre_opcao in torres_grid.get_children():
		
		if torre_opcao is not TorreOpcao:
			return
		
		torre_opcao.disabled = torre_opcao.preco > valor_na_carteira

func _on_close_requested() -> void:
	hide()
