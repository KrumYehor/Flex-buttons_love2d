
-- arr that contains all callback funciton for easy seting
btn_vals = {}
function btn_vals.release(self, xm, ym, button)
  print("releasse !!")
end
function btn_vals.borderRelease(self, xm, ym, button)
  print("releasse border!!")
end
function btn_vals.hover(self, xm, ym, dx, dy)
  print("hover ")
end
function btn_vals.Whilehover(self, xm, ym, dx, dy)
  if love.keyboard.isDown("d") then -- of d pressed delete the buttons under cursor
        self:del()
  elseif
      -- o - disable button 
     love.keyboard.isDown("o") then
          self:disable()      
        elseif
      -- l - disable layer of button 
      love.keyboard.isDown("l") then
          local l = self:getLayer()  
          bbt:disableLayer(l)
  end
end

function btn_vals.unHover (self, xm, ym, dx, dy)
  print("unhover !!")
end
function btn_vals.WhilePressed (self, xm, ym, dx, dy)
  local bbt = self:isPressed()
  if( bbt[1] == true)then  --if left mouse button pressed than move button with 
    self:setPosition( self:getX() + dx , self:getY() + dy)
  end
end
function btn_vals.click (self, xm, ym, button)
  print("clicked")
end
function btn_vals.clickBorder (self, xm, ym, button)
  print("border clickesd")
end
function btn_vals.WhileBorderPressed (self, xm, ym, dx,dy)
    --- resize
    local x,y  = self:getX() + dx, self:getY() + dy
    local type = self:getType()
   -- change poly size
    if( type == 3) then
      if dy+dx ~= 0 then
        for i = 1, #self.vertex, 1 do
          self.vertex[i] =  dy+dx> 0 and self.vertex[i] * 1.05 or  self.vertex[i] * 0.95
        end
      end
    elseif  type == 1 then
      -- change rectangel size 
      if (self:getWidth()  +dx ) > 0  and (self:getHeight()  +dy  > 0)  and (self:getHeight() +dy+dx * 10 ) > 0 then
        self:setWidth (   self:getWidth()  + dx ) 
        self:setHeight(   self:getHeight() + dy ) 
      end
    elseif type == 2 then
      --- change radius size
      if((self:getRadius() +  (dy + dx)/2 ) > 0) then  
        self:setRadius( self:getRadius() + (dy + dx)/2)  
      end
    end
end
function btn_vals.WhileMoves (self,xm, ym, dx, dy, istouch)
  print("mouse moves on some button")
end
function btn_vals.scroll(self, xsd, ysd) 

  self:setX(self:getX() + ysd * 3)
end
function btn_vals.BorderUnHover(self, xm, ym, dx, dy)
    i_beam_cursor = love.mouse.getSystemCursor("arrow")
    love.mouse.setCursor(i_beam_cursor) 
    print("unhover_border")
end
function btn_vals.BorderHover (self, xm, ym, dx, dy)
    print("hover_border")
end
function btn_vals.WhileBorderHover (self, xm, ym, dx, dy)
    i_beam_cursor = love.mouse.getSystemCursor("sizens")
    love.mouse.setCursor(i_beam_cursor) 
end

-- seting all funciton to gived button
function addCallBacks(v)
  v:setClick(btn_vals.click)  
  v:setRelease(btn_vals.release)
  v:setReleaseBorder(btn_vals.borderRelease)  
  v:setScroll(btn_vals.scroll) 
  v:setWhileMoves( btn_vals.WhileMoves)
  v:setWhilePressed(btn_vals.WhilePressed)
  v:setWhileHover(btn_vals.Whilehover)
  v:setHover(btn_vals.hover)
  v:setUnHover(btn_vals.unHover)
  v:setWhileBorderPressed(btn_vals.WhileBorderPressed)
  v:setClickBorder(function (self, xm, ym, button)
    print("border clicked")
  end) -- 
  v:setBorderHover(btn_vals.BorderHover)
  v:setWhileBorderHover(btn_vals.WhileBorderHover)
  v:setBorderUnHover(btn_vals.BorderUnHover)
  return v
end

