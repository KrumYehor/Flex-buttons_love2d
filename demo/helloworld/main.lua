local buttons = require("libs.buttons.buttons") -- Load the buttons library into the 'buttons' table

function love.load()
    -- Toggle debug mode twice to show figures and borders
    buttons:toggleDebug()
    buttons:toggleDebug()
    
    -- Create a circular button with a radius of 40 at coordinates (500, 350)
    local circle = buttons:newCircle(500, 350, 40)
    
    -- Create a rectangular button with width 200 and height 100 at coordinates (500, 450)
    local rect = buttons:newRect(500, 450, 200, 100)
    
    -- Create a polygon button with vertices at specified coordinates
    local poly = buttons:newPoly(500, 650, {0, 0, 80, 80, 160, 0})

    -- Define click callbacks for the buttons
    circle:setClick(function() print("Circle button clicked!") end)
    rect:setClick(function() print("Rectangle button clicked!") end)
    poly:setClick(function() print("Polygon button clicked!") end)
end

function love.update(dt)
    -- Update button states to enable hover and interaction functionality
    buttons:updateMain()
end

function love.draw()
    -- Draw all buttons on the screen
    buttons:draw()
end

function love.mousepressed(x, y, button, istouch, presses)
    -- Handle mouse click events by updating button states
    buttons:updateMouseClick(x, y, button, istouch, presses)
end

function love.mousereleased(x, y, button, istouch, presses)
    -- Handle mouse release events (must be paired with a click event for proper functionality)
    buttons:updateMouseRelease(x, y, button, istouch, presses)
end
