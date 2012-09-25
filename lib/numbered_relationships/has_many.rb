require_relative 'constructor'

module NumberedRelationships
  class HasManyConstructor < Constructor
    def construct
      super
      return construct_has_many_filtered unless @filters.empty?
      construct_has_many_unfiltered
    end
    def construct_has_many_unfiltered
      @klass.joins(association)
            .group("#{table}.id")
            .having("count(#{association.to_s}.id) #{@operator} #{@n}")
    end

    def construct_has_many_filtered
      @klass.joins(association)
            .merge(eval("#{constantize_klass}.#{chain_symbols(@filters)}"))
            .group("#{table}.id")
            .having("count(#{association.to_s}.id) #{@operator} #{@n}")
    end
  end
end
