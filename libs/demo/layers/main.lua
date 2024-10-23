local buttons = require("libs.buttons.buttons") -- loading library to table\
local circle_button
function love.load()
  buttons:toggleDebug()

  buttons:setLayer(2) -- layer where button will create 

  buttons:newCircle(350,200,40)

  buttons:setLayer(1) -- layer where button will create 

  print(buttons:getCurrentLayerID()) -- 1
  circle_button = buttons:newCircle(250,200,40)
  buttons:disableLayer(1) -- disable layer one so circle become blocked 

end
function love.update(dt)
  buttons:updateMain() -- uppdate so hover will work

  local layers =  buttons:getLayers() -- getting all all layers
  local id = circle_button:getID() -- gettin button id 

  -- just to show that layer it is a table of buttons objects you can do it with circle_button
  if  layers[1] then
    local button = layers[1][id]
    button :setX( button :getX()+0.5) -- find button in layer and changing it  x 
  end

  -- press "e" to enable button
  if love.keyboard.isDown("e") then
    buttons:enableLayer(2) -- right circle active again

  end
  -- press "d" to disable button
  if love.keyboard.isDown("d") then
    buttons:disableLayer(2) -- right circle inactive 
  end
  -- press "v" to move button
  if love.keyboard.isDown("v") then
    local layer = buttons:getLayerByID(1) -- get layer 
    local id = circle_button:getID() -- gettin button id 
    -- just to show that layer it is a table of buttons objects you can do it with circle_button
    layer[id]:setX( layer[id]:getX()+5) -- find button in layer and changing it  x 
  end
    -- press "c" to move button
  if love.keyboard.isDown("c") then
    local layer = buttons:getLayerByID(1) -- get layer 
    local id = circle_button:getID() -- gettin button id 
    -- just to show that layer it is a table of buttons objects you can do it with circle_button
    layer[id]:setX( layer[id]:getX()-5) -- find button in layer and changing it  x 
  end
    -- press "s" to delete layer 1
    if love.keyboard.isDown("s") then
      if  buttons:checkLayer(1) then
        buttons:delLayer(1)
      end
    end
    -- press x to restore layer 1 
    if love.keyboard.isDown("x") then
      if not  buttons:checkLayer(1) then
          buttons:setLayer(1) -- layer where button will create 
          circle_button = buttons:newCircle(250,200,40)
      end
    end
end
function love.draw()
  if  buttons:checkLayer(1) then
    love.graphics.print( "Layer exist",400,400)
  end
  love.graphics.print(" -- press x  s to restore delete layer 1   \n press c v  to move button  \n -- press e d to enable disable button",10,500)
  buttons:draw()
end
