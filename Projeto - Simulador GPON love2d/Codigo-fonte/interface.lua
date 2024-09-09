
suit = require "suit"

Interface = {}
Interface.new = function(info)
  local self = self or {}
  
  self.x, self.y = 50, 50
  
  self.potencia = {text = tostring(info.potencia)}
  self.sensibilidade = {text = tostring(info.sensibilidade)}
  self.spliter = {text = tostring(info.spliter)}
  self.atenuacaoCabo = {text = tostring(info.atenuacaoCabo)}
  self.conectores = {text = tostring(info.conectores)}
  self.distancia = {text = tostring(info.distancia)}
  
  self.rede = info
  
  self.run = function()
    -- Fundo cinza da caixa
    love.graphics.setColor(0,0,0,1)
    love.graphics.rectangle('line',self.x-10,self.y-10,320,500)
    
    suit.layout:reset(self.x,self.y,5,10)

    suit.Label("Potencia Pt (dB)", {align="left"}, suit.layout:row(300,30))
    suit.Input(self.potencia, suit.layout:row(150,30))
    if suit.Button("\tCalcular\t\n",{id=1},suit.layout:nextCol()).hit then
      local info, tipos = {
        sensibilidade = self.sensibilidade.text,
        spliter = self.spliter.text,
        atenuacaoCabo = self.atenuacaoCabo.text,
        conectores = self.conectores.text,
        distancia = self.distancia.text
      }, { "sensibilidade", "spliter", "atenuacaoCabo",
"conectores", "distancia" }
      if self.rede.setInfo(info,tipos) then 
        self.potencia.text = tostring(self.rede.calcularPotencia())
      end
    end
    --

    suit.Label("Sensibilidade (dB)", {align = "left"}, suit.layout:row(300,30))
    suit.Input(self.sensibilidade, suit.layout:row(150,30))
    if suit.Button("\tCalcular\t\n",{id=2},suit.layout:nextCol()).hit then 
      local info, tipos = {
        potencia = self.potencia.text,
        spliter = self.spliter.text,
        atenuacaoCabo = self.atenuacaoCabo.text,
        conectores = self.conectores.text,
        distancia = self.distancia.text
      }, { "potencia", "spliter", "atenuacaoCabo",
"conectores", "distancia" }
      if self.rede.setInfo(info,tipos) then 
        self.sensibilidade.text = tostring(self.rede.calcularSensibilidade())
      end
    end
    --
    
    suit.Label("Splitter", {align = "left"}, suit.layout:row(300,30))
    suit.Input(self.spliter, suit.layout:row(150,30))
    if suit.Button("\tCalcular\t\n",{id=3},suit.layout:nextCol()).hit then
      local info, tipos = {
        potencia = self.potencia.text,
        sensibilidade = self.sensibilidade.text,
        atenuacaoCabo = self.atenuacaoCabo.text,
        conectores = self.conectores.text,
        distancia = self.distancia.text
      }, { "potencia", "sensibilidade", "atenuacaoCabo",
"conectores", "distancia" }
      if self.rede.setInfo(info,tipos) then 
        self.spliter.text = tostring(self.rede.calcularSpliter())
      end
    end
    --

    suit.Label("Coeficiente de Atenuação no cabo", {align = "left"}, suit.layout:row(300,30))
    suit.Input(self.atenuacaoCabo, suit.layout:row(150,30))   
    if suit.Button("\tCalcular\t\n",{id=4},suit.layout:nextCol()).hit then
      local info, tipos = {
        potencia = self.potencia.text,
        sensibilidade = self.sensibilidade.text,
        spliter = self.spliter.text,
        conectores = self.conectores.text,
        distancia = self.distancia.text
      }, { "potencia", "sensibilidade", "spliter",
"conectores", "distancia" }
      if self.rede.setInfo(info,tipos) then 
        self.atenuacaoCabo.text = tostring(self.rede.calcularCoefAtenuacao())
      end
    end
    --
    
    suit.Label("Número de conectores (0.25 dB/conector)", {align = "left"}, suit.layout:row(300,30))
    suit.Input(self.conectores, suit.layout:row(150,30))
    if suit.Button("\tCalcular\t\n",{id=5},suit.layout:nextCol()).hit then
      local info, tipos = {
        potencia = self.potencia.text,
        sensibilidade = self.sensibilidade.text,
        spliter = self.spliter.text,
        atenuacaoCabo = self.atenuacaoCabo.text,
        distancia = self.distancia.text
      }, { "potencia", "sensibilidade", "spliter",
"atenuacaoCabo", "distancia" }
      if self.rede.setInfo(info,tipos) then 
        self.conectores.text = tostring(self.rede.calcularConectores())
      end
    end
    --

    suit.Label("Distância máxima (km)", {align = "left"}, suit.layout:row(300,30))
    suit.Input(self.distancia, suit.layout:row(150,30))    
    if suit.Button("\tCalcular\t\n",{id=6},suit.layout:nextCol()).hit then
      local info, tipos = {
        potencia = self.potencia.text,
        sensibilidade = self.sensibilidade.text,
        spliter = self.spliter.text,
        atenuacaoCabo = self.atenuacaoCabo.text,
        conectores = self.conectores.text
      }, { "potencia", "sensibilidade", "spliter",
"atenuacaoCabo", "conectores" }
      if self.rede.setInfo(info,tipos) then 
        self.distancia.text = tostring(self.rede.calcularDistancia())
      end
    end
    --
    
    suit.layout:down(150,30)
    if suit.Button("Sair", suit.layout:row(300,30)).hit then love.event.quit() end
    
    -- Tela de problemas, fica vazia caso a conta de certo
    love.graphics.rectangle('line',self.x+310,self.y-10,320,60)
    suit.Label("Problema:\n"..string.upper(self.rede.problema),self.x+310,self.y-10,320,60)
    
    -- Desenho da topografia
    --print(self.x,self.y)
    desenhoTopografia(self.x+310,self.y+50)
  end
  --
  
  return self
end
--
desenhoTopografia = function(x,y)
  love.graphics.printf("Topografia", x+5,y+5, 100)
  love.graphics.rectangle('line', x,y, 320,500)
  love.graphics.rectangle('fill', x+160,y+25, 1,400)
  
  love.graphics.setColor(.50,.50,1,1)
  love.graphics.circle('fill',x+160,y+75,50)
  suit.Label("NUVEM", {align = "center"}, x+110,y+25, 100,100)
  
  love.graphics.setColor(.50,1,.50,1)
  love.graphics.rectangle('fill',x+60,y+140, 200,60)
  suit.Label("OLT\n10 dB", {align = "center"}, x+60,y+140, 200,60)
  
  love.graphics.setColor(.50,1,.50,1)
  love.graphics.rectangle('fill',x+60,y+220, 200,60)
  suit.Label("SPLITTER\n5 dB", {align = "center"}, x+60,y+220, 200,60)
  
  love.graphics.setColor(.50,1,.50,1)
  love.graphics.rectangle('fill',x+60,y+300, 200,60)
  suit.Label("ANU\n-26 dB", {align = "center"}, x+60,y+300, 200,60)
  
  love.graphics.setColor(1,.50,.50,1)
  love.graphics.circle('fill',x+160,y+430,50)
  suit.Label("USUÁRIO FINAL", {align = "center"}, x+110,y+380, 100,100)
end