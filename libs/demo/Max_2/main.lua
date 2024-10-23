 local buttons = require("libs.buttons.buttons") -- loading library to table\

 function love.load()
 buttons:setMaxQuantityLayers(1) 
 buttons:setMaxQuantityButtonsInLayer(2)

 print(buttons:getMaxQuantityLayers()) -- 1
 print(buttons:getMaxQuantityButtonsInLayer()) -- 2

 buttons:newCircle(200,200,40)  
 buttons:newCircle(200,350,40)  
 buttons:newCircle(200,400,40) -- throws error

end