local  buttons = require("libs.buttons.methods")




------------------------------------------
--Built with love (and a bit of madness) for Love2D 11.5 
----------------------------------------------

---------------------
-- Configuration
---------------------

-- Width where hover/click border detection works methods  :getBorderCheckWidht() :setBorderCheckWidht(num)
buttons.borderCheckWidth = 5

-- If set to false, the hover border won't be displayed and calculated   buttons.enableBorderHover()  buttons.disableBorderHover()  buttons.getBorderHoverState() 
buttons.updateBorderHover = true

-- Will throw error when number exceed
-- Maximum number of buttons per layer
buttons.max_quantity_buttons_in_layer = 4000 -- Based on testing, more than 8000 rectangles drops FPS below 60 methods:setMaxQuantityButtonsInLayer(x) :getMaxQuantityButtonsInLayer(x)
-- Maximum number of layers methods:getMaxQuantityLayers(num) :setMaxQuantityLayers(num)
buttons.max_quantity_layers = 400   

---------------------
-- END Configuration
---------------------
---------------------
-- Service variables, do not change
---------------------

buttons.IsDownBorderMain = {false,false,false} -- is some mouse button pressed on border
buttons.IsDownMain= {false,false,false} -- is some mouse button pressed on body

buttons.translate = {}
buttons.translate.x = 0 -- Translates all buttons. Use buttons:setTranslateX() to modify
buttons.translate.y = 0 -- Translates all buttons. Use buttons:setTranslateY() to modify
buttons.scale = 1       -- Scales all buttons. Use buttons:setScale() to modify

-- Use buttons:toggleDebug() to change the debug state
buttons.debug     = false
buttons.debugText = false
buttons.debugLine = false
buttons.debugBorderHover = false

buttons.layers = {} -- Stores layers

buttons.layers[1] = {} -- Stores buttons
buttons.current_layer = 1 -- Sets the current active layer for adding new button

buttons.mousePosition = {} -- Stores the mouse delta between updates

local rclr = {} -- Contains random colors for buttons in debug mode

buttons.hover_lock = false -- Prevents hover functionality
buttons.Prev_hover  = false -- Stores the previous or currently hovered button (either on the body or border)
buttons.updateTime = 0 -- Time between updates for debug rendering

---------------------
-- Types of buttons -  number : name  
-- 1: rectangle
-- 2: circle 
-- 3: polygon
---------------------

--- Creates a new circle in the current layer

---@param x number X-coordinate of the circle's center
---@param y number Y-coordinate of the circle's center
---@param r number Radius of the circle
function buttons:newCircle( x, y, r)
    local btn = self:GetBtnBase(x, y, self:idCreate(), 2, { r = r }) -- Gets the base table for the button with type 2 and adds the radius
    self.layers[btn.layer][btn.id] = btn -- Adds the button to the layer
    return self.layers[btn.layer][btn.id] -- Returns a reference to the button
end

--- Creates a new rectangle in the current layer
---@param x number X-coordinate of the rectangle's top-left corner
---@param y number Y-coordinate of the rectangle's top-left corner
---@param w number Width of the rectangle
---@param h number Height of the rectangle
function buttons:newRect( x, y, w, h)
    local btn = self:GetBtnBase(x, y, self:idCreate(), 1, { h = h, w = w }) -- Gets the base table for the button with type 1 and adds width and height
    self.layers[btn.layer][btn.id] = btn -- Adds the button to the layer
    return self.layers[btn.layer][btn.id] -- Returns a reference to the button
end

--- Creates a new polygon in the current layer
---@param x number X-coordinate of the polygon's reference point
---@param y number Y-coordinate of the polygon's reference point
---@param vertex table List of vertex coordinates for the polygon
function buttons:newPoly( x, y, vertex)
    local btn = self:GetBtnBase(x, y, self:idCreate(), 3, { vertex = vertex }) -- Gets the base table for the button with type 3 and adds vertices
    self.layers[btn.layer][btn.id] = btn -- Adds the button to the layer
    return self.layers[btn.layer][btn.id] -- Returns a reference to the button
end


