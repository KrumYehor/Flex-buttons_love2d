 local buttons = require("libs.buttons.buttons") -- loading library to table

 function love.load()
  buttons:setMaxQuantityLayers(2) 
  buttons:setLayer(1) 
  buttons:setLayer(3) 
  buttons:setLayer(5) -- throws error

 end