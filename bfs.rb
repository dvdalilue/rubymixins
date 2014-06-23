# -*- coding: utf-8 -*-
#
# Juego de Rock, Paper & Sccisors
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
      padre = start
      start.bfs(start) do |nodo|
        return p[padre] + [nodo] if predicate.call(nodo.value)
        p[nodo] = p[padre] + [nodo]
        padre = nodo
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

# Modela el estado de un problema de busqueda sobre un árbol
# implícito de expansión. 
class LCR
  # Hash que mantiene la información del estado.
  attr_reader :value
  # Inicializa value con un nuevo Hash con la llaves
  # where, left, right. Cada una con un valor que es
  # la información del estado.
  def initialize(where,left,right)
    
    left.map! { |c| c.to_sym }
    right.map! { |c| c.to_sym }
    
    @value = {
      "where" => where.to_sym,
      "left"  => left,
      "right" => right
    }
  end
  # Resuelve el problema de búsqueda.
  def solve
  end
  # Devuelve un string del Hash value.
  def to_s
    value.to_s
  end
end

  
