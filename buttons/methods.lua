local buttons= {}

------------------------
---- All function in buttons.methods avalivble for every button 
-----------------------

buttons.methods = {}
buttons.methods.buttons = buttons
buttons.methods.math = require("libs.buttons.math_addition")

--delete button 
function buttons.methods:del()
    if(self.buttons.layers[self.layer][self.id]) then
 
        if self.buttons.Prev_hover and self.buttons.Prev_hover.id == self.id and  self.buttons.Prev_hover.layer == self.layer  then
            self.buttons.Prev_hover = nil
        end
    
        if(self.IsHover )  then
            if self.UnHover then
                local xm, ym = love.mouse.getPosition()
                self:UnHover(xm,ym, 0,0)  
            end
            buttons.hover_lock = false
        elseif (self.IsBorderHover  ) then
            if self.BorderUnHover then
                local xm, ym = love.mouse.getPosition()
                self:BorderUnHover(xm,ym, 0,0)  
            end
            buttons.hover_lock = false
        end


        self.buttons.layers[self.layer][self.id] = nil
        
        return 0
    else
        error("button already deleted")
    end
end
---------------------
-- Check is button has some type of fucntion
---------------------
-- is button has functions that realted to border :bool
---@return boolean
function buttons.methods:hasBorderCallback()
    if (self.BorderUnHover or  self.WhileBorderHover or  self.BorderHover or self.ClickBorder or self.WhileBorderPressed  or self.ReleaseBorder or self.Scroll ) then return true end
end
-- is button has funcs like hover unhover clicks that related to button body :bool
---@return boolean
function buttons.methods:hasBodyCallback()
    if (self.UnHover or  self.WhileHover or  self.BorderHover  or  self.Hover or self.Click  or self.WhilePressed or self.Release) then
        return true
    end-- while pressed 
end

---------------------
-- Setting callbacks
---------------------
-- callback that calls every fps while mouse pressed even if cursor leave the button 
---@param WhilePressed function
function buttons.methods:setWhilePressed( WhilePressed)
    if (type(WhilePressed) == "function") then
        self.WhilePressed = WhilePressed
    else
        error("invalid function")
    end
end
-- callback that calls every fps while mouse pressed border even if cursor leave the button 
---@param WhilePressed function
function buttons.methods:setWhileBorderPressed( WhileBorderPressed)
    if (type(WhileBorderPressed) == "function") then
        self.WhileBorderPressed = WhileBorderPressed
    else
        error("invalid function")
    end
end
-- callback that calls every "mouse moves" event
---@param WhilePressed function
function buttons.methods:setWhileMoves( WhileMoves )
    if (type(WhileMoves ) == "function") then
        self.WhileMoves = WhileMoves 
    else
        error("invalid function")
    end
end
--- callback that calls once when mouse enters border range 
---@param WhilePressed function
function buttons.methods:setBorderHover( BorderHover)
    if (type(BorderHover) == "function") then
        self.BorderHover = BorderHover
    else
        error("invalid function")
    end
end
--- callback that calls once when mouse leaves border range 
---@param WhilePressed function
function buttons.methods:setBorderUnHover( BorderHover)
    if (type(BorderHover) == "function") then
        self.BorderUnHover = BorderHover
    else
        error("invalid function")
    end
end
--- callback that calls once when mouse clicks on border
---@param WhilePressed function
function buttons.methods:setClickBorder( ClcikBorder )
    if (type(ClcikBorder ) == "function") then
        self.ClickBorder = ClcikBorder
    else
        error("invalid function")
    end
end
--- callback that calls once when mouse leaves border range 
---@param WhilePressed function
function buttons.methods:setWhileBorderHover( BorderHover)
    if (type(BorderHover) == "function") then
        self.WhileBorderHover = BorderHover
    else
        error("invalid function")
    end
end
--- callback that calls once when button clicked
---@param WhilePressed function
function buttons.methods:setClick( func)
    if (type(func) == "function") then
        self.Click = func
    else
        error("invalid function")
    end
