require 'curses'

Curses.init_screen

begin
  window = Curses.stdscr
  x = window.maxx / 2
  y = window.maxy / 2

  window.setpos(y, x)
  window.addstr("Number of lines: #{window.maxy},")
  window.setpos(y+1, x)
  window.addstr("Number of columns: #{window.maxx}")
  window.refresh
  window.getch
ensure
  Curses.close_screen
end

