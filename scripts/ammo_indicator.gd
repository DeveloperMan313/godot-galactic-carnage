extends Node


const projectile_texture = preload("res://resources/textures/projectile.tres")

const sprite_scale = 5
const sprite_distance = 10
const rotation_speed = PI

var ammo := 0
var max_ammo: int
var player: RigidBody2D
var sprites: Array[Sprite2D]


func init_ammo_indicator(init_player: Node, init_ammo: int, init_max_ammo: int) -> void:
	player = init_player
	ammo = init_ammo
	max_ammo = init_max_ammo
	for i in range(max_ammo):
		var projectile_sprite = Sprite2D.new()
		projectile_sprite.texture = projectile_texture
		projectile_sprite.scale = Vector2.ONE * sprite_scale
		projectile_sprite.offset = Vector2(sprite_distance, 0)
		projectile_sprite.rotation = PI * 2 * i / max_ammo;
		projectile_sprite.visible = false
		sprites.append(projectile_sprite)
		add_child(projectile_sprite)
	update(ammo)


func update(new_ammo: int) -> void:
	for i in range(max_ammo):
		sprites[i].visible = i < new_ammo
	ammo = new_ammo


func _process(delta):
	for sprite in sprites:
		sprite.position = player.position
		sprite.rotation += delta * rotation_speed
