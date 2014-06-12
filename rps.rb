
#######################################
### Juego de Rock, Paper & Sccisors ###
###      David Lilue  09-10444      ###
###      Luis Miranda 10-10463      ###
#######################################

#########################################################
###                  Clase Movimiento                 ###
### Define la funcion 'to_s' para todas sus subclases ###
### Ademas de 'score' con doble despacho              ###
#########################################################

class Movement

  def to_s
    self.class.name
  end

  def score m
    m.send("#{self.class}contra")
  end
end

#########################################################
###               Subclases - Movimiento              ###
### Subclases 'Piedra', 'Papel' y 'Tijera' (en ingles)###
### para representar los movimientos en rps           ###
#########################################################

### Clase Rock ###

class Rock < Movement

  def Papercontra
    [1,0]
  end

  def Rockcontra
    [0,0]
  end

  def Sccisorscontra
    [0,1]
  end
end

### Clase Paper ###

class Paper < Movement

  def Papercontra
    [0,0]
  end

  def Rockcontra
    [0,1]
  end

  def Sccisorscontra
    [1,0]
  end
end

### Clase Sccisors ###

class Sccisors < Movement

  def Papercontra
    [0,1]
  end

  def Rockcontra
    [1,0]
  end

  def Sccisorscontra
    [0,0]
  end
end

#########################################################
###                   Clase Strategy                  ###
###     Representa cada jugador durante el juego      ###
#########################################################

class Strategy
  def to_s
    self.class.name
  end
end

#########################################################
###                Subclases - Strategy               ###
### Especializaciones de las clase Strategy para sus  ###
### distintos comportamientos en el juego de RPS      ###
#########################################################

### Clase Uniform ###

class Uniform < Strategy
  
  attr_accessor :movimientos

  def initialize lista
    @movimientos = lista
  end
end

### Clase Biased ###

class Biased < Strategy
  
  attr_accessor :probabilidades

  def initialize mapa
    @probabilidades = mapa
  end
end

### Clase Mirror ###

class Mirror < Strategy

  attr_accessor :actual

  def initialize mov
    @actual = mov
  end
end

### Clase Smart ###

class Smart

  attr_accessor :r, :p, :s

  def initialize
    @r = 0
    @p = 0
    @s = 0
  end
end

#########################################################
###                     Clase Match                   ###
###       Simula el juego entre dos adversarios       ###
#########################################################

class Match
  
  attr_accessor :jugadores, :puntuacion

  def initialize mapJ
    @jugadores = mapJ
    @puntuacion = new.Hash
    mapJ.each { |k,v| @puntuacion[k] = 0}
    @puntuacion[:Rounds] = 0
  end

  def restart
    # Llama las funciones 'reset' de cada estrategia
  end
end
