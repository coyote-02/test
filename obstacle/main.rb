require 'dxruby'
require_relative "obstacle"
require_relative "player"


obstacle_img = Image.load("image/enemy.png")
x1 = 100
y1 = 100
count = 0
obstacle = Obstacle.new(100, y1 + count, obstacle_img)

obstacle_font = Font.new(32)
y2 = 100

player_img = Image.load("image/player.png")
player = Player.new(100, 300, player_img)
player_font = Font.new(32)

Window.loop do
    count = count + 1
    player.draw
    obstacle.draw
    obstacle.update

    Window.draw_font(100, y2 + count, "#{obstacle.status[:damage]}", obstacle_font)
    Window.draw_font(300, 350, "#{player.status[:health]}", player_font)

    player.update
    Sprite.check(player, obstacle)


end