module BFS
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
  
  def find(start, predicate)
    if start.respond_to? 'bfs'
      start.bfs(start) { |nodo| return nodo if predicate.call(nodo.value) }
    else
      puts "*** find: \'#{start}\' no es una estructura que pueda ser recorrida en BFS"
    end
  end

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

  def each b
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

class LCR
  attr_reader :value
  
  def initialize(where,left,right)
    
    left.map! { |c| c.to_sym }
    right.map! { |c| c.to_sym }
    
    @value = {"where"=>where.to_sym,"left"=>left,"right"=>right}
  end

  def to_s
    value.to_s
  end
end

  
