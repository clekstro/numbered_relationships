module NumberedRelationships
  module AmountFilters
    extend ActiveSupport::Concern

    def with_at_least(n, filters=[], assoc)
      find_related_objects(n, assoc, '>=', filters)
    end

    def with_at_most(n, filters=[], assoc)
      find_related_objects(n, assoc, '<=', filters)
    end

    def with_exactly(n, filters=[], assoc)
      find_related_objects(n, assoc, '=', filters)
    end

    def without(n, filters=[], assoc)
      find_related_objects(n, assoc, '<>', filters)
    end

    def with_more_than(n, filters=[], assoc)
      find_related_objects(n, assoc, '>', filters)
    end

    def with_less_than(n, filters=[], assoc)
      find_related_objects(n, assoc, '<', filters)
    end

    private

    def find_related_objects(n, assoc, operator, filters)
      reflection = self.reflect_on_association(assoc) || self.reflect_on_association(assoc.to_s.tableize.to_sym)
      return self.scoped unless reflection
      table = self.name.tableize
      query_related_objects(reflection, n, operator, table, filters).scoped
    end

    def query_related_objects(reflection, n, operator, table, filters)
      case reflection.macro
      when :has_and_belongs_to_many
        construct_and_execute_habtm_query(reflection, n, operator, table, filters)
      when :has_many
      	if reflection.options[:through] 
        	construct_and_execute_has_many_through_query(reflection, n, operator, table, filters)
        else
        	construct_and_execute_has_many_query(reflection, n, operator, table, filters)
        end
      end
    end

    def construct_and_execute_habtm_query(reflection, n, operator, table, filters)
      foreign_key = reflection.foreign_key
      association = reflection.name
      join_table = self.reflect_on_association(association.to_sym).options[:join_table]
      if join_table
      	self.joins(association)
      			.group("#{table}.id")
      			.having("count(#{join_table}.#{foreign_key}) #{operator} #{n}")
      else
      	self.joins(association)
      			.group("#{table}.id")
      			.having("count(#{foreign_key}) #{operator} #{n}")
      end
    end

    def construct_and_execute_has_many_through_query(reflection, n, operator, table, filters)
      foreign_key = reflection.foreign_key
      association = reflection.name
      through_model = reflection.options[:through]
      self.joins(through_model, association)
      		.group("#{table}.id")
      		.having("count(#{association.to_s}.id) #{operator} #{n}")
    end

    def construct_and_execute_has_many_query(reflection, n, operator, table, filters)
      foreign_key = reflection.foreign_key
      association = reflection.name
      if filters.empty?
        self.joins(association)
        		.group("#{table}.id")
        		.having("count(#{association.to_s}.id) #{operator} #{n}")
      else
        # figure out way to translate [:funny, :experienced] to instance.funny.experienced
        # inject(self) {|o, a| o.send(a) }
        klass = association.to_s.classify.constantize
        self.joins(association)
        		.merge(eval("#{klass}.#{chain_symbols(filters)}"))
        		.group("#{table}.id")
        		.having("count(#{association.to_s}.id) #{operator} #{n}")
      end
    end
    
    def chain_symbols(symbols)
    	symbols.map{ |s| s.to_s }.join('.')
    end
  end
end

ActiveRecord::Base.send :extend, NumberedRelationships::AmountFilters