end
--- callback that calls once when released any mouse button that pressed on button
---@param WhilePressed function
function buttons.methods:setRelease( func)
    if (type(func) == "function") then
        self.Release = func
    else
        error("invalid function")
    end
end
--- callback that calls once when mouse released border
---@param WhilePressed function
function buttons.methods:setReleaseBorder( func)
    if (type(func) == "function") then
        self.ReleaseBorder = func
    else
        error("invalid function")
    end
end
--- callback that calls once when mouse enters buttonn
---@param WhilePressed function
function buttons.methods:setHover( func)
    if (type(func) == "function") then
        self.Hover = func
    else
        error("invalid function")
    end
end
--- callback that calls every fps while mouse in buttonn
---@param WhilePressed function
function buttons.methods:setWhileHover( func)
    if (type(func) == "function") then
        self.WhileHover = func
    else
        error("invalid function")
    end
end
--- callback that calls once when mouse leaves buttonn
---@param WhilePressed function
function buttons.methods:setUnHover( func)
    if (type(func) == "function") then
        self.UnHover = func
    else
        error("invalid function")
    end
end
--- callback that calls whent mouse scrolled
---@param WhilePressed function
function buttons.methods:setScroll( func)
    if (type(func) == "function") then
        self.Scroll= func
    else
        error("invalid function")
    end
end


---------------------
-- Removing callbacks
---------------------
---Remove callback forWhilePressed
function buttons.methods:removeWhilePressed()
    self.WhilePressed = nil
end

---Remove callback forWhileBorderPressed
function buttons.methods:removeWhileBorderPressed()
    self.WhileBorderPressed = nil
end

---Remove callback forWhileMoves
function buttons.methods:removeWhileMoves()
    self.WhileMoves = nil
end

---Remove callback forBorderHover
function buttons.methods:removeBorderHover()
    self.BorderHover = nil
end

---Remove callback forBorderUnHover
function buttons.methods:removeBorderUnHover()
    self.BorderUnHover = nil
end

---Remove callback forClickBorder
function buttons.methods:removeClickBorder()
    self.ClickBorder = nil
end

---Remove callback forWhileBorderHover
function buttons.methods:removeWhileBorderHover()
    self.WhileBorderHover = nil
end

---Remove callback forClick
function buttons.methods:removeClick()
    self.Click = nil
end

---Remove callback forRelease
function buttons.methods:removeRelease()
    self.Release = nil
end

---Remove callback forReleaseBorder
function buttons.methods:removeReleaseBorder()
    self.ReleaseBorder = nil
end

---Remove callback forHover
function buttons.methods:removeHover()
    self.Hover = nil
end

---Remove callback forWhileHover
function buttons.methods:removeWhileHover()
    self.WhileHover = nil
end

---Remove callback forUnHover
function buttons.methods:removeUnHover()
    self.UnHover = nil
end

---Remove callback forScroll
function buttons.methods:removeScroll()
    self.Scroll = nil
end


---------------------
-- Get some parametr from button
---------------------
-- check return button BorderHover state :bool
---@return boolean
function buttons.methods:isBorderHover()
    return self.IsBorderHover
end
--check return button hover state :bool
---@return boolean
function buttons.methods:isHover()
    return self.IsHover
end 
--check return button hover border state :bool
---@return boolean
function buttons.methods:isBorderHover()
    return self.IsBorderHover
end 
-- get current mouse buttons that pressed on button  :table{1=state,...}
---@return boolean
function buttons.methods:isPressed()
    return self.IsDown
end
-- get current mouse buttons that pressed on button border :table{1=state,...}
---@return boolean
function buttons.methods:isBorderPressed()
    return self.BorderIsDown
end
-- Get the type of the object (  1 -rectangle, or 2- circle,3 - polygon)
---@return boolean
function buttons.methods:getType()
    return self.type  -- Return the object's type
