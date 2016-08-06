class Dojo

	attr_reader :a,:b,:c

	def initialize
		@a
		@b
		@c
	end


	def discount(price,func)
		func.call(price)
	end

	def stats
		{:raw => [50,50],:groups=>[5,5]}
	end

	def hire
		attr_accessor :team
	end

	def to_current_instance(foo)

	end


	def extend_number!

		instance_eval(@a)
		put @a

	end


end

# Dojo.instance_eval {@num}
  #defs here go to A's eigenclass

module Foo
  def growth
    puts "growth"
  end
end

a = Dojo.new

