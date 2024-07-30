extends Area2D

@onready var hit_box = $HitBox
@onready var weapon_mesh = $WeaponMesh

func _ready():
	attack_deactivate()

func attack_activate() -> void:
	self.monitoring = true
	weapon_mesh.show()

func attack_deactivate() -> void:
	self.monitoring = true
	weapon_mesh.hide()
