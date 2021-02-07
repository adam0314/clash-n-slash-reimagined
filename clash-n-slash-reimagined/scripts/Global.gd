extends Node

### Bullets

enum BulletType {LASER}

const bullet_firerate = {
	BulletType.LASER: 3.0
}

const bullet_speed = {
	BulletType.LASER: 400.0
}

const max_distance_from_planet = 620.0

### Enemies

enum EnemyType {SMALL}

const enemy_speed = {
	EnemyType.SMALL: 40.0
}