end
-- Get the numebr of layer of the button :number
---@return boolean
function buttons.methods:getLayer()
    return self.layer  -- Return the layer of the button
end
-- Get id of the button :number
---@return boolean
function buttons.methods:getID()
    return self.id -- Return the layer of the button
end
---------------------
-- Position,size,vertex,radius change
---------------------
-- Get the position (x, y) of the object 
---@return x,y
function buttons.methods:getPosition()
    return self.x, self.y  -- Return both x and y coordinates
end

-- Set the position (x, y) of the object
--- func desc
---@param number x 
---@param y
---@return void
function buttons.methods:setPosition( x, y)
    self.x = x  -- Set the x-coordinate
    self.y = y  -- Set the y-coordinate
end

-- Set the x-coordinate of the object
--- func desc 
---@param number x 
---@return void
function buttons.methods:setX( x)
    self.x = x  -- Set the x-coordinate
end

-- Get the x-coordinate of the object
---@return numberx 
function buttons.methods:getX()
    return self.x  -- Return the x-coordinate
end

-- Set the y-coordinate of the object
---@param y
---@return void
function buttons.methods:setY( y)
    self.y = y  -- Set the y-coordinate
end

-- Get the y-coordinate of the object
---@return y
function buttons.methods:getY()
    return self.y  -- Return the y-coordinate
end

-- Get the vertices of the polygon :table{1,3,4,5,6,213,....}
---@return vertex {1,2,3,45,6,}
function buttons.methods:getVertex()
    if (self.type == 3) then  -- Check if the object is a polygon
        return self.vertex  -- Return the vertices
    else
        error("Object is not polygon")  -- Error if not a polygon
    end
end

-- Set the vertices of the polygon
--- func desc
---@param vertex {1,2,3,4,5,6....}
function buttons.methods:setVertex( vertex)
    if (self.type == 3) then  -- Check if the object is a polygon
        self.vertex = vertex  -- Set the vertices
    else
        error("Object is not polygon")  -- Error if not a polygon
    end
end

-- Get the size of the rectangle
---@return weight,height
function buttons.methods:getSize()
    if (self.type == 1) then  -- If the button is a rectangle
        return self.w,self.h
    else
        error("Object is not rectangle")  -- Error if not a rectangle
    end
end
-- Set the size of the rectangle
---@param w
---@param h
---@return void 
function buttons.methods:setSize(w, h)
    if h < 0 and w < 0 then  -- Ensure the height is greater than 0
        error("Zero value") 
    end

    if (self.type == 1) then  -- If the button is a rectangle
        self.w,self.h = w,h
    else
        error("Object is not rectangle")  -- Error if not a rectangle
    end
end
-- Get the height of the rectangle
---@return height
function buttons.methods:getHeight()
    if (self.type == 1) then  -- If the button is a rectangle
        return self.h
    else
        error("Object is not rectangle")  -- Error if not a rectangle
    end
end

-- Set the height of the rectangle
---@param h
---@return void
function buttons.methods:setHeight( h)
    if h < 0 then  -- Ensure the height is greater than 0
        error("Zero value") 
    end

    if (self.type == 1) then  -- If the button is a rectangle
        self.h = h
    else
        error("Object is not rectangle")  -- Error if not a rectangle
    end
end

-- Get the width of the rectangle
---@return width
function buttons.methods:getWidth()
    if (self.type == 1) then  -- If the button is a rectangle
        return self.w
    else
        error("Object is not rectangle")  -- Error if not a rectangle
    end
end

-- Set the width of the rectangle
--- func desc
---@param w
---@return void
function buttons.methods:setWidth( w)
    if w < 0 then  -- Ensure the width is greater than 0
        error("Zero value") 
    end

    if (self.type == 1) then  -- If the button is a rectangle
        self.w = w
    else
        error("Object is not rectangle")  -- Error if not a rectangle
    end
