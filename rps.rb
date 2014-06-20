#
# Juego de Rock, Paper & Sccisors
#
# Author::    David Lilue  09-10444. Luis Miranda 10-10463
# Copyright:: Copyright (c) 2014 Universidad Simon Bolivar
# License::   Distribuye bajo los mismos terminos de Ruby

# Esta clase es la generalizacion de los movimientos 'Rock', 
# 'Paper' y 'Sccisors'.
# El metodo to_s imprime el nombre de la clase.

class Movement
  # Devuelve un string para la instancia de la clase.
  def to_s
    self.class.name
  end
end

# Esta clase representa la jugada de Rock(Piedra).

class Rock < Movement
  class << self
    # Enfrentamiento de Rock contra Paper invertido.
    def contra_paper
      [1,0]
    end
    # Enfrentamiento de Rock contra Rock invertido.
    def contra_rock
      [0,0]
    end
    # Enfrentamiento de Rock contra Sccisors invertido.
    def contra_sccisors
      [0,1]
    end
    # Calcula el score de Rock contra m.
    def score m
      m.contra_rock
    end
  end
end

# Esta clase representa la jugada de Paper(Papel).

class Paper < Movement
  class << self
    # Enfrentamiento de Paper contra Paper invertido.
    def contra_paper
      [0,0]
    end
    # Enfrentamiento de Paper contra Rock invertido.
    def contra_rock
      [0,1]
    end
    # Enfrentamiento de Paper contra Sccisors invertido.
    def contra_sccisors
      [1,0]
    end
    # Calcula el score de Paper contra m.
    def score m
      m.contra_paper
    end
  end
end

# Esta clase representa la jugada de Sccisors(Tijera).

class Sccisors < Movement
  class << self
    # Enfrentamiento de Sccisors contra Paper invertido.
    def contra_paper
      [0,1]
    end
    # Enfrentamiento de Sccisors contra Rock invertido.
    def contra_rock
      [1,0]
    end
    # Enfrentamiento de Sccisors contra Sccisors invertido.
    def contra_sccisors
      [0,0]
    end
    # Calcula el score de Sccisors contra m.
    def score m
      m.contra_sccisors
    end
  end
end

# Generalizacion de las estrategias de cada jugador.

class Strategy
  # Estructura usada para la estrategia de juego.
  attr_accessor :strategia
  # Estructura original.
  attr_accessor :original
  # Devuelve un string para la instancia de la clase.
  def to_s
    self.class.name
  end
  # Metedo para actulizar los valores de la estrategia. Si lo necesita.
  def update m 
  end
  # Lleva la estrategia a su estado inicial.
  def reset
    @strategia = @original
  end
end

# Estrategia de juego que elige uno a uno la jugada de la lista
# pasada en su construccion.

class Uniform < Strategy
  # Inicializa los valores heredades del padre con la lista pasada como parametro.
  def initialize lista
    raise ArgumentError::new("#{caller(0)[-1]}: La lista de movimientos debe ser no vacia") unless !lista.empty?
    @strategia = @original = lista.uniq
  end
  # Calcula la siguiente jugada de la estrategia.
  def next ms
    a = @strategia.first.to_s
    @strategia = @strategia.rotate
    begin
      Object::const_get(a)
    rescue NameError => ne
      raise Exception::new("#{caller(0)[-1]}: El movimiento \'#{a}\' no existe, solamente \'Rock\', \'Paper\' & \'Sccisors\'")
    end
  end
end

# Estrategia que calcula su proxima jugada a partir de las
# probabilidades pasadas como un Hash.

class Biased < Strategy
  # Numero de posibles jugadas.
  attr_accessor :f
  # Inicializa los valores heredades del padre con el mapa pasada como parametro.
  def initialize mapa
    raise ArgumentError::new("#{caller(0)[-1]}: El mapa de probabilidades debe ser no vacia") unless !mapa.empty?
    @original = mapa
    @strategia = mapa.clone
    @f = 0
    mapa.values.each { |x| @f += x }
  end
  # Calcula la siguiente jugada de la estrategia.
  def next ms
    if @f.eql? 0
      @strategia = @original.clone
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
        raise NameError::new("#{caller(0)[-1]}: La llave \'#{k}\' del Hash de probabilidades no puede ser reconocido como Movement")
      end
    end
  end
end

# Estrategia que copia la jugada anterior de su oponente.

class Mirror < Strategy
  # Inicializa la estrategia con un movimiento inicial.
  def initialize mov
    @strategia = @original = mov
  end
  # Calcula la siguiente jugada de la estrategia.
  def next ms
    if ms.empty?
      @strategia
    else
      ret = @strategia
      @strategia = ms.last
      ret
    end
  end
  # Actualiza el valor de strategia con m.
  def update m
    @strategia = m
  end
end

# Estrategia que decide su jugada a partir de recordar todas
# las jugadas del oponente. A partir de un calculo y aleatoriedad.

class Smart < Strategy
  # Contador de movimiento.
  attr_accessor :r, :p, :s
  #Inicializa todos los atributos en cero.
  def initialize
    @r = 0
    @p = 0
    @s = 0
  end
  # Calcula la siguiente jugada de la estrategia.
  def next ms
    ms.each do |m|
      self.update m
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
  # Actualiza un contador dependiendo de la jugada m
  def update m
    send("#{m.to_s[0].downcase}=", send("#{m.to_s[0].downcase}") + 1) if m.to_s =~ /\A(Rock|Paper|Sccisors)\z/
  end
  # Regresa al esstado inicial de la estrategia.
  def reset
    initialize
  end
end

# Esta clase simula el juego entre dos adversarios. 
# Cada uno con su respectiva instancia de una estrategia.

class Match
  # Mapa con el nombre de los jugadores como llaves y estrategias como values. 
  attr_accessor :jugadores
  # Mapa con los jugadores con su puntuacion y el numero de rounds.
  attr_accessor :puntuacion
  # Inicializa el mapa de jugadores con mapJ y crea uno nuevo para los puntajes.
  def initialize mapJ
    raise Exception::new("Se necesitan exactamente 2 jugadores, ni mas ni menos.") unless mapJ.length == 2
    @jugadores = mapJ
    @puntuacion = Hash.new

    mapJ.each { |k,v| @puntuacion[k] = 0}
    @puntuacion[:Rounds] = 0
  end
  # Realiza una unica jugada a partir de las estrategias de cada jugador.
  def play
    j = @jugadores.values
    x = j.map { |v| v.next([]) }
    [j,x.reverse].transpose.map { |s,u| s.update(u) }
    x = x[0].score(x[1])
    y = @jugadores.keys
    @puntuacion[y[0]] += x[0]; @puntuacion[y[1]] += x[1]
    @puntuacion[:Rounds] += 1
  end
  # Juega tantas veces como n diga.
  def rounds n
    if n > 0
      play 
      rounds(n - 1)
    end
  end
  # Juega hasta que un jugador alcanza el puntaje n.
  def upto n
    play until (@jugadores.keys.map { |k| @puntuacion[k] == n }).inject { |acc,x| acc || x }
  end
  # Vuelve la partida a su estado inicial.
  def restart
    @jugadores.values.each { |s| s.reset }
  end
end
