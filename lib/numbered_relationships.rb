require_relative 'numbered_relationships/constructor_finder'

module NumberedRelationships
  module AmountFilters
    extend ActiveSupport::Concern

    def with_at_least(n, filters=[], assoc)
      find_related_objects(n, assoc, '>=', filters, self)
    end

    def with_at_most(n, filters=[], assoc)
      find_related_objects(n, assoc, '<=', filters, self)
    end

    def with_exactly(n, filters=[], assoc)
      find_related_objects(n, assoc, '=', filters, self)
    end

    def without(n, filters=[], assoc)
      find_related_objects(n, assoc, '<>', filters, self)
    end

    def with_more_than(n, filters=[], assoc)
      find_related_objects(n, assoc, '>', filters, self)
    end

    def with_less_than(n, filters=[], assoc)
      find_related_objects(n, assoc, '<', filters, self)
    end

    def find_related_objects(n, assoc, operator, filters, klass)
      reflection = self.reflect_on_association(assoc) || self.reflect_on_association(assoc.to_s.tableize.to_sym)
      return self.scoped unless reflection

      ConstructorFinder::find({
        n: n,
        operator: operator,
        filters: filters,
        klass: klass, 
        reflection: reflection
      }).construct
    end
  end
end

ActiveRecord::Base.send :extend, NumberedRelationships::AmountFilters