function love.load()
  success = love.window.setMode( 1500, 800 )

  bbt = require("libs.buttons.buttons")

   
  bbt:setBorderCheckWidht(5)
  bbt:setTranslate(0,-200)
  bbt:setLayer(1)
  bbt:toggleDebug()
  bbt:toggleDebug()
  local x,y = 400,400
  addCallBacks(bbt:newRect( x+100 ,y,80,80))
  addCallBacks(bbt:newPoly( x ,y+100,{0,140,100,80,80,0,20,20}))
  addCallBacks(bbt:newCircle( x-100 ,y,80))
  keys = {
    escape = function ()
        love.event.quit( )
    end,    
    f1 = function()
        bbt:toggleDebug()
    end,
    space = function()
        love.mouse.setPosition(220,200)
    end,
    f = function()
        if bbt:checkLayer(5) then
          bbt:delLayer(5)
        end
        bbt:setLayer(5)
        local size = 10
        local h,w
      
        local a = {}
        w = love.graphics.getWidth()/3
        h = love.graphics.getHeight()/3
        local space = love.graphics.getHeight()/3
        for s = 1, h/size, 1 do
            for i = 1, w/size, 1 do
                a = bbt:newRect(size*i-size + space,s*size - size + space,size,size)
                a:setHover(function (self, xm, ym, dx, dy) self:del() print("deleted")  end)
                a = nil
            end
        end
        bbt:setLayer(1)
    end,
    g = function()
      if bbt:checkLayer(5) then
        bbt:delLayer(5)
      end
    end,
    p = function()
        local layers = bbt:getLayers()
        for k, v in pairs(layers) do
            bbt:enableLayer(k) -- layer key is layer number
            for kb, btn in pairs(v) do
                btn:enable()
            end
        end
    end
  }
  keys['c'] = function()
    local x,y = bbt:TranslateScaleMosue(love.mouse.getX(), love.mouse.getY())
    local a = addCallBacks(bbt:newCircle(x,y,80))
  end
  keys['v'] = function()
    local x,y = bbt:TranslateScaleMosue(love.mouse.getX(), love.mouse.getY())
    addCallBacks(bbt:newRect( x ,y,80,80))
  end 
  keys['b'] = function()
    local x,y = bbt:TranslateScaleMosue(love.mouse.getX(), love.mouse.getY())
    addCallBacks(bbt:newPoly( x ,y,{0,140,100,80,80,0,20,20}))
  end


  --- border settings button

  toggle_border = bbt:newRect(10,600,40,40)
  toggle_border:setClick(function(self,xm,ym,button)
    if button == 2 then
       self.buttons.setBorderHoverState(not self.buttons.getBorderHoverState()) 
    end
  end
  )
  toggle_border:setWhilePressed(function(self,xm,ym,dxm,dym)
    if(    self:getY() + dym > 400 and  self:getY() + dym < 700 )
    then
      local y = self:getY() 
      self:setY( y+ dym)
      self.buttons:setBorderCheckWidht(     (y - 300) / 25)
 
    end
  end
  )
end


function love.update(dt)
  -- Main update function; nothing will work without this.
  bbt:updateMain(dt)

  -- Translate
  if love.keyboard.isDown("up") then
      bbt:setTranslateY(bbt:getTranslateY() + 3)  -- Move up
  end 
  if love.keyboard.isDown("down") then
      bbt:setTranslateY(bbt:getTranslateY() - 3)  -- Move down
  end
  if love.keyboard.isDown("right") then
      bbt:setTranslateX(bbt:getTranslateX() - 3)  -- Move right
  end
  if love.keyboard.isDown("left") then
      bbt:setTranslateX(bbt:getTranslateX() + 3)  -- Move left
  end

  -- Scale
  if love.keyboard.isDown("kp5") then
      bbt:setScale(bbt:getScale() - 0.02)  -- Decrease scale
  end
  if love.keyboard.isDown("kp2") then
      bbt:setScale(bbt:getScale() + 0.02)  -- Increase scale
  end
end

function love.draw()
  x,y = bbt:Translate( bbt:Scale(toggle_border:getPosition()))

  love.graphics.print("\n\n\n Move me to change border width \n clcik on me right button to toggle width",   x,y )
  -- Draw buttons and shapes. This function will render shapes when bbt.debug is not enabled.
  bbt:draw()

  love.graphics.setColor(1, 1, 1)
  love.graphics.print(
      [[
      c, v, b - Create different shapes
      Left button - Grab
      Scroll - Move
      Press on border - Resize
      o - Disable button 
      l - Disable layer where the button is stored
      p - Enable all layers 
      d - Delete 
      f - Create a couple of rectangles
      g - Delete these rectangles

      Arrow keys - Translate; num: 2, 5 - Scale

      f1 - Change debug mode 
      esc - Restart
      ]],
      400, 20)
end

function love.keypressed(key, scancode, isrepeat)
  -- Call the appropriate function if a key is pressed.
  if keys[key] then 
      keys[key](key, scancode, isrepeat)
  end
end

---------------------
--- Set up update functions
-- If you don't need some functionality, you can simply not use it.
---------------------

function love.mousepressed(xm, ym, button, istouch)
  -- Calls the click callbacks when the mouse is pressed.
  bbt:updateMouseClick(xm, ym, button)
end

function love.mousereleased(xm, ym, button)
  -- Calls the release callbacks when the mouse is released.
  bbt:updateMouseRelease(xm, ym, button)
end

function love.wheelmoved(xwd, ywd)
  -- Calls the scroll callbacks when the mouse wheel is moved.
  bbt:updateMouseScroll(xwd, ywd)
end

function love.mousemoved(xm, ym, dx, dy, istouch)
  -- Calls the while moving callbacks when the mouse is moved.
  bbt:updateMouseMoves(xm, ym, dx, dy, istouch)
end


