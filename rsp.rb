class Movement

	attr_accessor :x, :y

	def initialize(*arg)
		x = arg[0]
		y = arg[1]
	end
end

class Sccisors

	attr_accessor :o, :p

	def initialize(*arg)
		o = arg[0]
		p = arg[1]
	end

	def to_s
		"Sccisors"
	end
end

class Rock

	attr_accessor :i, :j

	def initialize(*arg)
		i = arg[0]
		j = arg[1]
	end

	def to_s
		"Rock"
	end
end

class Paper

	attr_accessor :a, :b

	def initialize(*arg)
		a = arg[0]
		b = arg[1]
	end

	def to_s
		"Paper"
	end
end
