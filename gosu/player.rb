class Player
  attr_reader :lives, :x, :y, :laser, :icon

  def initialize(window)
    @window = window
    @icon = Gosu::Image.new(@window, "player.png", true)
    @x = 0
    @y = window.height - 80
    @explosion = Gosu::Image.new(@window, "explosion.png", true)
    @exploded = false
    @lives = 10
    @laser = Laser.new(self, @window)
  end

  def update
    if @window.button_down? Gosu::Button::KbLeft
        move_left
    end
    if @window.button_down? Gosu::Button::KbRight
        move_right
    end
    if @window.button_down? Gosu::Button::KbSpace
        @laser.shoot
    end
    @laser.update
  end

  def move_left
    @x -= 10
    @x = 0 if @x < 0
  end

  def move_right
    @x += 10
    @x = @window.width - 50 if @x > @window.width - 50
  end

  def draw
    if @exploded
      @explosion.draw(@x, @y, 4)
    else
      @icon.draw(@x, @y, 1)
      @laser.draw
    end
  end

  def hit_by?(bullets)
    @exploded = bullets.any? {|bullet| Gosu::distance(bullet.x, bullet.y, @x + @icon.width/2, @y) < 50}
    @lives -= 1 if @exploded
    @exploded
  end

  def reset_position
    @x = rand(@window.width)
  end
end