-- buttons Library Overview

-- This library provides functionality for managing interactive buttons.  
-- It supports three shapes: rectangles, circles, and polygons, and includes methods for handling 
-- events such as mouse movements, clicks, and state updates. Additionally, it allows for 
-- translating all layers and scaling, providing flexible positioning and sizing of buttons.

-- Features:
-- - **Layer System**: The library implements a layer system where buttons are organized by layers. 
--   Buttons in lower layers (with lower layer IDs) have higher priority, meaning they will respond to events  
--   before buttons in higher layers.
-- - **Hover State Management**: Only one button can have a hover state or hover border state active at any given time, 
--   ensuring clear visual feedback without ambiguity.
-- - **Overlapping Buttons**: The library handles overlapping buttons efficiently. When buttons overlap, 
--   the topmost button (based on the layer system) will receive input events, while lower buttons remain unaffected, 
--   preventing errors or unintended behavior.  



-- Callback Functions:
-- - **BorderHover(xm, ym, dx, dy)**: Called every frame when the mouse is over the button border.
-- - **BorderUnHover(xm, ym, dx, dy)**: Called once when the mouse leaves the button border.
-- - **WhileBorderHover(self, xm, ym, dx, dy)**: Called every frame while the cursor is hovering over the button border.
-- - **WhileBorderPressed(self, xm, ym, dx, dy)**: Called every frame while the button border is pressed, even if the mouse leaves the button.
-- - **Hover(self, xm, ym, dx, dy)**: Called once when the mouse enters the button area.
-- - **WhileHover(self, xm, ym, dx, dy)**: Called every frame while the mouse is over the button.
-- - **WhilePressed(xm, ym, dx, dy)**: Called every frame when the button is pressed, even if the mouse leaves the button.
-- - **UnHover(self, xm, ym, dx, dy)**: Called once when the mouse leaves the button area.
-- - **BorderClick(self, xm, ym, button)**: Called once when the mouse clicks on the button border.
-- - **Click(self, xm, ym, button)**: Called once when the mouse clicks inside the button.
-- - **Release(self, xm, ym, button)**: Called once when the mouse releases a button inside the button's area.
-- - **BorderRelease(self, xm, ym, button)**: Called once when the mouse releases a button on the button's border.
-- - **WhileMoves(self, xm, ym, dx, dy, istouch)**: Called every time the mouse moves.
-- - **Scroll(dxm, dym)**: Called every time the user scrolls, capturing the scroll direction and amount.

------------------------------------------
--Built with love (and a bit of madness) for Love2D 11.5 !
----------------------------------------------


----------------------------
-------- Be aware ---------- 
----------------------------
-- Do not set self:del() on unhover AND hover (border and body) at one button 
-- it can create stack overflow because :del() calls unhover/unhover border if button hovered 
----------------------------
--------          ---------- 
----------------------------

function love.graphics.draw()
    buttons:draw() -- draw all button and debug data 
end
-- Use this function to toggle the debug drawing state of the buttons.
-- Call this function to switch between normal and debug modes.
    buttons:toggleDebug()
