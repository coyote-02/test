require 'dxruby'
require_relative "obstacle"
require_relative "player"


obstacle_img = Image.load("image/player.png")
x1 = 100
y1 = 100
count = 0
obstacle = Obstacle.new(100, y1 + count, obstacle_img)

obstacle_font = Font.new(32)
y2 = 100
status = 400

player_img = Image.load("image/player.png")
player = Player.new(100, 300, player_img)

Window.loop do
    count = count + 1
    player.draw
    Window.draw_font(100, y2 + count, "#{status}", obstacle_font)

    player.update


end