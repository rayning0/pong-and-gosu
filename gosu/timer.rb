class Timer
  def initialize(window, bullets)
    @bullets = bullets
    @window = window
    @start_time = Time.now
    @every_n_seconds = 5
    @last_recorded_seconds = 0
  end
  
  def update
    @bullets << Bullet.new(@window) if add_bullets?
  end

  def seconds
    (Time.now - @start_time).to_i
  end

  def add_bullets?
    if seconds != @last_recorded_seconds and seconds % @every_n_seconds == 0
      @last_recorded_seconds = seconds
      true
    else
      false
    end
  end
end