local buttons = require("libs.buttons.buttons") -- Load the buttons library into the 'buttons' table
local click = false
local hover = false
local button, button2, button3, button4
local w, h, r

-- Function for cyclic motion (bouncing effect)
-- This function returns a closure that bounces between the start and end values
  local function bounce(startCounter, endCounter, step)
      local counter = startCounter
      local state = true
      return function ()
        -- Increase the counter until it reaches the end value, then reverse direction
        if counter <= endCounter and state then
          counter = counter + step
        elseif counter >= endCounter and state then
          state = false
        end
        -- Decrease the counter until it reaches the start value, then switch back
        if not state and counter >= startCounter then
          counter = counter - step
        end
        -- Switch direction if the counter falls below the start value
        if not state and counter <= startCounter then
          state = true
        end

        return counter
      end
  end

-- Bouncing functions with different ranges and steps
local bounce1 = bounce(50, 100, 1)
local bounce2 = bounce(50, 100, 0.5)
local bounce3 = bounce(550, 600, 0.5)
local bounce4 = bounce(1, 60, 1)
local bounce5 = bounce(100, 150, 1)

function love.load()
    -- Toggle debug mode to display button borders and figures
    buttons:toggleDebug()
    buttons:toggleDebug()
    buttons:toggleDebug()
    buttons:toggleDebug()
    -- Set buttons layer (to manage rendering order)
    buttons:setLayer(5)

    -- Create rectangular and circular buttons with different sizes and coordinates
    button = buttons:newRect(380, 400, 80, 210)
    button2 = buttons:newCircle(550, 200, 40)
    button3 = buttons:newRect(50, 350, 80, 80)
    button4 = buttons:newPoly(700, 400, {0, 0, 50, 50, 100, 0})

    -- Set a border hover function (required for border functionality)
    button:setBorderHover(function () end)
end

function love.update(dt)
    -- Update button states, including hover and press status

    -- Check if the button's border is hovered
    if button:isBorderHover() then
      hover = "hover border"
    end
    -- Check if the button itself is hovered
    if button:isHover() then
      hover = "hover"
    end

    -- Apply bounce motion to the button's width and height
    button:setWidth(bounce1())
    button:setHeight(bounce2())

    -- Check if the button's body or border is pressed
    local isPressed = button:isPressed()
    local isBorderPressed = button:isBorderPressed()
    if isPressed[1] or isPressed[2] or isPressed[3] then
      click = "body"
    end
    if isBorderPressed[1] or isBorderPressed[2] or isBorderPressed[3] then
      click = "border"
    end

    -- Apply bounce motion to button2's X-coordinate
    local b3result = bounce3()
    button2:setX(b3result)

    -- Store the original radius of button2 if not already stored
    if not r then
      r = button2:getRadius()
    end
    -- Adjust the radius of button2 based on the bouncing effect
    button2:setRadius(r + b3result - 550)

    -- Apply bounce motion to button3's Y-coordinate
    button3:setY(bounce3() - 200)

    -- Store the original size of button3 if not already stored
    if not w and not h then
      w, h = button3:getSize()
    end
    -- Adjust the size of button3 based on the bounce effect
    local b5result = bounce5()
    button3:setSize(w + b5result, h + b5result)

    -- Apply bounce motion to button4's vertices (for polygonal button)
    local b4result = bounce4()
    local vertices = button4:getVertex()

    -- Modify vertices depending on the bounce state
    if b4result < 30 then
      for k, p in pairs(vertices) do
        vertices[k] = p + 1
      end
    else
      for k, p in pairs(vertices) do
        vertices[k] = p - 1
      end
    end
    button4:setVertex(vertices)

    -- Update all buttons to ensure interactivity
    buttons:updateMain()
end

function love.draw()
    -- Render all buttons
    buttons:draw()

    -- Display hover and click status if they are active
    if hover then
      love.graphics.print("button hover: " .. hover, 300, 300)
    end

    if click then
      love.graphics.print("button pressed: " .. click, 300, 320)
    end

    -- Display button information such as ID, type, layer, and size
    love.graphics.print("ID: " .. button:getID(), 300, 340)
    love.graphics.print("type: " .. button:getType(), 300, 360)
    love.graphics.print("layer: " .. button:getLayer(), 300, 380)
    love.graphics.print("Width: " .. button:getWidth(), 300, 400)
    love.graphics.print("Height: " .. button:getHeight(), 300, 420)

    -- Reset hover and click states for the next frame
    click = nil
    hover = nil
end

---------------------
--- Set up input update functions
--- Keep mouse click and release handling together to avoid input issues.
---------------------

function love.mousepressed(xm, ym, button, istouch)
  -- Trigger click callbacks when the mouse is pressed
  buttons:updateMouseClick(xm, ym, button)
end

function love.mousereleased(xm, ym, button)
  -- Trigger release callbacks when the mouse is released
  buttons:updateMouseRelease(xm, ym, button)
end
