function intersect(ax, bx, ay, by, cx, cy, r)
  ax = ax - cx
  ay = ay - cy
  bx = bx - cx
  by = by - cy
  a = (bx - ax)^2 + (by - ay)^2
  b = 2*(ax*(bx - ax) + ay*(by - ay))
  c = ax^2 + ay^2 - r^2
  disc = b^2 - 4*a*c

  if disc <= 0 then
    return false
  end

  sqrtdisc = math.sqrt(disc)
  t1 = (-b + sqrtdisc)/(2*a)
  t2 = (-b - sqrtdisc)/(2*a)

  if (0 < t1 and t1 < 1) or (0 < t2 and t2 < 1) then
    return true
  end

  return false
end

function nnormal(ax, bx, ay, by)
  x = bx - ax
  y = by - ay

  magn = math.sqrt(x ^ 2 + y ^ 2)

  return y / magn, -x / magn
end

function reflect(vx, vy, ax, bx, ay, by)
  nx, ny = nnormal(ax, bx, ay, by)

  ddotn = (vx * nx) + (vy * ny)
  ddotn = 2 * ddotn
  p2x = nx * ddotn
  p2y = ny * ddotn

  return vx - p2x, vy - p2y
end

function love.load()
  paddle_len = 100
  paddle_midpoint_x = 300
  paddle_midpoint_y = 300
  paddle_rotation = math.pi / 4

  ballx = 300
  bally = 100
  ballr = 10

  ballvx = 0
  ballvy = 0

  g = 50

  math.randomseed(os.clock()*100000000000)
end

function love.update(dt)
  kvel = 100
  rvel = 2
  ballvy = ballvy + (g * dt)
  dt = 2 * dt

  if love.keyboard.isDown("left") then
    paddle_midpoint_x = paddle_midpoint_x - (kvel * dt)
  end

  if love.keyboard.isDown("right") then
    paddle_midpoint_x = paddle_midpoint_x + (kvel * dt)
  end

  if love.keyboard.isDown("up") then
    paddle_midpoint_y = paddle_midpoint_y - (kvel * dt)
  end

  if love.keyboard.isDown("down") then
    paddle_midpoint_y = paddle_midpoint_y + (kvel * dt)
  end

  if love.keyboard.isDown("q") then
    paddle_rotation = paddle_rotation - (rvel * dt)
  end

  if love.keyboard.isDown("e") then
    paddle_rotation = paddle_rotation + (rvel * dt)
  end

  ballx = ballx + (dt * ballvx)
  bally = bally + (dt * ballvy)

  halflen = (paddle_len / 2)
  paddle_x1 = paddle_midpoint_x - (halflen * math.cos(paddle_rotation))
  paddle_y1 = paddle_midpoint_y - (halflen * math.sin(paddle_rotation))
  paddle_x2 = paddle_midpoint_x + (halflen * math.cos(paddle_rotation))
  paddle_y2 = paddle_midpoint_y + (halflen * math.sin(paddle_rotation))

  if intersect(paddle_x1, paddle_x2, paddle_y1, paddle_y2, ballx, bally, ballr) then
    ballvx, ballvy = reflect(ballvx, ballvy, paddle_x1, paddle_x2, paddle_y1, paddle_y2)
  end
end

function love.draw()
  if intersect(paddle_x1, paddle_x2, paddle_y1, paddle_y2, ballx, bally, ballr) then
    love.graphics.clear(0, 0, 0)
  else
    love.graphics.clear(0.5, 0, 0)
  end

  for x=1,800,10 do
    for y=1,800,10 do

      if intersect(paddle_x1, paddle_x2, paddle_y1, paddle_y2, x, y, ballr) then
        love.graphics.setColor(1, 1, 1)
      else
        love.graphics.setColor(1, 0, 0)
      end

      love.graphics.circle("line", x, y, 3)
    end
  end

  midpointx = (paddle_x1 + paddle_x2) / 2
  midpointy = (paddle_y1 + paddle_y2) / 2
  love.graphics.circle("line", ballx, bally, ballr)
  love.graphics.line(paddle_x1, paddle_y1, paddle_x2, paddle_y2)

  -- normal
  love.graphics.setColor(0, 0, 0)
  nx, ny = nnormal(paddle_x1, paddle_x2, paddle_y1, paddle_y2)
  love.graphics.line(midpointx, midpointy, midpointx + nx * 50, midpointy + ny * 50)

  -- velocity
  love.graphics.setColor(0, 1, 0)
  love.graphics.line(midpointx, midpointy, midpointx + ballvx, midpointy + ballvy)

  -- reflection
  rx, ry = reflect(ballvx, ballvy, paddle_x1, paddle_x2, paddle_y1, paddle_y2)
  love.graphics.setColor(0, 0, 1)
  love.graphics.line(midpointx, midpointy, midpointx + rx, midpointy + ry)

  -- debugging
  love.graphics.setColor(1, 1, 1)
  love.graphics.print(ballvx, 400, 400)
  love.graphics.print(ballvy, 400, 430)
  love.graphics.print(math.sqrt(ballvx ^ 2 + ballvy ^ 2), 400, 450)
  love.graphics.print(math.deg(paddle_rotation), 400, 470)
end

