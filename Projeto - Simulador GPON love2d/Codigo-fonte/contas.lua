
Rede = {}
Rede.new = function(info)
  local self = self or {}
  
  self.potencia = info.potencia
  self.sensibilidade = info.sensibilidade
  self.spliter = info.spliter
  self.atenuacaoCabo = info.atenuacaoCabo
  self.conectores = info.conectores  
  self.distancia = info.distancia
  
  self.atenuacaoConectores = .25
  
  self.problema = "Nenhum no momento :)"
  
  ---- Passo 1: verificar se as informações estão certas e salvar se estiverem
  self.setInfo = function(info,tipos)
    -- Verifica se alguma informação usada não é um número
    for i,prop in ipairs(tipos) do
      if tonumber(info[prop]) == nil then 
        self.problema = "Preencha todos os campos corretamente!"
        return false
      end
    end
    
    -- Se estiver tudo certo, 
    for i,prop in ipairs(tipos) do self[prop] = tonumber(info[prop])  end
    self.problema = "Nenhum no momento :)"
    return true
  end
  --
  ---- Passo 2: fazer a operação escolhida
  self.calcularDistancia = function()
    self.distancia = math.abs(self.sensibilidade + 1 - self.potencia + (self.conectores * 0.25) + self.spliter) / self.atenuacaoCabo
    if self.sensibilidade > 0 then
      if self.distancia < 0 then self.problema = "Distância negativa! Rede não funciona!" end
    else       
      if (self.sensibilidade + 1 - self.potencia + (self.conectores * 0.25) + self.spliter) > 0 then
        self.problema = "Valores não funcionais na rede!" 
      end
    end
    return self.distancia
  end
  --
  self.calcularPotencia = function()
    self.potencia = (self.sensibilidade + 1 + (self.conectores * 0.25) + self.spliter) / self.atenuacaoCabo
    if self.sensibilidade > 0 then
      self.potencia = (self.sensibilidade - 1 - (self.conectores * 0.25) - self.spliter) / (self.atenuacaoCabo*self.distancia)
    else 
      if (self.sensibilidade + 1 + (self.conectores * 0.25) + self.spliter + (self.atenuacaoCabo*self.distancia)) > 0 then
        self.problema = "Valores não funcionais na rede!" 
      end
    end
    return self.potencia
  end
  --
  self.calcularSensibilidade = function()
    if self.potencia > 0 then
      self.sensibilidade = self.potencia + (self.conectores * 0.25) + self.spliter + (self.atenuacaoCabo * self.distancia)
      self.sensibilidade = self.sensibilidade + math.ceil(self.sensibilidade*0.04)
      if self.sensibilidade < 0 then self.problema = "Sensibilidade negativa! Rede não funciona!" end
    else
      self.sensibilidade = self.potencia - 2 - (self.conectores * 0.25) - self.spliter - (self.atenuacaoCabo*self.distancia)
      if self.sensibilidade < 0 then self.problema = "Sensibilidade negativa! Rede não funciona!" end
    end
    return self.sensibilidade
  end
  --
  self.calcularSpliter = function()
    if self.sensibilidade > 0 then
      self.spliter = (self.sensibilidade - 1 - self.potencia - (self.conectores * 0.25)) - (self.distancia * self.atenuacaoCabo)
      self.sensibilidade = self.sensibilidade + math.ceil(self.sensibilidade*0.04)
      if self.spliter < 0 then self.problema = "Spliter negativo! Rede não funciona!" end
    else 
      self.spliter = (self.sensibilidade + 1 - self.potencia + (self.conectores * 0.25)) + (self.distancia * self.atenuacaoCabo)
      --self.sensibilidade = self.sensibilidade - math.ceil(self.sensibilidade*0.04)
      if self.spliter < 0 then self.problema = "Spliter negativo! Rede não funciona!" end
    end
    return self.spliter
  end
  --
  self.calcularCoefAtenuacao = function()
    if (self.sensibilidade > 0) then
      self.atenuacaoCabo = (self.sensibilidade - 1 - self.potencia - (self.conectores * 0.25)- self.spliter) / (self.distancia) 
    else 
      self.atenuacaoCabo = math.abs(self.sensibilidade + 1 + self.potencia + (self.conectores * 0.25) + self.spliter) / (self.distancia)
    end
    return self.atenuacaoCabo
  end
  --
  self.calcularConectores = function()
    if self.sensibilidade > 0 then
      self.conectores = (self.sensibilidade - 1 - self.potencia - self.spliter) - (self.distancia*self.atenuacaoCabo)
      self.conectores = self.conectores*4
    else
      self.conectores = math.abs(self.sensibilidade + 1 - self.potencia + self.spliter) + (self.distancia*self.atenuacaoCabo)
      self.conectores = self.conectores*4
    end
    return self.conectores
  end
  --
  
  return self
end