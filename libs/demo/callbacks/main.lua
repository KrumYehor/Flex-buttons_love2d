local buttons = require("libs.buttons.buttons") -- Load the buttons library into the 'buttons' table
local click = false
local hover = false

function love.load()
    -- Toggle debug mode four times to enable figure and border visibility
    buttons:toggleDebug()
    buttons:toggleDebug()
    buttons:toggleDebug()
    buttons:toggleDebug()

    -- Create a circular button with a radius of 40 at coordinates (500, 350)
    local button = buttons:newCircle(500, 350, 40)
      
    -- Called every frame when the mouse is hovering over the button's border.
    button:setBorderHover(function (self, xm, ym, dx, dy)
      print("Mouse is over the button border at:", xm, ym)
    end)

    -- Called once when the mouse leaves the button's border.
    button:setBorderUnHover(function (self, xm, ym, dx, dy)
      print("Mouse left the button border.")
    end)

    -- Called once when the mouse enters the button area (inside the button).
    button:setHover(function (self, xm, ym, dx, dy)
      print("Mouse entered the button area.")
    end)

    -- Called once when the mouse leaves the button area (inside the button).
    button:setUnHover(function (self, xm, ym, dx, dy)
      print("Mouse left the button area.")
    end)
 
    -- Called once when the button's border is clicked.
    button:setClickBorder(function (self, xm, ym, button)
      print("Clicked on the button border. Mouse button:", button)
    end)

    -- Called once when the button's area is clicked.
    button:setClick(function (self, xm, ym, button)
      print("Button clicked. Mouse button:", button)
    end)

    -- Called once when the mouse button is released inside the button area.
    button:setRelease(function (self, xm, ym, button)
      print("Button released. Mouse button:", button)
    end)

    -- Called once when the mouse button is released on the button's border.
    button:setReleaseBorder(function (self, xm, ym, button)
      print("Released on the button border. Mouse button:", button)
    end)

    -- Called every time the user scrolls, capturing the scroll direction and amount.
    button:setScroll(function (self, dxm, dym)
      print("Scrolled with dx:", dxm, "dy:", dym)
    end)

    -- Called every time the mouse moves over the button.
    button:setWhileMoves(function (self, xm, ym, dx, dy, istouch)
      print("Mouse moved to:", xm, ym)
    end)

    -- Called every frame while the mouse is hovering over the button's border.
    button:setWhileBorderHover(function (self, xm, ym, dx, dy)
      hover = "Hover border" -- Update hover state
    end)

    -- Called every frame while the mouse is hovering over the button area.
    button:setWhileHover(function (self, xm, ym, dx, dy)
      hover = "Hover" -- Update hover state
    end)

    -- Called every frame while the button's border is pressed (even if the mouse leaves the border).
    button:setWhileBorderPressed(function (self, xm, ym, dx, dy)
      click = "border" -- Update click state
    end)

    -- Called every frame while the button is pressed (even if the mouse leaves the button area).
    button:setWhilePressed(function (self, xm, ym, dx, dy)
      click = "body" -- Update click state
    end)
end

function love.update(dt)
    -- Update the buttons each frame to track hover states and manage interactions.
    buttons:updateMain()
end

function love.draw()
    -- Render all the buttons on the screen.
    buttons:draw()

    -- Display current hover state.
    if(hover) then
      love.graphics.print("Current hover: " .. hover, 300, 300)
    end 

    -- Display current click state.
    if(click) then
      love.graphics.print("Current pressed: " .. click, 300, 320)
    end 

    -- Reset hover and click states.
    click = nil
    hover = nil
end

---------------------
--- Set up input update functions
--- Do not separate mouse click and release callbacks as it may cause issues.
---------------------

function love.mousepressed(xm, ym, button, istouch)
  -- Trigger the click callbacks when the mouse is pressed.
  buttons:updateMouseClick(xm, ym, button)
end

function love.mousereleased(xm, ym, button)
  -- Trigger the release callbacks when the mouse button is released.
  buttons:updateMouseRelease(xm, ym, button)
end

function love.wheelmoved(xwd, ywd)  
  -- Trigger scroll callbacks when the mouse wheel is moved.
  buttons:updateMouseScroll(xwd, ywd)
end

function love.mousemoved(xm, ym, dx, dy, istouch)  
  -- Trigger move callbacks when the mouse is moved.
  buttons:updateMouseMoves(xm, ym, dx, dy, istouch)
end
