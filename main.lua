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
  ww, wh, _ = love.window.getMode()

  paddle_len = 50
  paddle_midpoint_x = 150
  paddle_midpoint_y = 300
  paddle_rotation = 0

  ballx = paddle_midpoint_x
  bally = paddle_midpoint_y - 15
  ballr = 5

  ballvx = 0
  ballvy = -100

  g = 150

  ground_y = 400
  ground_len = 400
end

function love.update(dt)
  paddle_intersect = false
  ground_intersect = false

  kvel = 100
  rvel = 2
  ballvy = ballvy + (g * dt)
  dt = 2 * dt

  if love.keyboard.isDown("lshift") then
    kvel = 150
  end

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
    paddle_intersect = true
    ballvx, ballvy = reflect(ballvx, ballvy, paddle_x1, paddle_x2, paddle_y1, paddle_y2)
  end

  if intersect((ww / 2) - (ground_len / 2), (ww / 2) + (ground_len / 2), ground_y, ground_y, ballx, bally, ballr) then
    ground_intersect = true
    ballvx, ballvy = reflect(ballvx, ballvy, (ww / 2) - (ground_len / 2), (ww / 2) + (ground_len / 2), ground_y, ground_y)
  end
end

function love.draw()
  if paddle_intersect or ground_intersect then
    love.graphics.clear(0.5, 0, 0)
  else
    love.graphics.clear(0, 0, 0)
  end

  -- paddle
  love.graphics.setColor(1, 1, 1)
  midpointx = (paddle_x1 + paddle_x2) / 2
  midpointy = (paddle_y1 + paddle_y2) / 2
  love.graphics.line(paddle_x1, paddle_y1, paddle_x2, paddle_y2)

  -- ball
  love.graphics.circle("line", ballx, bally, ballr)

  -- ground
  love.graphics.line((ww / 2) - (ground_len / 2), ground_y, (ww / 2) + (ground_len / 2), ground_y)

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

