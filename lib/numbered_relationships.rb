module NumberedRelationships
  module AmountFilters
    extend ActiveSupport::Concern

    def with_at_least(n, assoc)
      find_related_objects(n, assoc, '>=')
    end

    def with_at_most(n, assoc)
      find_related_objects(n, assoc, '<=')
    end

    def with_exactly(n, assoc)
      find_related_objects(n, assoc, '=')
    end

    def without(n, assoc)
      find_related_objects(n, assoc, '<>')
    end

    def with_more_than(n, assoc)
      find_related_objects(n, assoc, '>')
    end

    def with_less_than(n, assoc)
      find_related_objects(n, assoc, '<')
    end

    private

    def find_related_objects(n, assoc, operator)
      reflection = self.reflect_on_association(assoc) || self.reflect_on_association(assoc.to_s.tableize.to_sym)
      return [] unless reflection
      table = self.name.tableize
      query_related_objects(reflection, n, operator, table).scoped
    end

    def query_related_objects(reflection, n, operator, table)
      case reflection.macro
      when :has_and_belongs_to_many
        construct_and_execute_habtm_query(reflection, n, operator, table)
      when :has_many
        return construct_and_execute_has_many_through_query(reflection, n, operator, table) if reflection.options[:through]
        construct_and_execute_has_many_query(reflection, n, operator, table)
      end
    end

    def construct_and_execute_habtm_query(reflection, n, operator, table)
      foreign_key = reflection.foreign_key
      association = reflection.name
      join_table = self.reflect_on_association(association.to_sym).options[:join_table]
      return self.joins(association).group("#{table}.id HAVING count(#{join_table}.#{foreign_key}) #{operator} #{n}") if join_table
      self.joins(association).group("#{table}.id HAVING count(#{foreign_key}) #{operator} #{n}")
    end

    def construct_and_execute_has_many_through_query(reflection, n, operator, table)
      foreign_key = reflection.foreign_key
      association = reflection.name
      through_model = reflection.options[:through]
      self.joins(through_model, association).group("#{table}.id HAVING count(#{association.to_s}.id) #{operator} #{n}")
    end

    def construct_and_execute_has_many_query(reflection, n, operator, table)
      foreign_key = reflection.foreign_key
      association = reflection.name
      self.joins(association).group("#{table}.id HAVING count(#{association.to_s}.id) #{operator} #{n}")
    end
  end
end

ActiveRecord::Base.send :extend, NumberedRelationships::AmountFilters
