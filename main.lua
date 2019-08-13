function intersect(ax, bx, ay, by, cx, cy, r)
  -- from https://math.stackexchange.com/a/275537/693949
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

function init()
  paddle_rotation = - math.pi

  ballx = 150
  bally = 300

  ballvx = 0
  ballvy = 0

  paddle_offset = 0

  hit = false
end

function love.load()
  ww, wh, _ = love.window.getMode()

  paddle_len = 50
  ballr = 5
  g = 150

  ground_y = 400
  ground_len = 400

  net_h = 45

  paddle_r = 40

  rvel = 5

  hit_v = 200

  init()
end

function love.update(dt)
  paddle_intersect = false
  ground_intersect = false

  -- dt = 2 * dt

  -- if love.keyboard.isDown("lshift") then
  --   kvel = 170
  -- end

  -- if love.keyboard.isDown("left") then
  --   paddle_midpoint_x = paddle_midpoint_x - (kvel * dt)
  -- end

  -- if love.keyboard.isDown("right") then
  --   paddle_midpoint_x = paddle_midpoint_x + (kvel * dt)
  -- end

  -- if love.keyboard.isDown("up") then
  --   paddle_midpoint_y = paddle_midpoint_y - (kvel * dt)
  -- end

  -- if love.keyboard.isDown("down") then
  --   paddle_midpoint_y = paddle_midpoint_y + (kvel * dt)
  -- end

  if love.keyboard.isDown("left") then
    paddle_rotation = paddle_rotation - (rvel * dt)
  end

  if love.keyboard.isDown("right") then
    paddle_rotation = paddle_rotation + (rvel * dt)
  end

  if love.keyboard.isDown("r") then
    init()
  end

  if hit then
    ballvy = ballvy + (g * dt)
  end

  paddle_offset = paddle_offset * 0.80

  paddle_midpoint_x = ballx + (paddle_r * math.cos(paddle_rotation) * (1 - paddle_offset))
  paddle_midpoint_y = bally + (paddle_r * math.sin(paddle_rotation) * (1 - paddle_offset))

  halflen = (paddle_len / 2)
  paddle_x1 = paddle_midpoint_x - (halflen * math.cos(paddle_rotation + math.pi / 2))
  paddle_y1 = paddle_midpoint_y - (halflen * math.sin(paddle_rotation + math.pi / 2))
  paddle_x2 = paddle_midpoint_x + (halflen * math.cos(paddle_rotation + math.pi / 2))
  paddle_y2 = paddle_midpoint_y + (halflen * math.sin(paddle_rotation + math.pi / 2))

  iterations = 15
  for i=1,iterations do
    ballxtemp = ballx + (dt * ballvx * i / iterations)
    ballytemp = bally + (dt * ballvy * i / iterations)

    if intersect((ww / 2) - (ground_len / 2), (ww / 2) + (ground_len / 2), ground_y, ground_y, ballxtemp, ballytemp, ballr) then
      ground_intersect = true
      ballvx, ballvy = reflect(ballvx, ballvy, (ww / 2) - (ground_len / 2), (ww / 2) + (ground_len / 2), ground_y, ground_y)
      ballvx = ballvx * 0.85
      ballvy = ballvy * 0.80
      break
    end

    if intersect((ww / 2), ground_y, (ww / 2), ground_y - net_h, ballxtemp, ballytemp, ballr) then
      ground_intersect = true
      ballvx, ballvy = reflect(ballvx, ballvy, (ww / 2), ground_y, (ww / 2), ground_y - net_h)
      ballvx = ballvx * 0.75
      ballvy = ballvy * 0.75
      break
    end
  end

  ballx = ballx + (dt * ballvx)
  bally = bally + (dt * ballvy)

  paddle_midpoint_x = ballx + (paddle_r * math.cos(paddle_rotation))
  paddle_midpoint_y = bally + (paddle_r * math.sin(paddle_rotation))
end

function love.draw()
  if paddle_intersect or ground_intersect then
    love.graphics.clear(0.5, 0, 0)
  else
    love.graphics.clear(0, 0, 0)
  end

  -- arc
  love.graphics.setColor(0.3, 0.3, 0.3)

  segs = 32
  for i=1,segs,2 do
    love.graphics.arc("line", "open", ballx, bally, paddle_r, (i - 1) * (math.pi * 2 / segs), (i) * (math.pi * 2 / segs))
  end

  -- paddle
  love.graphics.setColor(1, 1, 1)
  love.graphics.line(paddle_x1, paddle_y1, paddle_x2, paddle_y2)

  -- ball
  love.graphics.circle("line", ballx, bally, ballr)

  -- ground
  love.graphics.line((ww / 2) - (ground_len / 2), ground_y, (ww / 2) + (ground_len / 2), ground_y)

  -- net
  love.graphics.line((ww / 2), ground_y, (ww / 2), ground_y - net_h)
end

function love.keypressed(key, scancode, isrepeat)
  if key == "z" then
    ballvx = - hit_v * math.cos(paddle_rotation)
    ballvy = - hit_v * math.sin(paddle_rotation)
    paddle_offset = 1
    hit = true
  end

  if key == "x" then
    ballvx = - hit_v * 1.25 * math.cos(paddle_rotation)
    ballvy = - hit_v * 1.25 * math.sin(paddle_rotation)
    paddle_offset = 1
    hit = true
  end
end
