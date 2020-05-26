extends Area2D


func AttackArea_entered(area):
	if area.is_in_group("hitbox"):
		area.get_parent().take_damage
