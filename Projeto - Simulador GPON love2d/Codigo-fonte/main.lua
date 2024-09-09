
require("interface")
require("contas")

local rede, UI

function love.load()
  love.graphics.setBackgroundColor(1,1,1,1)
  suit.theme.color.normal = {bg = {.75, .75, .75}, fg = {0, 0, 0}}
  
  local info = {
    potencia=4, 
    sensibilidade=26, 
    spliter=6, 
    atenuacaoCabo=0.5, 
    distancia=28, 
    conectores=4
  }
  rede = Rede.new(info)
  UI = Interface.new(rede)
end
--
function love.draw()    
  UI.run()
  suit.draw()
end
function love.textinput(t)
  suit.textinput(t)
end
function love.keypressed(key)
  suit.keypressed(key)
  if key == 'escape' then love.event.quit() end
end