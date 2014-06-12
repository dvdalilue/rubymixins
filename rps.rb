
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

  class << self
    def score m
      m.send("#{self.name}contra")
    end
  end
end

#########################################################
###               Subclases - Movimiento              ###
### Subclases 'Piedra', 'Papel' y 'Tijera' (en ingles)###
### para representar los movimientos en rps           ###
#########################################################

### Clase Rock ###

class Rock < Movement
  class << self
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
end

### Clase Paper ###

class Paper < Movement
  class << self
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
end

### Clase Sccisors ###

class Sccisors < Movement
  class << self
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

class Uniform < Strategy #usar array.rotate
  
  attr_accessor :movimientos, :original

  def initialize lista
    raise ArgumentError::new("#{caller(0)[-1]}: La lista de movimientos debe ser no vacia") unless !lista.empty?
    @movimientos = @original = lista.uniq
  end

  def next ms
    a = @movimientos[0].to_s
    @movimientos = @movimientos.rotate
    if    a == "Rock"
      Rock
    elsif a == "Paper"
      Paper
    elsif a == "Sccisors"
      Sccisors
    else
      raise Exception::new("#{caller(0)[-1]}: El movimiento \'#{a}\' no existe, solamente \'Rock\', \'Paper\' & \'Sccisors\'")
    end
  end
end

### Clase Biased ###

class Biased < Strategy
  
  attr_accessor :probabilidades

  def initialize mapa
    raise ArgumentError::new("#{caller(0)[-1]}: El mapa de probabilidades debe ser no vacia") unless !mapa.empty?
    @probabilidades = mapa
  end

  def next ms
    Rock
  end
end

### Clase Mirror ###

class Mirror < Strategy

  attr_accessor :actual

  def initialize mov
    @actual = mov
  end

  def next ms
    if ms.empty?
      @actual
    else
      ret = @actual
      @actual = ms[0]
      ret
    end
  end
end

### Clase Smart ###

class Smart < Strategy

  attr_accessor :r, :p, :s

  def initialize
    @r = 0
    @p = 0
    @s = 0
  end

  def next ms
    ms.each do |m|
      if    m == Rock
        @r += 1
      elsif m == Paper
        @p += 1
      elsif m == Sccisors
        @s += 1
      else
        raise Exception::new("Existe un elemento de la lista que no es subclase de Movimiento")
      end
    end
    
    random = (rand*(@r+@p+@s)).truncate

    if random < p
      Sccisors
    elsif random < (@p + @r)
      Paper
    else  #if  random < (@p + @r + @s)
      Rock
    end
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
    @puntuacion = Hash.new
    mapJ.each { |k,v| @puntuacion[k] = 0}
    @puntuacion[:Rounds] = 0
  end

  def play

    x = []
    y = []
    i = 0

    @jugadores.each do |k,v|
      x << v.next([])
      y << k
    end

    z = x[0].score(x[1])

    [z,y].transpose.each do |n,k|
      @puntuacion[k] += n
    end
    @puntuacion[:Rounds] += 1
  end

  def rounds n
    if n > 0
      play 
      rounds(n - 1)
    end
  end

  def upto n
    play until @puntuacion.has_value? n # Esto realizara 100 rondas, dado que el hash tiene a :Rounds (counter) 
  end

  def restart
    # Llama las funciones 'reset' de cada estrategia
  end
end
