extends KinematicBody2D

export var velocity = Vector2(10,70)

export var gravity = 500

const UP = Vector2(0, -1)

var comeco = false

var damage = 10

var olhar_esquerda = false

var olhar_direita = true

signal pode_dropar(pd)

signal life_scale_enemy(sc)

export var life = 100

onready var init_life = life

var can_take_damage = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	velocity.x = - velocity.x
	set_physics_process(false)

func _physics_process(delta: float) -> void:
	$RayCast2D.enabled = true
	velocity.y = gravity
	
	if is_on_wall():
		velocity.x = velocity.x * -1
		$"RayCast2D".cast_to.x *= -1
		
	if $"RayCast2D".is_colliding():
		if velocity.x < 0:
			velocity.x = -30
			$BaseArmoredDemo.flip_h = false
			
		if velocity.x >= 0:
			velocity.x = 30		
			$BaseArmoredDemo.flip_h = true
			
		$AnimationPlayer.play("run")
				
	else:
		$attack/direita.disabled = true
		$attack/esquerda.disabled = true		
		if velocity.x < 0:
			velocity.x = -15
			$BaseArmoredDemo.flip_h = false
			
		if velocity.x >= 0:
			velocity.x = 15		
			$BaseArmoredDemo.flip_h = true
		$AnimationPlayer.play("walk")	
		
	if velocity.x >= 0:
		olhar_direita = true
		olhar_esquerda = false
		
	if velocity.x < 0:
		olhar_direita = false
		olhar_esquerda = true
		
	if olhar_direita:
		$attack/direita.disabled = false
		$attack/esquerda.disabled = true
		
	if olhar_esquerda:
		$attack/direita.disabled = true
		$attack/esquerda.disabled = false			

	move_and_slide(velocity, UP)
	
func _on_VisibilityNotifier2D_screen_entered() -> void:
	set_physics_process(true)

func _on_VisibilityNotifier2D_screen_exited() -> void:
	set_physics_process(false)

#func _on_Area2D_area_entered(area):
#	emit_signal("pode_dropar", $".".position)

func _on_attack_area_entered(area: Area2D) -> void:
	can_take_damage = false
	if area.has_method("hit"):
		area.hit(damage, self)

func _on_weak_spot_damage(damage, node) -> void:
		#print(node.get_parent().get_filename())
		life -= damage
		emit_signal("life_scale_enemy", (float(self.life) / float(self.init_life)))

