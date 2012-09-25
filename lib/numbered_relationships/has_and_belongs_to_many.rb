require_relative 'constructor'

module NumberedRelationships
	class HasAndBelongsToManyConstructor < Constructor
		def construct
      super
      return construct_habtm_with_join_table if join_table
      construct_habtm_without_join_table
    end

    def construct_habtm_with_join_table
      @klass.joins(association)
            .group("#{table}.id")
            .having("count(#{join_table}.#{foreign_key}) #{@operator} #{@n}")
    end

    def construct_habtm_without_join_table
      @klass.joins(association)
            .group("#{table}.id")
            .having("count(#{foreign_key}) #{@operator} #{@n}")
    end
	end
end