extends State
class_name mageAttack
@export var enemy: CharacterBody3D
@onready var proj = preload("res://locations/enemies/scenes/mageProjectile.tscn")
var player
var rand
var angle
var canRotate = true
var chargeAngle
var attackStarted 
var chargeStabDir
@onready var armature = enemy.get_node("Armature")
@onready var weaponHitbox = enemy.get_node("Armature").get_node("Skeleton3D").get_node("weapon").get_node("Cube").get_node("Area3D")
var canShoot = true
var canMove = true
func enter():
	enemy.get_node("Armature").visible = true
	enemy.get_node("teleportparticles").visible = false
	enemy.SPEED = 5
	enemy.velocity = Vector3()
	attackStarted = false
	player = get_tree().get_first_node_in_group("player")

func physics_update(delta: float):
	if enemy.parriedState == true:
		transitioned.emit(self, "mageParried")
	if chargeStabDir:
		var g = Vector2(chargeStabDir.x, chargeStabDir.z)
		chargeAngle = g.angle()
	var v = Vector2(player.global_position.x - enemy.global_position.x, player.global_position.z - enemy.global_position.z)
	angle = v.angle() 
	var direction = (player.global_position - enemy.global_position).normalized()
	if enemy.anim.current_animation == "slash2" or enemy.anim.current_animation == "slash3" or enemy.anim.current_animation == "fireball":
		if enemy.attacking == true and enemy.anim.current_animation != "runningstab" and canRotate == true:
			enemy.rotation.y = lerp_angle(enemy.rotation.y, -angle, delta * 6)
	if enemy.anim.current_animation == "runningstab":
		
		enemy.rotation.y = lerp_angle(enemy.rotation.y, -chargeAngle, delta * 3)
		if canMove:
			enemy.velocity.z = lerp(enemy.velocity.z,chargeStabDir.z * 4,.2)
			enemy.velocity.x = lerp(enemy.velocity.x,chargeStabDir.x * 4,.2)
		else:
			enemy.velocity = Vector3()
	if enemy.anim.current_animation == "slash2" or enemy.anim.current_animation == "slash3":
		if canMove:
			enemy.velocity.z = lerp(enemy.velocity.z,direction.z * 4,.2)
			enemy.velocity.x = lerp(enemy.velocity.x,direction.x * 4,.2)
		else:
			enemy.velocity = Vector3()
	if enemy.anim.current_animation == "fireball":
		enemy.velocity = Vector3()
	if enemy.attacking == false and attackStarted == false:
		enemy.rotation.y = lerp_angle(enemy.rotation.y, -angle, .1)
		if enemy.health < 40:
			if enemy.global_position.distance_to(player.global_position) < 1:
				transitioned.emit(self, "mageFlee")
			else:
				enemy.anim.play("fireball")
				

		else:
			if enemy.global_position.distance_to(player.global_position) > 4:
				var rng = RandomNumberGenerator.new()
				rand = rng.randf_range(0,10)
				if rand > 5:
					enemy.anim.play("runningstab")
					attackStarted = true
				else:
					transitioned.emit(self, "mageChase")
				
			
				
			elif ((enemy.rotation.y) - (-angle)) <.005:
				enemy.velocity = Vector3()
				var rng = RandomNumberGenerator.new()
				rand = rng.randf_range(0,10)
				if rand > 5:
					enemy.anim.play("slash1")
				else:
					enemy.anim.play("runningstab")
				attackStarted = true
			
			
	if enemy.attacking == true:
		var a = weaponHitbox.get_overlapping_bodies()
		for i in a:
			if i.is_in_group("player"):
				i.hurted(20)
				weaponHitbox.get_node("CollisionShape3D").disabled = true
				

func combo():
	if enemy.global_position.distance_to(player.global_position) < 6:
		enemy.anim.play("slash2")
		
func getStabDir():
	chargeStabDir = (player.global_position - enemy.global_position).normalized()
func combo2():
	if enemy.global_position.distance_to(player.global_position) < 6:
		enemy.anim.play("slash3")

func attackStart():
	enemy.parryable = true
	if enemy.anim.current_animation != "fireball":
		weaponHitbox.get_node("CollisionShape3D").disabled = false
	enemy.attacking = true
	
	
func attackEnd():
	weaponHitbox.get_node("CollisionShape3D").disabled = true
	enemy.attacking = false
	await enemy.anim.animation_finished
	enemy.velocity = Vector3()
	await get_tree().create_timer(.5).timeout
	attackStarted = false
func parryableEnd():
	enemy.parryable = false
func Rotate():
	canRotate = true
func Move():
	canMove = true
func cantMove():
	canMove = false
func cantRotate():
	canRotate = false
func fireAppear():
	enemy.get_node("fireparticles").visible = true
func fireRemove():
	enemy.get_node("fireparticles").visible = false
func chuckFireball():
	var pos = player.global_position
	var projectile = proj.instantiate()	
	get_tree().get_root().add_child(projectile)
	projectile.global_position =  enemy.get_node("Armature").get_node("Skeleton3D").get_node("fireballHand").global_position
	var direction =  player.global_position - enemy.global_position
	projectile.velocity = -direction.normalized() * 3
	
	#enemy.get_node("Armature").get_node("Skeleton3D").get_node("fireballHand").remove_child(projectile)
