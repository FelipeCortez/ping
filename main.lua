function love.load()
  y = 200.0
end

function love.draw()
  love.graphics.circle("line", 200, y, 10)
end

function love.update(dt)
  y = y + (dt * 15)
end
