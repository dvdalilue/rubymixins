module BFS
  def find(start, predicate) # level - order (bfs)
    if !start.nil?
      q = [start]
      block = lambda { |c| q.push(c) }
      while !q.empty?
        a = q.shift
        return a if predicate.call(a.value)
        a.each block
      end
    end
  end

  def path(start, predicate)
    if !start.nil?
      q = [start]
      p = { start => [] }
      while !q.empty?
        a = q.shift
        return p[a] + [a] if predicate.call(a.value)
        block = lambda { |c| q.push(c); p[c] = p[a] + [a] }
        a.each block
      end
    end
  end
end

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

  def each b #&block
    b.call(@left)  unless @left.nil?
    b.call(@right) unless @right.nil?
  end

  def to_s
    "#{@value}"
    #"(#{@value}-#{@left.to_s}-#{@right.to_s})"
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

  def each b
    @children.each do |c|
      b.call(c)
    end unless @children.nil?
  end
end
