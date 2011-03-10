require 'digest/sha1'

class FileHashTree
  attr_accessor :file_hash, :master
  def initialize(f)
    @file_hash = Digest::SHA1.file(f)
    @master = generate_leaves(f)
    @master.build()
  end
  
  def generate_leaves(f)
    lines = []
    File.open(f, 'r') do |file|
      file.each_line do |line|
        lines << FileHash.new(line)        
      end
    end
    lines << FileHash.new("\n") if lines.length % 2 > 0
    while lines.length > 1
      condense = []
      while lines.length > 0
        condense << FileHash.new(lines.pop(), lines.pop())
      end
      condense.reverse
      lines = condense
    end
      lines.pop()
  end  

  def <=>(other)
    if other.is_a?(FileHashTree)
      other.file_hash != @file_hash ? @master <=> other.master : True
    end
  end

  def to_s
    @master.to_s
  end
end

class FileHash
  attr_accessor :left, :right, :hash, :line
  def initialize(*args)
    if args
      if args.length == 2
        @left = args[0].is_a?(String) ? FileHash.new(args[0]) : args[0]
        @right = args[1].is_a?(String) ? FileHash.new(args[1]) : args[1]
      elsif args.length == 1 and args[0].is_a? String
        @line = args[0]
      end
    end
  end
     
  def build
    h = Digest::SHA1.new
    if !@right and !@left
      @hash = h << @line
    else
      if @left.hash
        h << @left.build()
      end
      if @right.hash
        h << @right.build()
      end
      @hash = h
    end
  end

  def leaves(l=[])
    if !@right and !@left
      l << self
    else
      if @right then l << @right.leaves end
      if @left then l << @left.leaves end
    end
    return l
  end
    

  def to_s
    str = ""
    if @right then str << @right.to_s end
    if @left then str << @left.to_s end
    if @line then str << @line end
    return str
  end
      
  def <=>(other)
    @hash <=> other.hash if other.is_a? FileHash
  end
end

