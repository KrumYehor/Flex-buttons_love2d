local buttons = require("libs.buttons.buttons") -- Load the buttons library into the 'buttons' table

function love.load()
    -- Toggle debug mode twice to show figures and borders
    buttons:toggleDebug()
    buttons:toggleDebug()

    -- Create a circular button at (500, 350) with a radius of 300
    a = buttons:newCircle(500, 350, 300)
    
    -- Set the border check width for hover detection
    buttons:getBorderCheckWidht(50)

    -- Define a border hover callback for the button. 
    -- This is necessary for the border to be displayed and calculated.
   a:setBorderHover(function() end)

end

function love.update(dt)
    -- Press 'e' to enable border hover, 'd' to disable
    if love.keyboard.isDown("e") then
        buttons.enableBorderHover()
    end
    if love.keyboard.isDown("d") then
        buttons.disableBorderHover()
    end

    -- Update border check width: Increase until it reaches 15, then reset to 1
    if buttons:getBorderCheckWidht() < 15 then    
        buttons:setBorderCheckWidht(buttons:getBorderCheckWidht() + 0.08)
    else
        buttons:setBorderCheckWidht(1)
    end

    -- Update buttons to enable hover functionality
    buttons:updateMain()
end

function love.draw()
  
  love.graphics.print("press e to enable \n or d to disable border",10,300)

    -- Draw all buttons along with their borders
    buttons:draw()
end

