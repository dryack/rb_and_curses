require 'curses'

Curses.init_screen
Curses.curs_set(0) #invisible cursor

begin
  # build static window
  window1 = Curses::Window.new(Curses.lines / 2 - 1, Curses.cols / 2 - 1, 0, 0)
  window1.box("o", "o")
  window1.setpos(1, 1)
  window1.addstr("Lines: #{window1.maxy},")
  window1.refresh
  
  # next window
  window2 = Curses::Window.new(Curses.lines / 2 -1, Curses.cols / 2 - 1, Curses.lines / 2, Curses.cols / 2)
  window2.nodelay = true
  window2.keypad = true
  window2.box("|", "-")
  window2.refresh

  current_ypos = window2.maxy / 2
  2.upto(window2.maxx - 3) do |i|
    window2.setpos(current_ypos, i)
    input = window2.getch
    if input == Curses::Key::UP then
      current_ypos = current_ypos - 1
    elsif input == Curses::Key::DOWN then
      current_ypos = current_ypos + 1
    end
    window2 << "*"
    window2.refresh
    sleep 0.15

  end

  sleep 0.5
  window1.clear
  window1.refresh
  window1.close
  sleep 0.5
  window2.clear
  window2.refresh
  window2.close
  sleep 0.5
rescue => ex
  Curses.close_screen
end
