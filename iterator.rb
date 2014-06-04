class Fixnum
  def genN
    if self.zero?
      yield 0
    else
      (self - 1).genN { |x| puts x.to_s }
      yield self
    end
  end

  def genZtoSelf
    m = self
    while !m.zero?
      yield m
      m = m - 1
    end
  end
end

def genZf(m,&block)
  n = 0
  if block
    while n <= m
      yield n
      n += 1
    end
  else
    r = []
    while n <= m
      r << n
      n += 1
    end
    return r
  end
end

def pairl s
  yield ""
  pairl(s) { |x|
    s.each_char { |c|
      yield x + c
    }
  }
end