end

-- Get the radius of the circle
---@return raidus
function buttons.methods:getRadius()
    if (self.type == 2) then  -- If the button is a circle
        return self.r
    else
        error("Object is not a circle")  -- Error if not a circle
    end
end

-- Set the radius of the circle self
---@param r self
---@return void
function buttons.methods:setRadius( r)
    if r < 0 then  -- Ensure the radius is greater than 0
        error("Zero value")
    end

    if (self.type == 2) then  -- If the button is a circle
        self.r = r
    else
        error("Object is not a circle")  -- Error if not a circle
    end
end

-- Disable the button
---@return void
function buttons.methods:disable()
    if (self.buttons.Prev_hover and self.id == self.buttons.Prev_hover.id and self.layer == self.buttons.Prev_hover.layer) then  -- If the button is the one being hovered
        self.buttons.hover_lock = false  -- Disable hover lock
        self.buttons.Prev_hover = nil  -- Clear previous hover
    end
    self.IsHover = false  -- Disable hover
    self.IsBorderHover = false  -- Disable border hover
    self.Disabled = true  -- Disable the button
end
--- func desc Enable the button
---@return void
function buttons.methods:enable()
    if (self.IsHover or self.IsBorderHover) then  -- If the button was previously hovered
        self.hover_lock = false  -- Disable hover lock
    end
    self.Disabled = false  -- Enable the button
end
---------------------
-- Check is point in the button or in border 
-- if notScaleTranslate = nil/false will scale and transform xm and ym
---------------------
--- func desc checls if point xm,ym is in button border.
---@param number xm number 
---@param ym number 
---@param notScaleTranslate if true then gived point will not notScaled and translated 
---@return boolean
function buttons.methods:isPointInBorder(xm,ym,notScaleTranslate)  
    if
    (self.type == 2  and self:pointInCircleBorder(xm, ym,notScaleTranslate)) or
    (self.type == 1  and self:pointInRectBorder(xm, ym,notScaleTranslate)) or
    (self.type == 3  and self:pointInPolygonBorder(xm, ym,notScaleTranslate))
    then
        return true
    end
end
--- func desc checks if point xm,ym is in button.
---@param number xm number 
---@param ym number 
---@param notScaleTranslate if true then gived point will not notScaled and translated
---@return boolean
function buttons.methods:isPointInBody(xm,ym,notScaleTranslate)
   if
    (self.type == 1 and self:pointInRect(xm, ym,notScaleTranslate)) or
    (self.type == 3 and self:pointInPolygon(xm, ym,notScaleTranslate)) or
    (self.type == 2 and self:pointInCircle(xm, ym,notScaleTranslate)) then
        return true
    end
end

-----------------------------------
-- Checks is xm,ym in button. Do not checking type
-- if notScaleTranslate = nil/false will scale and transform xm and ym
-----------------------------------
--- True if point in rectangel
---@param number xm number 
---@param ym number 
---@param notScaleTranslate bool
---@return boolean
function buttons.methods:pointInRect(xm, ym,notScaleTranslate)
    local x,y = self.x,self.y
    local w,h  = self.w, self.h
    if not notScaleTranslate then
        x,y = self.buttons:Translate(self.buttons:Scale(  x,y ) ) -- add translate and scale position

         w,h = self.buttons:Scale(w,h ) -- scale size
    end


    return (xm >= x and ym >= y and ym <= y + h and xm <= x + w)
