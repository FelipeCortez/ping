function intersect(x1, x2, y1, y2, cx, cy, cr)
  x1 = x1 - cx
  x2 = x2 - cx
  y1 = y1 - cy
  y2 = y2 - cy
  dx = x2 - x1
  dy = y2 - y1
  dr_squared = dx ^ 2 + dy ^ 2
  D = x1 * y2 - x2 * y1
  return cr ^ 2 * dr_squared > D ^ 2
end

function love.load()
  linex1 = 150
  liney1 = 150
  linex2 = 300
  liney2 = 300

  ballx = 200
  bally = 150
  ballr = 10

  math.randomseed(os.clock()*100000000000)
end

function love.update(dt)
  bally = bally + (dt * 30)
end

function love.draw()
  if intersect(linex1, linex2, liney1, liney2, ballx, bally, ballr) then
    love.graphics.clear(0, 0, 0)
  else
    love.graphics.clear(0.5, 0, 0)
  end

  love.graphics.circle("line", 200, bally, 10)
  love.graphics.line(150, 150, 200, 200)
end

