class_name Movement2
extends Node2D

# Movement speed
var speed = 150

func _process(delta):
    var velocity = move(delta)
    flip_character(velocity)

func move(delta):
    var velocity = Vector2()
    velocity.x = Input.get_axis("move_left", "move_right")
    velocity.y = Input.get_axis("move_up", "move_down")
    if velocity != Vector2():
        velocity = velocity.normalized() * speed * delta
        position += velocity
    return velocity

func flip_character(velocity):

    var sprite = get_node("Sprite")
    if velocity != Vector2.ZERO:
        if velocity.x > 0:
            sprite.flip_h = false #Derecha		
        elif velocity.x < 0:
            sprite.flip_h = true #izquierda flip
