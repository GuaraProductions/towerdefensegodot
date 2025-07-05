extends Button
class_name TorreOpcao

var textura: Texture
var texto: String
var preco: int

func configurar(p_textura: Texture, 
				p_texto: String,
				p_preco: int) -> void:
	textura = p_textura
	texto = p_texto
	preco = p_preco
	
func _ready() -> void:
	
	text = texto
	
	var textura_imagem = textura.get_image().duplicate()
	textura_imagem.resize(64, 64)
	var textura_reduzida = ImageTexture.create_from_image(textura_imagem)
	
	icon = textura_reduzida
