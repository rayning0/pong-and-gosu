require 'rubygame'
Rubygame::TTF.setup

class Game

  def initialize
    
    @screen = Rubygame::Screen.new([640, 480], 0, [Rubygame::HWSURFACE, Rubygame::DOUBLEBUF])
    @screen.title = "Pong"

    @queue = Rubygame::EventQueue.new
    @clock = Rubygame::Clock.new
    @clock.target_framerate = 60

    limit = @screen.height - 10

    player_score_x = @screen.width * 0.20    #20% from left side of screen
    enemy_score_x = @screen.width * 0.70     #70% from rt side of screen

    @player = Paddle.new(50, 10, player_score_x, 35, Rubygame::K_W, Rubygame::K_S, 10, limit)
    @enemy = Paddle.new(@screen.width - 50 - @player.width, 10, enemy_score_x, 35, Rubygame::K_UP, Rubygame::K_DOWN, 10, limit)

    @player.center_y(@screen.height)
    @enemy.center_y(@screen.height)
    @background = Background.new(@screen.width, @screen.height)
    @ball = Ball.new(@screen.width / 2, @screen.height / 2)

    @won = false
    @win_text = Text.new
    @play_again_text = Text.new(0, 0, "Play Again? Press Y or N", 40)
  end

  def run
    loop do 
      update
      draw
      @clock.tick
    end
  end
  
  def update
    @player.update
    @enemy.update
    @ball.update @screen, @player, @enemy unless @won

    if @player.score == 10
      win(1)
    elsif @enemy.score == 10
      win(2)
    end

    @queue.each do |ev|
      @player.handle_event(ev)
      @enemy.handle_event(ev)
      case ev
      when Rubygame::QuitEvent
        Rubygame.quit 
        exit
      when Rubygame::KeyDownEvent
        if ev.key == Rubygame::K_ESCAPE
          @queue.push(Rubygame::QuitEvent.new)
        end

        if ev.key == Rubygame::K_Y and @won
          #reset game
          @player.center_y(@screen.height)
          @enemy.center_y(@screen.height)
          @player.score = 0 
          @enemy.score = 0
          @won = false
        end

        if ev.key == Rubygame::K_N and @won
          Rubygame.quit
          exit
        end
      end
    end

    if collision?(@ball, @player)
      @ball.collision(@player, @screen)
    elsif collision?(@ball, @enemy)
      @ball.collision(@enemy, @screen)
    end
  end
  
  def draw
    @screen.fill [0,0,0]

    unless @won

      @background.draw(@screen)
      @player.draw(@screen)
      @enemy.draw(@screen)
      @ball.draw(@screen)
    else
      @win_text.draw(@screen)
      @play_again_text.draw(@screen)
    end

    @screen.flip
  end

  def collision?(obj1, obj2)
    if obj1.y + obj1.height < obj2.y; return false; end
    if obj1.y > obj2.y + obj2.height; return false; end
    if obj1.x + obj1.width < obj2.x; return false; end
    if obj1.x > obj2.x + obj2.width; return false; end
    return true
  end

  def win(player)
    if player == 1
      @win_text.text = "Player 1 Wins!"
    elsif player == 2
      @win_text.text = "Player 2 Wins!"
    end
    @won = true
    @win_text.center_x(@screen.width)
    @win_text.center_y(@screen.height)
    @play_again_text.center_x(@screen.width)
    @play_again_text.y = @win_text.y + 60
  end
end

class GameObject
  attr_accessor :x, :y, :width, :height, :surface

  def initialize(x, y, surface)
    @x = x
    @y = y
    @surface = surface
    @width = surface.width
    @height = surface.height
  end

  def update
  end

  def draw(screen)
    @surface.blit(screen, [@x, @y])
  end

  def handle_event(event)
  end

  def center_x(w)
    @x = w / 2 - @width / 2
  end

  def center_y(h)
    @y = h / 2 - @height / 2
  end
end

class Paddle < GameObject
  def initialize(x, y, score_x, score_y, up_key, down_key, top_limit, bottom_limit)
    surface = Rubygame::Surface.new([20, 100])
    surface.fill([255, 255, 255])
    @up_key = up_key
    @down_key = down_key
    @moving_up = false
    @moving_down = false
    @top_limit = top_limit
    @bottom_limit = bottom_limit

    @score = 0
    @score_text = Text.new(score_x, score_y, @score.to_s, 100)

    super(x, y, surface)    
  end
  


  def handle_event(event)
    case event
    when Rubygame::KeyDownEvent
      if event.key == @up_key
        @moving_up = true
      elsif event.key == @down_key
        @moving_down = true
      end
    when Rubygame::KeyUpEvent
      if event.key == @up_key
        @moving_up = false
      elsif event.key == @down_key
        @moving_down = false
      end
    end
  end

  def update
    @y -= 5 if @moving_up and @y > @top_limit
    @y += 5 if @moving_down and @y+@height < @bottom_limit
  end

  def score
    @score
  end

  def score=(num)
    @score = num
    @score_text.text = num.to_s
  end

  def draw(screen)
    super
    @score_text.draw(screen)
  end
end

class Background < GameObject
  def initialize(width, height)
    surface = Rubygame::Surface.new([width, height])

    #draw background
    white = [255, 255, 255]

    #top
    surface.draw_box_s([0,0], [surface.width, 10], white)
    #left
    surface.draw_box_s([0,0], [10, surface.height], white)
    #bottom
    surface.draw_box_s([0, surface.height-10], [surface.width, surface.height], white)
    #right
    surface.draw_box_s([surface.width-10, 0], [surface.width, surface.height], white)
    #middle divide
    surface.draw_box_s([surface.width/2-5, 0], [surface.width/2+5, surface.height], white)

    super(0, 0, surface)
  end
end

class Ball < GameObject
  def initialize(x, y)
    surface = Rubygame::Surface.load("ball.png")
    @vx = @vy = 5
    super(x, y, surface)
  end

  def update(screen, player, enemy)
    @x += @vx
    @y += @vy

    #left: score for enemy
    if @x <= 10 
      enemy.score += 1
      score(screen)
    end

    #right: score for player
    if @x + @width >= screen.width - 10
      player.score += 1
      score(screen)
    end

    #top or bottom
    if @y <= 10 or @y + @height >= screen.height - 10
      @vy *= -1
    end
  end

  def score(screen)
    @vx *= -1
    #move to somewhere in middle two 4ths of screen
    @x = screen.width / 4 + rand(screen.width / 2)
    #spawn anywhere on y-axis except along edges
    @y = rand(screen.height - 50) + 25
  end

  def collision(paddle, screen)
    #which paddle did we hit?
    #left
    if paddle.x < screen.width/2
      #are we behind paddle? use 5 pixel buffer just in case
      unless @x < paddle.x - 5
        @x = paddle.x + paddle.width + 1
        @vx *= -1
      end
    #right
    else
      unless @x > paddle.x + 5
        @x = paddle.x - @width - 1
        @vx *= -1
      end
    end
  end
end

class Text < GameObject
  def initialize(x = 0, y = 0, text = "Hello World!", size = 48)
    @font = Rubygame::TTF.new("font.ttf", size)
    @text = text
    super(x, y, rerender_text())
  end

  def rerender_text
    @width, @height = @font.size_text(@text)
    @surface = @font.render(@text, true, [255, 255, 255])
  end

  def text
    @text
  end

  def text= string
    @text = string
    rerender_text
  end
end


g = Game.new.run