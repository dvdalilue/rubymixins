module BFS
  def find(start, predicate) # level - order (bfs)
    if !start.nil?
      q = [start]
      while !q.empty?
        a = q.shift
        return a if predicate.call(a.value)
        a.each { |c| q.push(c) }
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
        a.each { |c| q.push(c); p[c] = p[a] + [a] }
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

  def each #&block
    yield @left  unless @left.nil?
    yield @right unless @right.nil?
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

  def each
    @children.each do |c|
      yield c
    end unless @children.nil?
  end
end
