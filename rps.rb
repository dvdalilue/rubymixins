
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
      m.send("#{self.to_s}contra")
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
  attr_accessor :strategia, :original

  def to_s
    self.class.name
  end

  def update m
  end

  def reset
    @strategia = @original
  end
end

#########################################################
###                Subclases - Strategy               ###
### Especializaciones de las clase Strategy para sus  ###
### distintos comportamientos en el juego de RPS      ###
#########################################################

### Clase Uniform ###

class Uniform < Strategy

  def initialize lista
    raise ArgumentError::new("#{caller(0)[-1]}: La lista de movimientos debe ser no vacia") unless !lista.empty?
    @strategia = @original = lista.uniq
  end

  def next ms
    a = @strategia[0].to_s
    @strategia = @strategia.rotate
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
  
  attr_accessor :f

  def initialize mapa
    raise ArgumentError::new("#{caller(0)[-1]}: El mapa de probabilidades debe ser no vacia") unless !mapa.empty?
    @strategia = @original = mapa
    @f = 0
    mapa.values.each { |x| @f += x }
  end

  def next ms
    if @f.eql? 0
      @strategia = @original
      @original.values.each { |x| @f += x }
      self.next ms
    else
      r = (rand*@f).truncate; e = []
      v = @strategia.values.sort.reverse
      v.each { |p| e.concat([p]*p) }
      k = @strategia.key(e[r])
      @strategia[k] -= 1
      @f -= 1
      begin
        Object::const_get(k.to_s)
      rescue NameError => ne
        raise NameError::new("#{caller(0)[-1]}: La llave \'#{k.to_s}\' del Hash de probabilidades no puede ser reconocido como Movement")
      end
    end
  end
end

### Clase Mirror ###

class Mirror < Strategy

  def initialize mov
    @strategia = @original = mov
  end

  def next ms
    if ms.empty?
      @strategia
    else
      ret = @strategia
      @strategia = ms.last
      ret
    end
  end

  def update m
    @actual = m
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
      self.update m
#      elsif m.to_s == "Sccisors"
#        @s += 1
#      else
#        raise Exception::new("Existe un elemento de la lista que no es subclase de Movement")
#      end
    end
    
    random = (rand*(@r+@p+@s)).truncate

    if 0 <= random || random < p
      Sccisors
    elsif random < (@p + @r)
      Paper
    else  # if random < (@p + @r + @s)
      Rock
    end
  end
  
  def update m
    if    m.to_s == "Rock"
      @r += 1
    elsif m.to_s == "Paper"
      @p += 1
    else 
      @s += 1
    end
  end

  def reset
    initialize
  end
end

#########################################################
###                     Clase Match                   ###
###       Simula el juego entre dos adversarios       ###
#########################################################

class Match
  
  attr_accessor :jugadores, :puntuacion

  def initialize mapJ
    raise Exception::new("Se necesitan exactamente 2 jugadores, ni mas ni menos.") unless mapJ.length == 2
    @jugadores = mapJ
    @puntuacion = Hash.new

    mapJ.each { |k,v| @puntuacion[k] = 0}
    @puntuacion[:Rounds] = 0
  end

  def play
    j = @jugadores.values
    x = j.map { |v| v = v.next([]) }
    [j,x.reverse].transpose.map { |s,u| s.update(u) }
    x = x[0].score(x[1])
    y = @jugadores.keys

    @puntuacion[y[0]] += x[0]
    @puntuacion[y[1]] += x[1]
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
    @jugadores.values.each { |s| s.reset }
  end
end
