extends Node

### Weapons

enum WeaponType {
	LASER1
}

const weapon_firerate = {
	WeaponType.LASER1: 3.0
}

const weapon_sounds = {
	WeaponType.LASER1: preload("res://sound/pewpews/pewpew_1.wav")
}

### Bullets

enum BulletType {LASER}

const bullet_speed = {
	BulletType.LASER: 400.0
}

const max_distance_from_planet = 620.0

### Enemies

enum EnemyType {
	SMALL = 0,
	KEK = 1
}

const enemy_speed = {
	EnemyType.SMALL: 40.0
}
