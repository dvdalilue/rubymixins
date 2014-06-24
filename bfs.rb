# -*- coding: utf-8 -*-
#
# Implementacion de Arbol Binario y Grafo de Nodos. Ademas de su recorrido BFS.
#
# Author::    David Lilue  09-10444. Luis Miranda 10-10463
# Copyright:: Copyright (c) 2014 Universidad Simon Bolivar
# License::   Distribuye bajo los mismos terminos de Ruby

# Modulo para el recorrido en BFS(level - order).
# El metodo bfs solo recorre, devolviendo nodo a nodo.
# El metodo find, busca el elemento que cumpla el predicado.
# El metodo path, devuelve el camino al elemento que cumpla el predicado.
# El metodo walk, realiza una accion en todos los nodos. Sino solo recorre.
module BFS
  # Recorre iterativamente desde start usando Breadth-First Search.
  def bfs(start)
    q = [start]
    visitado = []
    block = lambda { |c| q.push(c) }
    while !q.empty?
      a = q.shift
      if !visitado.include? a
        a.each block
        yield a
        visitado << a
      end
    end
  end
  # Busca el primer elemento de la estructura que cumpla el
  # predicado(predicate) haciendo uso del metodo bfs.
  def find(start, predicate)
    if start.respond_to? 'bfs'
      b = lambda { |c| print(c);print("\n") }
      start.bfs(start) { |nodo| return nodo if predicate.call(nodo.value) }
    else
      puts "*** find: \'#{start}\' no es una estructura que pueda ser recorrida en BFS"
    end
  end
  # Devuelve el camino desde start hasta el nodo que cumpla el
  # predicado(predicate) haciendo uso del metodo bfs.
  def path(start, predicate)
    if start.respond_to? 'bfs'
      p = { start => [] }
      start.bfs(start) do |nodo|
        return p[nodo] + [nodo] if predicate.call(nodo.value)
        block = lambda { |c| p[c] = p[nodo] + [nodo] }
        nodo.each block
      end
    else
      puts "*** path: \'#{start}\' no es una estructura que pueda ser recorrida en BFS"
    end    
  end
  # Recorre toda la estructura desde start, aplicando la
  # accion(action), a todos los nodos vistados y los devuelve
  # en una lista.
  def walk(start, action=lambda {|doe|})              
    if start.respond_to? 'bfs'
      visitados = []
      start.bfs(start) do |nodo|
        action.call(nodo)
        visitados << nodo
      end
      visitados
    else
      puts "*** walk: \'#{start}\' no es una estructura que pueda ser recorrida en BFS"
    end                           
  end
end

# Arbol binario, con un solo valor en los nodos.
class BinTree
  include BFS
  # Valor almacenado en el nodo.
  attr_accessor :value
  # BinTree izquierdo.
  attr_accessor :left
  # BinTree derecho.
  attr_accessor :right
  # Inicializa los atributos del arbol con los parametros.
  def initialize(v,l,r)
    @value = v
    @left  = l
    @right = r
  end
  # Itera sobre los hijos de nodo.
  def each b
    b.call(@left)  unless @left.nil?
    b.call(@right) unless @right.nil?
  end
  # Devuelve una version imprimible(entendible) del nodo.
  def to_s
    "#{@value}"
    #"(#{@value}-#{@left.to_s}-#{@right.to_s})"
  end
end

# Grafo de nodos donde cada nodo puede tener \'n\' hijos.
class GraphNode
  include BFS
  #Valor almacenado en el nodo.
  attr_accessor :value
  #Arreglo de sucesores GraphNode.
  attr_accessor :children

  # Inicializa los atributos del arbol con los parametros.
  def initialize(v,c)
    @value    = v
    @children = c
  end
  # Itera sobre los hijos del nodo.
  def each b
    @children.each do |c|
      b.call(c)
    end unless @children.nil?
  end
end

class BoteError < Exception; end
class EntidadError < Exception; end

