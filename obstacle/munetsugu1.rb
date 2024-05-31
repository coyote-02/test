require 'dxruby'

class Player < Sprite
  @@count = 0

  def initialize(x, y)
    # プレイヤーの位置とサイズを設定
    if @@count == 0
      # 初めてのプレイヤーの色を黄色に設定
      image = Image.new(10, 10, [255, 255, 0])
    else
      image = Image.new(10, 10, [255, 255, 255])
    end

    super(x, y, image)

    @@count += 1
  end

  def update
    self.x += Input.x
    self.y += Input.y

    # ウィンドウ外に出ないように制限
    self.x = [[self.x, 0].max, Window.width - image.width].min
    self.y = [[self.y, 0].max, Window.height - image.height].min
  end
end

Window.width = 800
Window.height = 600

players = [Player.new(Window.width / 2 - 5, Window.height - 20)]

start_time = Time.now

Window.loop do
  current_time = Time.now
  elapsed_time = current_time - start_time

  # 1秒ごとにプレイヤーを追加し、100秒間増え続ける
  if elapsed_time <= 100 && (elapsed_time.to_i > players.size - 1)
    # 新しいプレイヤーを整列させて追加
    last_player = players[-1]
    new_x = last_player.x
    new_y = last_player.y + 12 # 下に整列させる（間隔10 + プレイヤーの高さ10）

    # ウィンドウ外に出ないように制限
    new_y = [new_y, Window.height - 10].min

    players << Player.new(new_x, new_y)
  end

  players.each do |player|
    player.update
    player.draw
  end

  # 経過時間の表示
  Window.draw_font(10, 10, "経過時間: #{elapsed_time.to_i}秒", Font.default)
  Window.draw_font(10, 30, "プレイヤー数: #{players.size}", Font.default)
end
