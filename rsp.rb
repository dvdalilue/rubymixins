$gana = {
  Paper    => Rock    ,
  Rock     => Sccisors,
  Sccisors => Paper   ,
}

class Movement

	attr_accessor :x, :y

	def initialize(*arg)
		x = arg[0]
		y = arg[1]
	end

  def to_s
    self.class.name
  end

  # def score m
  #   if m.class == self.class
  #     [0,0]
  #   elsif $gana[m.class] == self.class
  #     [0,1]
  #   else
  #     [1,0]
  #   end
  # end

  def score m
    m.send("#{self.class}contra")
  end
end

class Strategy
  
end

class Sccisors < Movement

	attr_accessor :o, :p

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

class Rock < Movement

	attr_accessor :i, :j

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

class Paper < Movement

	attr_accessor :a, :b

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