# Modela el estado de un problema de busqueda sobre un árbol
# implícito de expansión. 
class LCR
  include BFS
  # Hash que mantiene la información del estado.
  attr_reader :value
  # Inicializa value con un nuevo Hash con la llaves
  # where, left, right. Cada una con un valor que es
  # la información del estado.
    
  def initialize(where,left,right)

    raise ArgumentError.new("El numero de entidades entre las orillas del problema debe ser \'3\' y fueron dados \'#{left.length + right.length}\'") unless left.length + right.length == 3
    
    if !(where.to_s =~ /\A(i|d|l|r|left|right|izquierda|derecha)\z/)
      raise BoteError.new("La posicion \'#{where}\' del bote es invalida. Posibles posiciones: \':i\', \':d\', \':l\', \':r\', \':left\', \':right\', \':izquierda\', \':derecha\'.")
    end

    left.each do |e|
      if !(e.to_s =~ /\A(cabra|repollo|lobo)\z/)
        raise EntidadError.new("Entidad desconocida \'#{e}\'. Las entidades de las orillas debe ser: \'cabra\', \'repollo\' ó \'lobo\'")
      end
    end
    right.each do |e|
      if !(e.to_s =~ /\A(cabra|repollo|lobo)\z/)
        raise EntidadError.new("Entidad desconocida \'#{e}\'. Las entidades de las orillas debe ser: \'cabra\', \'repollo\' ó \'lobo\'")
      end
    end
    begin
      left.map!  { |c| c.to_sym }
      right.map! { |c| c.to_sym }
      side = where.to_sym
    rescue NoMethodError => nme
      raise NoMethodError.new("Algun elemento de los arreglos (left ó right) ó where no se puede pasar a Symbol")
    end
    @value = {
      "where" => side,
      "left"  => left,
      "right" => right
    }
  end        

  # Resuelve el problema de búsqueda.
  def each b
    case
#    when @value["where"].equal?(:r)      
    when [:d,:r,:derecha,:right].include?(@value["where"])
      @value["right"].each do |x|
        derecha = Array.new(@value["right"])
        derecha.delete(x)
        izquierda = (Array.new(@value["left"])).push(x)
        ret = LCR.new("l",izquierda,derecha)
        if ret.check
          b.call(ret)
        end
      end
      ret = LCR.new("l",@value["left"],@value["right"])
      if ret.check
        b.call(ret)
      end
#    when @value["where"].equal?(:l)      
    when [:i,:l,:izquierda,:left].include?(@value["where"])
      @value["left"].each do |x|
        izquierda = Array.new(@value["left"])
        izquierda.delete(x)
        derecha = (Array.new(@value["right"])).push(x)
        ret = LCR.new("r",izquierda,derecha)
        if ret.check
          b.call(ret)        
        end
      end
      ret = LCR.new("r",@value["left"],@value["right"])
      if ret.check
        b.call(ret)
      end
    end
  end

  # Devuelve un string del Hash value.
  def to_s
    value.to_s
  end

  def check
    if (@value["left"].include?(:lobo) and @value["left"].include?(:cabra)) or
        (@value["left"].include?(:cabra) and @value["left"].include?(:repollo))
      false
    else
      true
    end
    if (@value["right"].include?(:lobo) and @value["right"].include?(:cabra)) or
        (@value["right"].include?(:cabra) and @value["right"].include?(:repollo))
      false
    else
      true
    end
  end
    
  def ==(lcr2)
    (@value["right"].sort == lcr2.value["right"].sort) and
      (@value["left"].sort == lcr2.value["left"].sort) and
      (@value["where"] == lcr2.value["where"])
  end
  
  def solve
    goal = [:repollo,:cabra,:lobo]
    p = Proc.new { |x| x["right"].sort == goal.sort and [:d,:r,:derecha,:right].include?(@value["where"])
}
    path(self,p)
  end
end