--- draws all buttons and debug info use button:toggleDebug() to change amount of info
function buttons:draw()

    -- Main cucle for drawing and printing
    if self.debug then
        self:mainUpdateCycleReversed( function (self,layer,key,btn)
            local x, y = self:Scale(math.floor(btn.x * 10^1) / 10^1, math.floor(btn.y * 10^1) / 10^1) -- Translate the button's coordinates with scaling and rounding
            x,y = self:Translate(x,y)
            if btn.id == nil then goto skip end -- Skip if the button has no ID

            -- Initialize random colors for the button if not already set
            if not rclr[key] then rclr[key] = {} end
            if not rclr[key][1] then rclr[key][1] = math.random(3, 8) / 10 end -- Red color component
            if not rclr[key][2] then rclr[key][2] = math.random(3, 8) / 10 end -- Green color component
            if not rclr[key][3] then rclr[key][3] = math.random(3, 8) / 10 end -- Blue color component

            -- Set the button color: if disabled, apply gray with transparency
            if btn.Disabled then
                love.graphics.setColor(0.4, 0.4, 0.4, 0.5)
            else
                -- Set the random color for the button
                love.graphics.setColor(rclr[key][1], rclr[key][2], rclr[key][3], 1)
            end

            -- If the button is hovered, change its color to light gray
            if btn.IsHover then
                love.graphics.setColor(0.8, 0.8, 0.8, 1)
            end

            -- Change color based on which mouse button is pressed
            if btn.IsDown[1] == 1 then
                love.graphics.setColor(1, 0, 0, 0.2) -- Left mouse button pressed, set red color
            elseif btn.IsDown[2] == 1 then
                love.graphics.setColor(0, 1, 0, 0.2) -- Right mouse button pressed, set green color
            elseif btn.IsDown[3] == 1 then
                love.graphics.setColor(0, 0, 1, 0.2) -- Middle mouse button pressed, set blue color
            end

            if (btn.type == 1) then -- Check if the button is a rectangle
                local w, h = self:Scale(btn.w, btn.h) -- Scale the width and height of the button
                
                -- Set color to gray if the layer or button is disabled
                if ( btn.Disabled) then
                    love.graphics.setColor(0.5, 0.5, 0.5)
                end

                love.graphics.rectangle("fill", x, y, w, h) -- Draw the filled rectangle for the button
                -- Draw a line where the BorderHover is called in debug mode
                if (self.debugLine) then
                    love.graphics.setColor(1, 0, 0.8) -- Set color for debug line

                    -- Set gray color if the layer or button is disabled
                    if ( btn.Disabled) then
                        love.graphics.setColor(0.5, 0.5, 0.5)
                    end

                    love.graphics.setPointSize(4) -- Set point size for debug points
                    love.graphics.setLineWidth(2) -- Set line width for debug lines
                    
                    -- Define the points for the rectangle's corners
                    local points = {x, y, x, y + h, x + w, y + h, x + w, y}
                    local origin ={}
                    -- Store original coordinates without scaling or transforming
                    origin.points = {
                        math.floor(btn.x * 10) / 10,
                        math.floor(btn.y * 10) / 10,
                        math.floor(btn.y * 10) / 10 + btn.h,
                        math.floor(btn.x * 10) / 10 + btn.w,
                        math.floor(btn.y * 10) / 10 + btn.h,
                        math.floor(btn.x * 10) / 10 + btn.w,
                    }
               
                    love.graphics.points(points) -- Draw debug points at the corners

                    -- Print the coordinates of the points above the respective points
                    for i = 1, #origin.points - 1, 2 do
                        love.graphics.print("x:" .. origin.points[i] .. " y:" .. origin.points[i+1], points[i], points[i+1] - 20)
                    end
                    love.graphics.rectangle("line", x, y, w, h) -- Draw a border around the rectangle
                end

                -- Draw BorderHovers in debug mode if enabled
                if ( btn:hasBorderCallback() and  self.debugBorderHover and self.updateBorderHover  ) then
                    if (  btn.IsBorderHover) then
                        love.graphics.setColor(1, 0, 0) -- Set color to red if hovering
                    elseif (  not btn.IsBorderHover) then
                        love.graphics.setColor(0.5, 0, 0, 0.5) -- Set semi-transparent gray if not hovering
                    end

                    -- Set gray color if the layer or button is disabled
                    if ( btn.Disabled) then
                        love.graphics.setColor(0.5, 0.5, 0.5)
                    end
                    love.graphics.setLineWidth(self.borderCheckWidth * 2) -- Set line width for the hover border
                    love.graphics.rectangle("line", x, y, w, h) -- Draw the hover border around the rectangle
                end
                love.graphics.setColor(1, 1, 1) -- Reset color to white for further drawings
                love.graphics.setLineWidth(1) -- Reset line width to default
                origin = nil -- Clear the origin variable
            elseif (btn.type == 3) then -- Check if the button is a polygon
                local vertex_temp = {} -- Temporary table to hold the scaled vertex positions
                for i = 1, #btn.vertex, 1 do
                    if (i % 2 == 1) then
                        vertex_temp[i] = self:Scale(btn.vertex[i]) + x -- Scale and translate the x-coordinate
                    else
                        vertex_temp[i] = self:Scale(btn.vertex[i]) + y -- Scale and translate the y-coordinate
                    end
                end

                love.graphics.polygon("fill", vertex_temp) -- Draw the filled polygon using the scaled vertices
            
                -- Draw BorderHover if enabled in debug mode
                if (self.debugBorderHover  and self.updateBorderHover   ) then
                    if ( btn:hasBorderCallback() and   btn.IsBorderHover) then
                        love.graphics.setColor(1, 0, 0) -- Set color to red if hovering
                    else
                        love.graphics.setColor(1, 0, 0, 0.5) -- Set semi-transparent red if not hovering
                    end
                    
                    -- Set gray color if the layer or button is disabled
                    if ( btn.Disabled) then
                        love.graphics.setColor(0.5, 0.5, 0.5)
                    end
                    
                    love.graphics.setLineWidth(self.borderCheckWidth * 2) -- Set line width for the hover border
                    love.graphics.polygon("line", vertex_temp) -- Draw the hover border around the polygon
                end
            
                -- Draw debug lines if debugging is enabled
                if (self.debugLine) then
                    love.graphics.setColor(0.5, 0.5, 0.5, 0.2) -- Set color for debug lines
                    if ( btn.Disabled) then
                        love.graphics.setColor(0.5, 0.5, 0.5) -- Set color to gray if disabled
                    end
                    
                    love.graphics.setLineWidth(self.borderCheckWidth) -- Set line width for debug lines
                    love.graphics.polygon("line", vertex_temp) -- Draw the polygon outline for debugging
            
                    local tring = love.math.triangulate(vertex_temp) -- Triangulate the polygon for debugging
            
                    love.graphics.setLineWidth(1) -- Reset line width for the triangulated lines
                    love.graphics.setColor(1, 0, 1, 0.5) -- Set color for triangulated lines
                    for k, v in pairs(tring) do
                        love.graphics.polygon("line", v) -- Draw each triangle from the triangulation
                    end
                    
                    love.graphics.setColor(1, 0, 0.8) -- Set color for vertex debug output
                    
                    -- Print the coordinates of the polygon vertices
                    for x = 1, #vertex_temp, 2 do
                        love.graphics.print("x:" .. math.floor((btn.vertex[x] + btn.x) * 10^1) / 10^1 .. " y:" .. math.floor((btn.vertex[x + 1] + btn.y) * 10^1) / 10^1, vertex_temp[x],
                            vertex_temp[x + 1] - 20)
                    end
                    
                    love.graphics.setPointSize(4) -- Set point size for vertex points
                    love.graphics.points(vertex_temp) -- Draw the vertex points for debugging
                end
                
                origin = nil -- Clear the origin variable
            elseif (btn.type == 2) then -- Check if the button is a circle
                local r = self:Scale(btn.r) -- Scale the radius of the circle
                love.graphics.circle("fill", x, y, r) -- Draw the filled circle at position (x, y) with radius r
            
                -- Draw debug lines (white) and borders
                if (self.debugLine) then
                    love.graphics.setColor(1, 1, 1) -- Set color to white for debug lines
                    if ( btn.Disabled) then
                        love.graphics.setColor(0.5, 0.5, 0.5) -- Set color to gray if the layer or button is disabled
                    end
                    
                    love.graphics.setLineWidth(2) -- Set line width for the debug outline
                    love.graphics.circle("line", x, y, r) -- Draw the outline of the circle
                    love.graphics.setColor(1, 0, 0.8) -- Set color for the debug point
                    love.graphics.setPointSize(4) -- Set point size for the debug point
                    
                    love.graphics.points(x, y) -- Draw a point at the center of the circle for debugging
                end
            
                -- Draw BorderHover if enabled in debug mode
                if (self.debugBorderHover and self.updateBorderHover   ) then
                    if ( btn:hasBorderCallback() and   btn.IsBorderHover) then
                        love.graphics.setColor(1, 0, 0) -- Set color to red if hovering over the border
                    elseif ( btn:hasBorderCallback() and  not btn.IsBorderHover) then
                        love.graphics.setColor(0.5, 0, 0, 0.5) -- Set semi-transparent red if not hovering
                    end
                    
                    -- Set gray color if the layer or button is disabled
                    if ( btn.Disabled) then
                        love.graphics.setColor(0.5, 0.5, 0.5) -- Set color to gray
                    end
                    
                    love.graphics.setLineWidth(self.borderCheckWidth * 2) -- Set line width for the hover border
                    love.graphics.circle("line", x, y, r) -- Draw the hover border around the circle
                end
            
                origin = nil -- Clear the origin variable
            
            end
    
            love.graphics.setColor(1, 0, 0.8)
            local info = "Absolute postion"
    
            x = math.floor(x * 10^1) / 10^1
            y = math.floor(y * 10^1) / 10^1
            
            info = info .. " X:" .. x .. " Y:" .. y
            --- button info
            if (self.debugText) then
                love.graphics.print(info, x - 20, y - 80, 0)
            end
            info = " layer: " .. btn.layer
    
            info = info .. " relative postion"
    
            info = info .. " X:" .. math.floor(  btn.x* 10^1) / 10^1 .. " Y:" .. math.floor(  btn.y* 10^1) / 10^1
            if (btn.IsDown[1] == 1) then
                info = info .. " ,clck: 1"
            end
            if (btn.IsDown[2] == 1) then
                info = info .. " ,clck: 2"
            end
            if (btn.IsDown[3] == 1) then
                info = info .. ", clck: 3"
            end
            if (btn.IsHover) then
                info = info .. " Hover "
            end
            if ( btn:hasBorderCallback() and   btn.IsBorderHover) then
                info = info .. " , Border hover "
            end
            --- button info
            if (self.debugText) then
                love.graphics.print("Number : " .. key .. " " .. info, x - 20, y - 60)
            end
    
            ::skip::
        end)    
  
    -- Displays debug information in the top-left corner of the screen

        local xm, ym = love.mouse.getPosition() -- Get the current mouse position
        local length = 0 -- Total number of buttons across all layers
        local l, b = 0, 0 -- Counters for layers and buttons
        local layers_text = "" -- String to hold text

        -- Iterate through each layer and count the buttons
        for layer_n, layer in pairs(self.layers) do
            l = l + 1 -- Increment layer count
            for btn_n, btn in pairs(layer) do
                b = b + 1 -- Count buttons in the current layer
            end
            -- Append layer information to the layers_text string
            layers_text = layers_text .. ("\n layer #" .. layer_n .. " buttons: " .. b .. " max: " .. self.max_quantity_buttons_in_layer)
            
            length = length + b -- Add current layer button count to the total
            b = 0 -- Reset button count for the next layer
        end

        -- Calculate mouse position relative to button layers (accounting for scale and translation)
        local dmpXs = (xm / self:getScale() - self:getTranslateX())
        local dmpYs = (ym / self:getScale() - self:getTranslateY())

        -- Prepare the debug text to display
        local text =
            "Buttons debug data: \n" .. 
            "Mouse position in button layers x: " .. math.floor(dmpXs * 10^1) .. " y: " .. math.floor(dmpYs * 10^1) ..
            "\n Absolute mouse position x: " .. math.floor(xm * 10^1) .. " y: " .. math.floor(ym * 10^1) ..
            "\n FPS: " .. love.timer.getFPS() ..
            "\n Hover block state: " .. tostring(self.hover_lock) ..
            "\n Main update time: " .. (math.floor(self.updateTime * 1000 * 10^1)) .. " *10^-3 s"..
            "\n IsBorderHoverActive: " .. tostring(self.updateBorderHover)
        -- Check if there was a hover event in the previous frame
        if self.Prev_hover and self.Prev_hover.layer then
            text = text .. "\n Hover in previous frame button: " .. self.Prev_hover.id .. " layer: " .. self.Prev_hover.layer
        else
            text = text .. "\n Previous hover: nil"
        end

        -- Append additional information about scale, translation, and button/layer quantities
        text = text .. "\n Scale: " .. self.scale ..
            "\n Translation x: " .. self.translate.x .. " y: " .. self.translate.y ..
            "\n Number of layers: " .. tostring(#self.layers) .. " max: " .. self.max_quantity_layers ..
            "\n Total buttons: " .. length .. "\n" .. layers_text

        -- Set color to white and display the debug text
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.print(text, 10, 10)

    end
end

--- main update cycle. Calls hover,unhover, whilehover  body/border
---@param dt at love.update
function buttons:updateMain(dt)
    -- saves time
    local Time
    if self.debug  then
        Time = love.timer.getTime()
    end
    -- *
    -- get mouse delta so function can be called only in update and all callbacks can get mouse delta 
    local xm = love.mouse.getX()
    local ym = love.mouse.getY()
    local dx = 0
    local dy = 0
    if (self.mousePosition.x) then
        dy = ym - self.mousePosition.y
        dx = xm - self.mousePosition.x
    end
    dx,dy = self:TranslateCorrectMouse(dx,dy) --- correct mouse. It will work when buttons has changed translation or/and scale 
    self.mousePosition.x = xm
    self.mousePosition.y = ym


    local ButtonsIsPressed = false -- checks if some button pressed on body or border
    for s = 1, 3, 1 do
        ButtonsIsPressed = ButtonsIsPressed or self.IsDownBorderMain[s]
        ButtonsIsPressed = ButtonsIsPressed or self.IsDownMain[s]
    end
    
    self:mainUpdateCycle(
        function (self, layer, key, btn) 
            btn = self.layers[layer][key]
            if (btn and not btn.Disabled ) then -- Proceed only if the button is not disabled
            
                -- Check for border hover calls
                if btn:hasBorderCallback() and self.updateBorderHover and btn:isPointInBorder(xm, ym)  and not ButtonsIsPressed then
  
                    if (not self.hover_lock and not btn.IsBorderHover) then -- If the cursor is on the button and hover border state is false
                        self.Prev_hover = btn -- Save the currently hovered button
                        self.hover_lock = true -- Enable hover lock
                        btn.IsBorderHover = true -- Set the border hover state to true
                        if (btn.BorderHover) then
                            btn:BorderHover(xm, ym, dx, dy) -- CalIsBorderDownl the hover border function
                            self:hover_lock_check(self.layers[layer][key]) -- Check if the button was deleted, then turn off hover lock
                        end
                    end
                    
                    -- If another button is already hovered or this button has a lower layer/position
                    -- or this button has hover but mouse on border element of button so it will be BorderHover 
                    if (self.hover_lock and self.Prev_hover and not ButtonsIsPressed and
                        (
                            self.Prev_hover.layer 
                            > layer or 

                            (self.Prev_hover.layer == layer and self.Prev_hover.id > key) 
                            
                            or (btn.IsHover and self.Prev_hover.layer == layer and self.Prev_hover.id == key)
                        )) then
        
                        -- Make the previous button unhovered
                        if(btn.UnHover) then btn.UnHover(xm, ym, dx, dy)  end
                        if(btn.BorderHover) then btn.BorderHover(xm, ym, dx, dy)  end
                        self.Prev_hover.IsBorderHover = false
                        self.Prev_hover.IsHover = false
                        self.Prev_hover = nil -- Clear the reference to the previous button
                        -- Save the current button as hovered
                        self.Prev_hover = btn

                        btn.IsBorderHover = true -- Enable border hover state
                    end
        
                    if (self.layers[layer][key] and btn.WhileBorderHover and btn.IsBorderHover) then
                        btn:WhileBorderHover(xm, ym, dx, dy) -- Call the while hover border function
                        self:hover_lock_check(self.layers[layer][key]) -- Check for deletion
                    end
                    goto skip_hover_check
        
                elseif self.updateBorderHover and (btn.IsBorderHover and (self.hover_lock) and not ButtonsIsPressed) then -- If the button is not under the cursor
                    self.hover_lock = false -- Turn off hover lock
                    btn.IsBorderHover = false -- Turn off the border hover state
          
                    if (self.Prev_hover) then
                        self.Prev_hover.IsBorderHover = false -- Turn off all hover states for the button
                        self.Prev_hover.IsHover = false
                        self.Prev_hover = nil -- Clear reference to the last hovered button
                    end
                    self.Prev_hover_lock_layer = false -- Reset the last hovered button layer
        
                    if (btn.BorderUnHover) then -- Call unhover function if it exists
                        btn:BorderUnHover(xm, ym, dx, dy)
                    end
                end
              
                -- hover update
                if (self.layers[layer][key] and btn:isPointInBody(xm, ym)) then

                    if (not btn.IsHover and not self.hover_lock) then -- Cursor on button and hover state is false
                        if (self.Prev_hover) then
                            self.Prev_hover.IsBorderHover = false -- Turn off previous button hover state
                            self.Prev_hover.IsHover = false
                            self.Prev_hover = nil -- Clear reference to the previous button
                        end
                        self.Prev_hover = btn -- Save the current button as hovered
                        self.hover_lock = true -- Enable hover lock
                        btn.IsHover = true -- Set hover state to true
        
                        if (btn.Hover) then
                            btn:Hover(xm, ym, dx, dy) -- Call the hover function
                            self:hover_lock_check(self.layers[layer][key]) -- Check for deletion
                        end
                    end                  
        
                    -- Run while hover function 
                    if (self.layers[layer][key] and btn.WhileHover and btn.IsHover) then
                        btn:WhileHover(xm, ym, dx, dy) -- Call the while hover function
                        self:hover_lock_check(self.layers[layer][key]) -- Check for deletion
                    end
        
                    -- If some button already hovered but appears some button with a lower layer or position
                    if (self.Prev_hover and self.Prev_hover.id and not ButtonsIsPressed and 
                        (not btn.IsHover and self.hover_lock and self.Prev_hover and  
                        self.Prev_hover.layer and 
                        (self.Prev_hover.layer > layer or (self.Prev_hover.layer == layer and self.Prev_hover.id > key)))) then
        
                        self.Prev_hover.IsBorderHover = false -- Make previous button unhovered
                        self.Prev_hover.IsHover = false
                        self.Prev_hover = nil -- Clear reference to the last button
                        self.Prev_hover = btn -- Save current button
                        btn.IsHover = true -- Enable hover state
                    end
        
                elseif (btn.IsHover and self.hover_lock  and not ButtonsIsPressed) then -- If the button is not under the cursor
                    self.hover_lock = false -- Turn off hover lock
                    btn.IsHover = false -- Turn off hover state
                    
                    if (self.Prev_hover) then
                        self.Prev_hover.IsBorderHover = false -- Turn off hover state for the previous button
                        self.Prev_hover.IsHover = false
                        self.Prev_hover = nil -- Clear reference to the last button
                    end
                    if (btn.UnHover) then -- Call unhover function if it exists
                        btn:UnHover(xm, ym, dx, dy)
                    end
                end

                ::skip_hover_check:: 
                -- Check if the button is still existing
                if ((self.layers[layer][key]) and (btn.IsDown[1] == 1 or btn.IsDown[2] == 1 or btn.IsDown[3] == 1) and
                    btn.WhilePressed) then
                    btn:WhilePressed(xm, ym, dx, dy) -- Call the while pressed function
                end
                if((btn.IsBorderDown[1] == 1 or btn.IsBorderDown[2] == 1 or btn.IsBorderDown[3] == 1) ) then
                    print("sadsd")
                end
                if ((self.layers[layer][key]) and (btn.IsBorderDown[1] == 1 or btn.IsBorderDown[2] == 1 or btn.IsBorderDown[3] == 1) and
                btn.WhileBorderPressed) then
                    btn:WhileBorderPressed(xm, ym, dx, dy) -- Call the while pressed border function
                end
            end
        end
    )
    

    -- calculates time for uodateing
    if self.debug  then
        self.updateTime = love.timer.getTime() - Time  
    end
end


--- func desc
---@param xm  number x mouse
---@param ym number y mouse
function buttons:updateMouseScroll( xm, ym)
    local keys = {}
    for k in pairs(self.layers) do
        table.insert(keys, k)
    end
    local x, y = love.mouse.getPosition()
    table.sort(keys)
    for k, layer in pairs(keys) do
        for key, btn in pairs(self.layers[layer]) do
            if (not btn.Disabled) then
                    if ( btn.Scroll and (btn.IsHover or btn.IsBorderHover)) then
                            btn:Scroll(xm, ym,self) -- callback click function
                            self:hover_lock_check(self.layers[layer][key])
                        return 0
                    end
            end
        end

    end
end
--- func desc
---@param xm  number x mouse
---@param ym number y mouse
function buttons:updateMouseClick( xm, ym, button)
    self:mainUpdateCycle(    function (buttons,layer,key, btn)
        if (not btn.Disabled  ) then
            if btn.IsHover   then
                if btn.Click then
                    btn:Click(xm, ym,button) -- callback click function
                end
                self:hover_lock_check(self.layers[layer][key])
                if self.layers[layer][key] then -- if button still exist in list set pressed button on 
                    btn.IsDown[button] = 1
                    self.IsDownMain[button] = 1
                end
                return 0
            elseif btn.IsBorderHover and btn.ClickBorder     then
                btn:ClickBorder(xm, ym, button)
                self:hover_lock_check(self.layers[layer][key])
                if self.layers[layer][key] then -- if button still exist in list set pressed button on 
                    btn.IsBorderDown[button] = 1
                    self.IsDownBorderMain[button] = 1
                end
                return 0
            end
        end
    end  
    )
end
--- func desc
---@param xm  number x mouse
---@param ym number y mouse
function buttons:updateMouseMoves( xm, ym, dx, dy, istouch)
    self:mainUpdateCycle(    function (buttons,layer,key, btn)
        if (btn.Disabled == false and  not btn.IsBorderHover  and btn.WhileMoves) and  (btn:isPointInBody(xm,ym)) then
            btn:WhileMoves (xm, ym, dx, dy, istouch)
            self:hover_lock_check(self.layers[layer][key])
            return 0
        end
    end  
    )

end
--- func desc

---@param xm  number x mouse
---@param ym number y mouse
function buttons:updateMouseRelease( xm, ym, button)
    self:mainUpdateCycle(    function (buttons,layer,key, btn)
        if (self.layers[layer][key].IsDown[button] == 1 ) then-- mouse button that pressed on button is released
            if (btn.Release) then
                btn:Release(xm, ym, button)
            end
            if (self.layers[layer][key] == nil) then
                self.hover_lock = false
            end
            if (self.layers[layer][key]) then
                btn.IsDown[button] = 0
                self.IsDownMain[button] = false
            end
            return 0
        elseif btn.IsBorderDown[button] == 1   then -- mouse button  that pressed on button border is released

            
            if (btn.ReleaseBorder) then
                btn:ReleaseBorder(xm, ym, button)
            end
            self:hover_lock_check(self.layers[layer][key])
            if self.layers[layer][key] then -- if button still exist in list set pressed button on 
                btn.IsBorderDown[button] = 0
                self.IsDownBorderMain[button] = false
            end
            return 0
        end
    end  
    )
        
end

-- return x,y + translate x,y or x + translate.x
--- func desc

---@param x number  
---@param y number (can be nil)
function buttons:TranslateScaleMosue(xm,ym) -- for x,y coordinates 
    local xt = (xm - self.translate.x ) /self.scale 
    local yt = (ym - self.translate.y ) /self.scale 
    return xt,yt
end


-- return x,y + translate x,y or x + translate.x
--- func desc

---@param x number  
---@param y number (can be nil)
function buttons:Translate(x,y) -- for x,y coordinates 
    if(y ~= nil) then
        local xt = (x + self.translate.x ) 
        local yt = (y + self.translate.y ) 
        return xt,yt
    else
    local xt = x * (x + self.translate.x ) 
      return xt
    end
end

-- return x,y * scale  or x * scale
--- func desc

---@param x number  
---@param y number (can be nil)
function buttons:Scale(x,y) -- for width, height,radius, vertex (only x1,y1,x2,x2 ) ect 
    if(y ~= nil) then
        local xt = x * self.scale
        local yt = y * self.scale
        return xt, yt
    else
        local xt = x * self.scale
        return xt
    end
end


-- changes debug state for buttons:render() 
function buttons:toggleDebug()

    if (self.debug and self.debugLine and self.debugText and  self.debugBorderHover) then
        self.debug = false
        self.debugLine = false
        self.debugText = false
        self.debugBorderHover = false
        return 0
    end
    if (self.debug and self.debugLine and self.debugBorderHover ) then
        self.debugText = true
        return 0
    end
    if (self.debug and self.debugBorderHover ) then
        self.debugLine= true
        return 0
    end
    if (self.debug) then
        self.debugBorderHover = true
        return 0
    end
    if (not self.debug) then
        self.debug = true
        return 0
    end

end

-- set width range where border will calculated
function buttons:setBorderCheckWidht(x)
    if(  x < 0 ) then
        error("ivalid check width ")
    elseif(type(x) ~= "number") then
        error("not number")
    end

    self.borderCheckWidth = x
end

-- set width range where border will calculated
function buttons:getBorderCheckWidht(width)
    return  self.max_quantity_layers
end
-- set max quantity of layers
function buttons:setMaxQuantityLayers(x)
    if(type(x) == "number" and x > 0) then
        self.max_quantity_layers = x 
    else
        error("not number or zero")
    end
end
-- get max quantity of layers
function buttons:getMaxQuantityLayers(x)
    return self.max_quantity_layers  
end
-- set max quantity of buttons in layer
function buttons:setMaxQuantityButtonsInLayer(x)
    if(type(x) == "number" and x > 0) then
        self.max_quantity_buttons_in_layer = x 
    else
        error("not number or zero")
    end
    self.max_quantity_layers = x 
end

-- get max quantity of buttons in layer
function buttons:getMaxQuantityButtonsInLayer(x)
    return self.max_quantity_layers 
end


-- get width range where border will calculated
function buttons:getBorderCheckWidht(width)
    return self.borderCheckWidth
end

-- disable all layers
function buttons:disable()
    for k, _ in pairs(self.layers) do
        self:disableLayer(k)
    end
end

-- enable all layers
function buttons:enable()
    for k, _ in pairs(self.layers) do
        self:enablelayer(k)
    end
end

-- disable layer by id clears all states in buttons in layer like hover,click ect
function buttons:disableLayer( number)
 
    local layer = self.layers[number]
    if(layer ) then
        for k, v in pairs(layer ) do
            if(layer[k].IsHover or  layer[k].IsBorderHover) then
                self.hover_lock = false
            end
            layer[k].IsHover = false
            layer[k].IsBorderHover = false

            layer[k].IsDown = {0,0,0}
            layer[k].IsBorderDown= {0,0,0}
            layer[k]:disable()
        end
    else
        error("layer do not exist")
    end

end
-- enable layer by id
function buttons:enableLayer( number)
    local layer = self.layers[number]
    for k, v in pairs(layer) do
        layer[k]:enable()
    end
end
-- gets all existing layers returns table like { 1={btn,btn...},2={btn,btn...}  } 1,2 - lauer ids, btn - some buttons objects
function buttons:getLayers()
    local layers = {}
    for k, v in pairs( self.layers ) do
        layers[k] = self.layers[k]
    end
    return layers
end
-- get layer by numbers returns table like {btn,btn...}
function buttons:getLayerByID(id)
    local layers = {}
    if(self.layers[id])
    then
        return self.layers[id]
    else
        error("layer"..id.."do not exist")
    end
    return layers
end
-- check if layer exist returns true if exist
function buttons:checkLayer(l)
    if(  self.layers[l])then  return true end
    return false
end

--- delete lyer by numebr will also change current layer if you deleted curent layer. 
function buttons:delLayer( number)
    if (type(number == "number")) then
        assert( self.layers[number],"Layer: ".. number .. " do not exist or alredy deleted") 


        self.layers[number] = nil

        if(self.Prev_hover and self.layers[self.Prev_hover.id]) then
            self.Prev_hover = nil
        end

        if(self.current_layer == number) then
            self.current_layer = false
            for a, v in pairs(self.layers) do
                self.current_layer = a
                if(a) then break end
            end
        end
        elseif number == nil then
            error("Layer nil")
        else
            error("invalid layer " .. number)
        end
end


--get number of current layer
function buttons:getCurrentLayerID()
    return self.current_layer 
end
--Sets Layer for creating also creates layer if it do not exist
function buttons:setLayer( number)
    local count = 0
    for k, v in pairs(self.layers ) do
            count = count + 1
    end

    if( count > self.max_quantity_layers ) then
        error("Too much layers current:" .. count  ..  " max:"..  self.max_quantity_layers)
    end
    if (type(number == "number")) then
        self.current_layer = number
    
    elseif number == nil then
        error("Layer nil ")
    else
        error("invalid layer " .. number)
    end
    if ( not self.layers[number]) then
        self.layers[number] = {}
    end

end

-- translate and scale
 -- correct mouse mosition to scale and translation
function buttons:TranslateCorrectMouse(x,y)
  
    local xt = x /self.scale

    local yt = y /self.scale
    return xt,yt
end
function buttons:setTranslate( x,y)
    if(type(x) ~= "number") and (type(y) ~= "number")
    then
        error("not number value")
    end
    self.translate.x = x
    self.translate.y = y
end
function buttons:getTranslate()
    return self.translate.x , self.translate.y 
end
function buttons:getTranslateX()
    return self.translate.x 
end
function buttons:getTranslateY()
    return self.translate.y
end
function buttons:setTranslateX(x)
    if(type(x) ~= "number")
    then
        error("not number value")
    end
 self.translate.x = x 
end
function buttons:setTranslateY(y)
    if(type(y) ~= "number")
    then
        error("not number value")
    end
    self.translate.y = y 
end
function buttons:setScale( x)
    if(x <= 0) then
        error("scale can't be 0 ")
    end
    self.scale = x
end
function buttons:getScale()
    return self.scale 
end

-- toggle hover border 
function buttons.enableBorderHover() 
    buttons.updateBorderHover = true
end
function buttons.disableBorderHover() 
    buttons.updateBorderHover = false
end
function buttons.getBorderHoverState() 
    return buttons.updateBorderHover
end
function buttons.setBorderHoverState(x ) 
    buttons.updateBorderHover = not not  x
end
-- Calls function  and gives to it (layer_k,b_key,button_object ) in order by id lyers and id buttons
function buttons:mainUpdateCycle(func)
    local keys = {}
    for layer_k in pairs(self.layers) do
        table.insert(keys, layer_k)
    end
    table.sort(keys)

    for  _, layer_k in pairs(keys) do

        local Btns_keys = {}
        for btn_k, __ in pairs(self.layers[layer_k ]) do
            table.insert( Btns_keys,btn_k)
        end
        table.sort(Btns_keys)
        --sort buttons inside layer
        for ___, key in pairs(Btns_keys) do
            func(self,layer_k,key,self.layers[layer_k][key] )
        end
    end
end
function buttons:mainUpdateCycleReversed(func)
    local keys = {}
    for layer_k in pairs(self.layers) do
        table.insert(keys, layer_k)
    end

    table.sort(keys, function(a, b) return a > b end)
    for  _, layer_k in pairs(keys) do


        local Btns_keys = {}
        for btn_k, __ in pairs(self.layers[layer_k ]) do
            table.insert( Btns_keys,btn_k)
        end
        table.sort(Btns_keys, function(a, b) return a > b end)

        --sort buttons inside layer
        for ___, key in pairs(Btns_keys) do

            func(self,layer_k,key,self.layers[layer_k][key] )
            
        end
    end
end
-- service methods
--Creates new id 
function buttons:idCreate()
    local count = 0
    -- counter from  .max_quantity_buttons_in_layer
    for i = 1,math.huge, 1 do
        if (self.layers[self.current_layer][i] == nil) then
            return i
        else
            count = count + 1
            if (count > self.max_quantity_buttons_in_layer) then
                error("max_quantity_buttons_in_layer:" .. count .. " Max exceed:" ..
                          self.max_quantity_buttons_in_layer)
            end
        end
    end
    error("max quantity buttons in layer overflow")
end
--Checks if value do not exist sets hover lock to false to prevent blocking by deleted button
function buttons:hover_lock_check(var)
  if (var == nil) then
       self.hover_lock = false
   end
end
-- Base table for all button objects
function buttons:GetBtnBase(x,y,id,type,adds)
  local t = adds
   t.IsBorderDown = {
   [1] = 0,
   [2] = 0,
   [3] = 0
   }
   t.IsDown = {
       [1] = 0,
       [2] = 0,
       [3] = 0
   }
   t.Disabled = false
   t.IsHover = false
   t.IsBorderHover = false
   t.layer = self.current_layer
   t.id = id
   t.x = x
   t.y = y
   t.type = type
   setmetatable(t, {
       __index = function(table, key)
           local value = self.methods[key]
           if value then
               return value
           else
               return nil
           end
       end
   })
   return t
end

return buttons
    