class BinTree
  attr_accessor :value, # Valor almacenado en el nodo
                :left,  # BinTree izquierdo
                :right  # BinTree derecho
  
  def initialize(v,l,r)
    @value = v
    @left  = l
    @right = r
  end

  def each #&block 
    if !self.eql? nil
      yield value # pre - order
      left.each  { |l| yield l } unless left.eql? nil
      right.each { |r| yield r } unless right.eql? nil
    end
  end
end

class GraphNode
  attr_accessor :value,   #Valor almacenado en el nodo
                :children #Arreglo de sucesores GraphNode
  
  def initialize(v,c)
    @value    = v
    @children = c
  end

  def each
    if !self.eql? nil
      yield value
      children.each do |c|
        c.each { |h| yield h } unless c.eql? nil
      end unless children.eql? nil
    end
  end
end
