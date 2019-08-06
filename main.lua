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

function intersect2(ax, bx, ay, by, cx, cy, r)
  ax = ax - cx;
  ay = ay - cy;
  bx = bx - cx;
  by = by - cy;
  a = ax^2 + ay^2 - r^2;
  b = 2*(ax*(bx - ax) + ay*(by - ay));
  c = (bx - ax)^2 + (by - ay)^2;
  disc = b^2 - 4*a*c;

  if disc <= 0 then
    return false;
  end

  sqrtdisc = math.sqrt(disc);
  t1 = (-b + sqrtdisc)/(2*a);
  t2 = (-b - sqrtdisc)/(2*a);

  if (0 < t1 and t1 < 1) or (0 < t2 and t2 < 1) then
    return true;
  end

  return false;
end

function reflect(vx, vy, x1, x2, y1, y2)

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
  -- bally = bally + (dt * 30)
  ballx, bally = love.mouse.getPosition()
end

function love.draw()
  if intersect2(linex1, linex2, liney1, liney2, ballx, bally, ballr) then
    love.graphics.clear(0, 0, 0)
  else
    love.graphics.clear(0.5, 0, 0)
  end

  love.graphics.circle("line", ballx, bally, 10)
  love.graphics.line(150, 150, 200, 200)
end

