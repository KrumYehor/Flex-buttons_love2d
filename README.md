# Flex-buttons library

This library provides functionality for managing interactive buttons in Love2D.  
It supports three shapes: rectangles, circles, and polygons, and includes methods for handling events such as mouse movements, clicks, and state updates. Additionally, it allows for translating all layers and scaling, providing flexible positioning and sizing of buttons.

## Features

- **Layer System**: The library implements a layer system where buttons are organized by layers.  
  Buttons in lower layers (with lower layer IDs) have higher priority, meaning they will respond to events before buttons in higher layers.
- **Hover State Management**: Only one button can have a hover state or hover border state active at any given time, ensuring clear visual feedback without ambiguity.
- **Overlapping Buttons**: The library handles overlapping buttons efficiently.  
  When buttons overlap, the topmost button (based on the layer system) will receive input events, while lower buttons remain unaffected, preventing errors or unintended behavior.

## Callback Functions

The following callback functions are available for customizing button behavior:

- **BorderHover(xm, ym, dx, dy)**: Called every frame when the mouse is over the button border.
- **BorderUnHover(xm, ym, dx, dy)**: Called once when the mouse leaves the button border.
- **WhileBorderHover(self, xm, ym, dx, dy)**: Called every frame while the cursor is hovering over the button border.
- **WhileBorderPressed(self, xm, ym, dx, dy)**: Called every frame while the button border is pressed, even if the mouse leaves the button.
- **Hover(self, xm, ym, dx, dy)**: Called once when the mouse enters the button area.
- **WhileHover(self, xm, ym, dx, dy)**: Called every frame while the mouse is over the button.
- **WhilePressed(xm, ym, dx, dy)**: Called every frame when the button is pressed, even if the mouse leaves the button.
- **UnHover(self, xm, ym, dx, dy)**: Called once when the mouse leaves the button area.
- **BorderClick(self, xm, ym, button)**: Called once when the mouse clicks on the button border.
- **Click(self, xm, ym, button)**: Called once when the mouse clicks inside the button.
- **Release(self, xm, ym, button)**: Called once when the mouse releases a button inside the button's area.
- **BorderRelease(self, xm, ym, button)**: Called once when the mouse releases a button on the button's border.
- **WhileMoves(self, xm, ym, dx, dy, istouch)**: Called every time the mouse moves.
- **Scroll(dxm, dym)**: Called every time the user scrolls, capturing the scroll direction and amount.

---

#### Hello world
```lua
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

```


_Built with love (and a bit of madness) for Love2D 11.5_
