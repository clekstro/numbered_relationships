require_relative 'constructor'

module NumberedRelationships
  class HasManyThroughConstructor < Constructor
    def construct
      super
      @klass.joins(through_model, association)
          .group("#{table}.id")
          .having("count(#{association.to_s}.id) #{@operator} #{@n}")
    end
  end
end