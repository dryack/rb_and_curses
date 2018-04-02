require 'curses'

Curses.init_screen

begin
  nb_lines = Curses.lines
  nb_cols = Curses.cols
  x = nb_cols / 2
  y = nb_lines / 2

  Curses.setpos(y, x)
  Curses.addstr("Number of lines: #{nb_lines},")
  Curses.setpos(y+1, x)
  Curses.addstr("Number of columns #{nb_cols}")
  Curses.refresh
  Curses.getch
ensure
  Curses.close_screen
end

