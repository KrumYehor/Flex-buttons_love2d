local buttons = require("libs.buttons.buttons") -- loading library to table\

function love.load()
buttons:toggleDebug() -- several calls because debug has multiply states
buttons:toggleDebug() 
buttons:toggleDebug() 
buttons:toggleDebug() -- show debug data and shapes

buttons:setLayer(1) -- leayer where nex button will be created
buttons:newCircle(200,200,40)  -- create new circle 
buttons:setLayer(2) --btns created in different layers
buttons:newCircle(200,300,40) -- create scond circle 

  b = buttons:newCircle(200,200,20)  -- this one will stay under cursor 
  a = buttons:newCircle(200,200,40)  -- this one will move away

end
function love.update(dt)
buttons:updateMain() -- uppdate so hover works and click
  -------
  -- Scaling
  local scale = btns:getScale() -- getting scale
   -- add if scale until 1.3 then set 0
  if(scale < 1.6 ) then buttons:setScale(scale + 0.003)  else buttons:setScale(1)   end
  -------
  -- translating
  local x,y = btns:getTranslate() -- getting button position in layers 
 -- add if x less than 500 else set translate -100
  if(x < 200 ) then buttons:setTranslateX(x+1)  else  buttons:setTranslateX(0)  end


  xm,ym = love.mouse.getPosition()
  a:setPosition(xm,ym) -- with out :TranslateScaleMosue wheen scale or translation changes its not works well

  xm,ym = btns:TranslateScaleMosue(xm,ym) -- basicaly you can use this for any point on screen
  b:setPosition(xm,ym) -- that one looks normal 

end
function love.draw()

  local x,y = btns:Translate(0, 0)
  local sc = btns:Scale(1)

  love.graphics.print("translated x: " .. x .. " y: " .. y , 50,500)
  love.graphics.print("scaled one " .. sc , 50,530)
  
buttons:draw()
end