local buttons = require("libs.buttons.buttons") -- Load the buttons library into the 'buttons' table
local circle_button

function love.load()
  -- Toggle debug mode twice to show figures and borders
  buttons:toggleDebug()
  buttons:toggleDebug()
  
  -- Create circular buttons with specific coordinates and radius
  a = buttons:newCircle(500, 50, 40)
  b = buttons:newCircle(500, 130, 40)
  c = buttons:newCircle(500, 210, 40)
  d = buttons:newCircle(500, 290, 40)

  print (tostring(a:hasBorderCallback())) --false

  -- Set the hover callback for each button; the border only reacts if a callback exists
  buttons:mainUpdateCycle(
    function (self, layer_key, button_id, button)
      button:setBorderHover(function() end)
    end
  )

  print (tostring(a:hasBodyCallback())) -- false
  print (tostring(a:hasBorderCallback())) -- true

  a:setHover(function ()end)
  print (tostring(a:hasBodyCallback()))-- true
  -- Coordinates for the point where buttons will be deleted
  xm, ym = 500, 500
end

function love.update(dt)
  -- Update buttons to enable hover functionality
  buttons:updateMain()
end

function love.draw()
  -- Draw buttons along with their borders
  buttons:draw()

  -- Draw the point that will be used to check button deletion
  love.graphics.setPointSize(5)
  love.graphics.points(xm, ym)

  -- Move buttons downward and delete them if they overlap the point
  buttons:mainUpdateCycle(
    function (self, layer_key, button_id, button)
      button:setY(button:getY() + 0.8)
      if button:isPointInBody(xm, ym) then
        button:del()
      end
    end
  )
  -- Increase button radius and decrease it if the point overlaps the button border
  buttons:mainUpdateCycleReversed(
    function (self, layer_key, button_id, button)
      button:setRadius(button:getRadius() + 0.05)
      if button:isPointInBorder(xm, ym) then
        button:setRadius(button:getRadius() - 0.75)
      end
    end
  )
end

