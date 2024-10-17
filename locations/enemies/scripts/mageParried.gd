extends State
class_name mageParried
@export var enemy: CharacterBody3D

func enter():
	enemy.anim.play("damaged1")
	enemy.anim.speed_scale = .5
	await enemy.anim.animation_finished
	enemy.anim.speed_scale = 1
	transitioned.emit(self, "enemyIdle")
