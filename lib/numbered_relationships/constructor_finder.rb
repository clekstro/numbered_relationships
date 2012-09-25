require_relative 'has_many'
require_relative 'has_many_through'
require_relative 'has_and_belongs_to_many'

module NumberedRelationships
	module ConstructorFinder
    def self.find(options)
      reflection = options[:reflection]
      thru = reflection.options[:through] if reflection
      case reflection.macro
      when :has_and_belongs_to_many
        HasAndBelongsToManyConstructor.new(options)
      when :has_many
        return HasManyConstructor.new(options) unless thru
        HasManyThroughConstructor.new(options)
      end
    end
	end
end