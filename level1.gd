extends Node2D

const MAP_SIZE = Vector2(5000, 5000)
const SPRITE_SIZE =  Vector2(200, 200)

# Called when the node enters the scene tree for the first time.
func _ready():
    randomize()
    
    for row in range(0, MAP_SIZE.x / SPRITE_SIZE.x):
        for column in range(0, MAP_SIZE.y / SPRITE_SIZE.y):
            var texture = ImageTexture.new()
            print("./assets/stars/space" + str(randi() % 6 + 1) + ".png")
            texture.load("./assets/stars/space" + str(randi() % 6 + 1) + ".png")
            
            var position = Vector2(SPRITE_SIZE.x * row, SPRITE_SIZE.y * column)
            
            var sprite = Sprite.new()
            sprite.set_position(position)
            sprite.set_texture(texture)
            print((randi() % 4) * 90)
            sprite.rotate(deg2rad((randi() % 4)) * 90)
            
            self.add_child(sprite)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
