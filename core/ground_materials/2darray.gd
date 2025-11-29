extends Node

func _ready():
	var tex1 : Texture2D = load("res://core/ground_materials/Grass.png")
	var tex2 : Texture2D = load("res://core/ground_materials/stone.png")

	var img1: Image = tex1.get_image()
	var img2: Image = tex2.get_image()

	var tex_array := Texture2DArray.new()
	tex_array.create_from_images([img1, img2])


	ResourceSaver.save(tex_array, "res://core/ground_materials/aa.tres")
