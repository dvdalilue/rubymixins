class BinTree
  include BFS
  attr_accessor :value, # Valor almacenado en el nodo
                :left,  # BinTree izquierdo
                :right  # BinTree derecho
  
  def initialize(v,l,r)
    @value = v
    @left  = l
    @right = r
  end

  def each #&block
    yield @left  unless @left.nil?
    yield @right unless @right.nil?
  end
end

class GraphNode
  include BFS
  attr_accessor :value,   #Valor almacenado en el nodo
                :children #Arreglo de sucesores GraphNode

  def initialize(v,c)
    @value    = v
    @children = c
  end

  def each
    @children.each do |c|
      yield c
    end unless @children.nil?
  end
end

module BFS
  def find(start, predicate) # level - order (bfs)
    if !start.eql? nil
      q = [start]
      while !q.empty?
        a = q.shift
        return a if a.value.send(predicate)
        a.each { |c| q.push(c) }
      end
    end
  end
end