-------------------------------
----  Buttons methods and creation
-------------------------------
    -- Button Properties Overview

    -- Each button has the following properties:

    -- BORDER STATES works only if button has one fo the callbacks 

    -- IsBorderDown: A table indicating the pressed state of the button's border.
    --   - [1]: State for the left border (0 = not pressed, 1 = pressed)
    --   - [2]: State for the top border
    --   - [3]: State for the right border
    -- Example: If IsBorderDown[1] is 1, it means the left border is currently pressed.

    -- IsBorderHover: A boolean indicating whether the mouse is hovering over the button's border.
    --   - true: The mouse is hovering over the border, triggering border hover events.
    --   - false: The mouse is not hovering over the border.



    -- IsDown: A table indicating whether the button is currently pressed.
    --   - [1]: State for the left mouse button (0 = not pressed, 1 = pressed)
    --   - [2]: State for the right mouse button
    --   - [3]: State for the middle mouse button
    -- Example: If IsDown[1] is 1, it means the left mouse button is currently pressed.

    -- Disabled: A boolean indicating whether the button is disabled.
    --   - true: The button is disabled and will not respond to interactions.
    --   - false: The button is active and can respond to interactions.

    -- IsHover: A boolean indicating whether the mouse is currently hovering over the button.
    --   - true: The mouse is hovering over the button, triggering hover-related events.
    --   - false: The mouse is not hovering over the button.

    -- layer: The current layer of the button, determining its priority in event handling.
    --   - Lower layer IDs have higher priority over higher layer IDs.

    -- id: A unique identifier for the button, used for distinguishing it from other buttons.
    --   - The id also functions as a priority; lower id values indicate higher priority in event processing.

    -- x: The x-coordinate of the button's position in the graphical interface.

    -- y: The y-coordinate of the button's position in the graphical interface.

    -- type: A number representing the type of the button, indicating its shape.-
        -- - 1: Rectangle
        -- - 2: Circle
        -- - 3: Polygon
    ----------------------------------------    
    -- You can access and modify these properties using the provided methods in the library.


    -- Define a table of vertices for a polygon button.
    -- The format is {x1, y1, x2, y2, x3, y3, ..., xn,` `yn}.
    local vertex_table = { 0, 0, 10, 0, 10, 10, 0, 10 }

    -- Create a circular button at position (x, y) with` a specified radius.
    local buttonCircle = buttons:newCircle(x, y, radius)

    -- Create a rectangular button at position (x, y) with specified width (w) and height (h).
    -- Note: Both width and height must be non-negative; otherwise, an error will be thrown.
    local buttonRect = buttons:newRect(x, y, w, height)

    -- Create a polygonal button at position (x, y) using the defined vertex table.
    local newPoly = button:newPoly(x, y, vertex_table)

    button:del() -- deletes button 

    --[[ 
        Important: Callbacks will not function unless updateMain() is invoked.
        In every callback, the button object is accessible as 'self'. you also can acces main table by using self.buttons  (self.buttons == buttons)
        Note: The 'xm' and 'ym' values are already scaled and translated, so they will always work correctly.
    ]]

    -- Callback Descriptions
        -- BorderHover(self,xm, ym, dx, dy)
        -- Called every frame when the mouse is over the button border.
        button:setBorderHover(function (self,xm, ym, dx, dy)
            -- Example: Change border color when hovered
            print("Mouse is over the button border at:", xm, ym)
        end)

        -- BorderUnHover(self,xm, ym, dx, dy)
        -- Called once when the mouse leaves the button border.
        button:setBorderUnHover(function (self,xm, ym, dx, dy)
            -- Example: Reset border color when not hovered
            print("Mouse left the button border.")
        end)

        -- WhileBorderHover(self, xm, ym, dx, dy)
        -- Called every frame while the cursor is hovering over the button border.
        button:setWhileBorderHover(function (self,xm, ym, dx, dy)
            -- Example: Show tooltip while hovering
            print("Hovering over button border.")
        end)

        -- WhileBorderPressed(self, xm, ym, dx, dy)
        -- Called every frame while the button border is pressed, even if the mouse leaves the button.
        button:setWhileBorderPressed(function (self,xm, ym, dx, dy)
            -- Example: Change border color to indicate press
            print("Button border is pressed.")
        end)

        -- Hover(self, xm, ym, dx, dy)
        -- Called once when the mouse enters the button area.
        button:setHover(function (self,xm, ym, dx, dy)
            -- Example: Change button color on hover
            print("Mouse entered the button area.")
        end)

        -- WhileHover(self, xm, ym, dx, dy)
        -- Called every frame while the mouse is over the button.
        button:setWhileHover(function (self,xm, ym, dx, dy)
            -- Example: Update button animation while hovered
            print("Mouse is over the button.")
        end)

        -- WhilePressed(self,xm, ym, dx, dy)
        -- Called every frame when the button is pressed, even if the mouse leaves the button.
        button:setWhilePressed(function (self,xm, ym, dx, dy)
            -- Example: Change button state while pressed
            print("Button is being pressed.")
        end)

        -- UnHover(self, xm, ym, dx, dy)
        -- Called once when the mouse leaves the button area.
        button:setUnHover(function (self,xm, ym, dx, dy)
            -- Example: Reset button color when not hovered
            print("Mouse left the button area.")
        end)

        -- Click & release Callbacks (Requires updateMouseClick)

        -- BorderClick(self, xm, ym, button)
        -- Called once when the mouse clicks on the button border.
        button:setBorderClick(function (self,xm, ym, button)
            -- Example: Trigger action when clicking the border
            print("Clicked on button border.")
        end)

        -- Click(self, xm, ym, button)
        -- Called once when the mouse clicks inside the button.
        button:setClick(function (self,xm, ym, button)
            -- Example: Trigger action when clicking inside the button
            print("Button clicked.")
        end)

        -- Release(self, xm, ym, button)
        -- Called once when the mouse releases a button inside the button's area.
        button:setRelease(function (self,xm, ym, button)
            -- Example: Trigger action when the button is released
            print("Button released.")
        end)

        -- BorderRelease(self, xm, ym, button)
        -- Called once when the mouse releases a button on the button's border.
        button:setBorderRelease(function (self,xm, ym, button)
            -- Example: Trigger action when release occurs on the border
            print("Released on button border.")
        end)

        -- Mouse Movement Callbacks (Requires updateMouseMoves)

        -- WhileMoves(self, xm, ym, dx, dy, istouch)
        -- Called every time the mouse moves.
        button:setWhileMoves(function (self,xm, ym, dx, dy, istouch)
            -- Example: Update position or state based on mouse movement
            print("Mouse moved to:", xm, ym)
        end)

        -- Scroll Callback (Requires updateMouseScroll)

        -- Scroll(dxm, dym)
        -- Called every time the user scrolls, capturing the scroll direction and amount.
        button:setScroll(function (dxm, dym)
            -- Example: Trigger action based on scroll direction
            print("Scrolled with dx:", dxm, "dy:", dym)
        end)

        -- To set a callback for the WhilePressed event:
        button:setWhilePressed(function ()
            print("I'm being pressed")
        end)

        -- To remove the callback:
        button:removeWhilePressed()

    -- Button State Management Methods

    -- State Check Methods
        --[[
            Checks if the button has a hover border state.
            @return boolean: true if the hover border state is active, false otherwise.
            Note: Only one button can have the hover or hover border state true at a time.
        ]]
        button:isBorderHover()

        --[[
            Checks if the button is hovered.
            @return boolean: true if the hover state is active, false otherwise.
            Note: Only one button can have the hover or hover border state true at a time.
        ]]
        button:isHover()

        --[[
            Checks if the button is currently pressed.
            @return table: {1 = false, 2 = false, 3 = false} representing pressed states similar to mouse.pressed.
        ]]
        button:isPressed()

        --[[
            Checks if the button is pressed on its border.
            @return table: {1 = false, 2 = false, 3 = false} representing pressed states similar to mouse.pressed.
        ]]
        button:isBorderPressed()

        --[[
            Gets the type of the button.
            @return number: 1 for rectangle, 2 for circle, 3 for polygon.
        ]]
        button:getType()
       --[[
            Gets id of the button.
            @return number
        ]]
        button:getID()

        --[[
            Gets the layer number where the button is located.
            @return number: the layer number of the button.
        ]]
        button:getLayer()

        -- Position Methods

        --[[
            Gets the current position of the button.
            @return table: {x = number, y = number} representing the button's position.
        ]]
        button:getPosition()

        --[[
            Sets the position of the button.
            @param x number: the new x-coordinate.
            @param y number: the new y-coordinate.
        ]]
        button:setPosition(x, y)

        -- Individual X and Y Coordinate Methods

        --[[
            Sets the x-coordinate of the button.
            @param x number: the new x-coordinate.
        ]]
        button:setX(x)

        --[[
            Gets the x-coordinate of the button.
            @return number: the current x-coordinate of the button.
        ]]
        button:getX()

        --[[
            Sets the y-coordinate of the button.
            @param y number: the new y-coordinate.
        ]]
        button:setY(y)

        --[[
            Gets the y-coordinate of the button.
            @return number: the current y-coordinate of the button.
        ]]
        button:getY()

        -- Vertex Methods

        --[[
            Gets the vertices of the button (for polygon types).
            @return table: a table containing the vertices of the button.
        ]]
        button:getVertex()

        --[[
            Sets the vertices of the button (for polygon types).
            @param vertex table: a table containing the new vertices for the button.
        ]]
        button:setVertex(vertex)

        -- Size Methods

        --[[
            Gets the size of the button.
            @return table: {width = number, height = number} representing the button's size.
        ]]
        button:getSize()

        --[[
            Sets the size of the button.
            @param w number: the new width.
            @param h number: the new height.
        ]]
        button:setSize(w, h)

        -- Height and Width Methods

        --[[
            Gets the height of the button.
            @return number: the current height of the button.
        ]]
        button:getHeight()

        --[[
            Sets the height of the button.
            @param h number: the new height.
        ]]
        button:setHeight(h)

        --[[
            Gets the width of the button.
            @return number: the current width of the button.
        ]]
        button:getWidth()

        --[[
            Sets the width of the button.
            @param w number: the new width.
        ]]
        button:setWidth(w)

        -- Radius Methods (for circular buttons)

        --[[
            Gets the radius of the button (for circular types).
            @return number: the current radius of the button.
        ]]
        button:getRadius()

        --[[
            Sets the radius of the button (for circular types).
            @param r number: the new radius.
        ]]
        button:setRadius(r)

        -- Enable/Disable Methods

        --[[
            Disables  all buttons
            This will turn off hover and clicked states, 
            and will call UnHover if some button currently has a hover state active.
        ]]
        button:disable()

        --[[
            Enables all buttons
        ]]
        button:enable()

        -- Point Checking Methods

    -- Checking if a point is within the button's border 
    -- If notScaleTranslate is true, the x and y coordinates will not be adjusted 
    -- to account for scaling or translation relative to the window.
    button:isPointInBorder(xm, ym, notScaleTranslate)

    -- Checking if a point is within the button's body
    -- If notScaleTranslate is true, the x and y coordinates will not be adjusted 
    -- to account for scaling or translation relative to the window.
    button:isPointInBody(xm, ym, notScaleTranslate)

------------------------
----  Class methods 
------------------------
    -- updateMain: The main update cycle for buttons, processing mouse hover, click, and scroll events.
    function love.update(dt)
        -- main update no callback will work with out this
        bbt:updateMain(dt)
    end
    -- updateMouseScroll: Updates the state of buttons in response to mouse scrolling.
    function love.wheelmoved(xwd, ywd)   
        bbt:updateMouseScroll( xwd, ywd) -- calls wheelscroll callbackc
    end
    
    -- updateMouseClick: Updates the state of buttons upon mouse clicks.
    function love.mousepressed(xm, ym, button, istouch)
        bbt:updateMouseClick(xm, ym, button) -- calls click callbackcs
    
    end

    -- updateMouseMoves: Updates the state of buttons as the mouse moves.
    function love.mousemoved( xm, ym, dx, dy, istouch )
        bbt:updateMouseMoves( xm, ym, dx, dy, istouch) -- calls while moves  callbackcs
    end

    -- Mouse Release Update
    -- Updates the state of buttons when a mouse release event occurs.
    function love.mousereleased(xm, ym, button)
        buttons:updateMouseRelease(xm, ym, button)-- calls release  callbackcs
    end

    -- Mouse Translation
    -- Transforms the mouse's absolute position in the window to the layer's position by scaling and translating.
    buttons:TranslateCorrectMouse(x, y)

    -- Translate  all buttons to a new position (x, y).
    buttons:Translate(x, y)

    -- Scale all buttons  to a new size (x, y).
    buttons:Scale(x, y)

    -- Set and Get Border Check Width
    buttons:setBorderCheckWidth(x) -- Set the width used for border checks.
    local borderWidth = buttons:getBorderCheckWidth() -- Get the current border check width.

    -- Set and Get Maximum Quantity Layers
    buttons:setMaxQuantityLayers(x) -- Set the maximum number of layers allowed.
    local maxLayers = buttons:getMaxQuantityLayers() -- Get the maximum quantity of layers.

    -- Set and Get Maximum Quantity Buttons in Layer
    buttons:setMaxQuantityButtonsInLayer(x) -- Set the maximum number of buttons allowed in a layer.
    local maxButtonsInLayer = buttons:getMaxQuantityButtonsInLayer() -- Get the maximum quantity of buttons in a layer.

    -- Disable and Enable all Buttons
    buttons:disable() -- Disable all buttons.
    buttons:enable() -- Enable all buttons.

    -- Disable and Enable all buttons in layer
    local layerNumber = 1 -- Example layer number.
    buttons:disableLayer(layerNumber) -- Disable a specific layer.
    buttons:enableLayer(layerNumber) -- Enable a specific layer.

    -- Get Layers Information
    local layers = buttons:getLayers() -- Get a list of all layers with buttons 
    -- return table like : { btn_object,btn_object... }... }

    -- Layer Management
    local layerID = 1 -- Example layer ID.
    local layerByID = buttons:getLayerByID(layerID) -- Get a layer by its ID if it exist.  { btn_object,btn_object... }
    local layerCheck = buttons:checkLayer(layerID) -- Check if a layer exists.
    buttons:delLayer(layerID) -- Delete a layer by its ID.
    local currentLayer = buttons:getCurrentLayerID() -- Get the currently active layer id.
    buttons:setLayer(layerID) -- Set and/or create the active layer by ID .


    -- Position Translation Methods
    buttons:setTranslate(x, y) -- Set the translation offsets.
    local translate ={}
    translate.x, translate.y = buttons:getTranslate() -- Get the current translation offsets.
    local translateX = buttons:getTranslateX() -- Get the X translation offset.
    local translateY = buttons:getTranslateY() -- Get the Y translation offset.
    buttons:setTranslateX(x) -- Set the X translation offset.
    buttons:setTranslateY(y) -- Set the Y translation offset.

    -- Scaling Methods
    buttons:setScale(x) -- Set the scale factor.
    local scale = buttons:getScale() -- Get the current scale factor.


    -- Toggle hover border calculation 
    buttons.enableBorderHover() 
    buttons.disableBorderHover()  
    buttons.getBorderHoverState()  -- bool
    buttons.setBorderHoverState( ) -- bool

    --this function will be caled whith every existing button in normal order by layers and buttons id and reversed whith 
    -- self here is the main table buttons

    -- This function will be called for every existing button in normal order by layers and button IDs.
    -- The function signature is:
    --     func(self, layer_key, button_id, button)
    -- where `self` refers to the main buttons table, `layer_key` is the key of the current layer, 
    -- `button_id` is the identifier for the button, and `button` is the button object itself.

    for_buttons = func(self  ,layer_key,buttons_id,button )

    
    -- Main Update Cycle Methods
    buttons:mainUpdateCycle(for_buttons)       
    buttons:mainUpdateCycleReversed(for_buttons) 