end
--- True if point in rectangel border
---@param number xm number 
---@param ym number 
---@param notScaleTranslate bool
function buttons.methods:pointInRectBorder(xm, ym,notScaleTranslate)

    local big_x,big_y = self.x - self.buttons.borderCheckWidth ,self.y - self.buttons.borderCheckWidth -- add translate and scale position
    local big_w,big_h = self.w + self.buttons.borderCheckWidth*2 , self.h + self.buttons.borderCheckWidth*2 -- scale size
    local small_w,small_h = self.w - self.buttons.borderCheckWidth*2 , self.h - self.buttons.borderCheckWidth*2 -- scale size
    local small_x,small_y = self.buttons:Scale( self.x + self.buttons.borderCheckWidth ,self.y + self.buttons.borderCheckWidth) -- add translate and scale position
    
    if( not notScaleTranslate) then
        big_x,big_y = self.buttons:Translate(  self.buttons:Scale(big_x,big_y ))
        big_w,big_h = self.buttons:Scale(big_w,big_h ) 
        small_x,small_y = self.buttons:Translate(small_x,small_y )
        small_w,small_h = self.buttons:Scale(small_w,small_h )
    end

    return 
    (xm >= big_x and ym >= big_y and ym <= big_y + big_h and xm <= big_x + big_w) and 
    not   (xm >= small_x and ym >= small_y and ym <= small_y + small_h and xm <= small_x + small_w)

end
--- True if point in polygon border
---@param number xm number 
---@param ym number 
---@param notScaleTranslate bool
---@return boolean
function buttons.methods:pointInPolygonBorder(xm, ym,notScaleTranslate)
    if(#self.vertex % 2 == 1 or #self.vertex < 6) then error ("vertex error") end

    local x,y =  self.x,self.y
    local triangles = {}
    if( not notScaleTranslate) then
        x,y = self.buttons:Translate(  self.buttons:Scale(x,y ))
        
        for k, v in pairs(self.vertex) do
            table.insert(triangles,  self.buttons:Scale(v))
        end 
        else
            for k, v in pairs(self.vertex) do
                table.insert(triangles,  v)
            end    
    end

    return self.math.inPolygonBorder(xm, ym,x, y,triangles, self.buttons.borderCheckWidth)
end

--- True if point in polygon
---@param number xm number 
---@param ym number 
---@param notScaleTranslate bool
---@return boolean
function buttons.methods:pointInPolygon(xm, ym,notScaleTranslate)
    if(# self.vertex % 2 == 1) then    error ("veretx error")  end
    local triangles = {}
    local x,y 
    if(not notScaleTranslate) then
        for i = 1, #self.vertex, 1 do
            triangles[i] = self.buttons:Scale(  self.vertex[i])
        end
         x,y =  self.buttons:Translate(self.buttons:Scale( self.x, self.y))
    else
        for i = 1, #self.vertex, 1 do
            triangles[i] =   self.vertex[i]
        end
         x,y = self.x, self.y
    end

    triangles = love.math.triangulate(triangles)

    for k, v in pairs(triangles) do
        if ( self.math.pointInTriangle(xm - x, ym - y, v)) then
            return true
        end
    end
    return false
end
--- func desc
---@param number xm number 
---@param ym number 
---@param notScaleTranslate bool
---@return boolean
function buttons.methods:pointInCircle(xm, ym,notScaleTranslate)
    local x,y =  self.x,self.y
    local radius =self.r 
    if( not notScaleTranslate) then
        x,y = self.buttons:Translate(  self.buttons:Scale(x,y ))
        radius = self.buttons:Scale(   radius )
    end
    local triangles = {}

    return self.math.pointInCircle(xm, ym, x, y, radius)
end
--- func desc
---@param number xm number 
---@param ym number 
---@param notScaleTranslate bool
---@return boolean
function buttons.methods:pointInCircleBorder(xm, ym,notScaleTranslate)
    local radius =  self.r 
  
    local x,y =  self.x,self.y
    if( not notScaleTranslate) then
        x,y = self.buttons:Translate(  self.buttons:Scale(x,y ))
        radius = self.buttons:Scale(  radius )
    end
    local triangles = {}

    return (self.math.pointInCircle(xm, ym, x, y, radius + self.buttons.borderCheckWidth ) and 
    not   self.math.pointInCircle(xm, ym, x, y, radius - self.buttons.borderCheckWidth) )
end

return buttons