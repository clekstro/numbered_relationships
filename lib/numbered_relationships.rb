module NumberedRelationships
  module AmountFilters
  	extend ActiveSupport::Concern
  	included do
  	end
  		
		module ClassMethods  	
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
	      called_on_klass = self.instance_of?(Class)
	      reflection = determine_reflection(called_on_klass, assoc)
	      return [] if reflection.nil?
	      table = determine_table(called_on_klass, reflection)
	      #puts table
	      query_related_objects(reflection, n, operator, table).scoped
	    end

	    def determine_reflection(called_on_klass, assoc)
	      return self.reflect_on_association(assoc) if called_on_klass
	      klass = self.proxy_association.klass
	      klass.reflect_on_association(assoc)
	    end
	    def determine_table(called_on_klass, reflection)
	      macro = reflection.macro
	      case macro
	      when :has_and_belongs_to_many
	        determine_habtm_table(called_on_klass, reflection)
	      when :has_many
	        determine_has_many_table(called_on_klass, reflection)
	      end
	    end

	    def determine_habtm_table(called_on_klass, reflection)
	      return self.name.tableize if called_on_klass
	      reflection.options[:join_table]
	    end

	    def determine_has_many_table(called_on_klass, reflection)
	      # distinguish between has_many and has_many :through
	      return self.name.tableize if called_on_klass
	      reflection.options[:join_table]
	    end

	    def query_related_objects(reflection, n, operator, table)
	      macro = reflection.macro
	      #puts "Macro is: " + macro.to_s
	      case macro
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
	      self.joins(association).group("#{table}.id HAVING count(#{foreign_key}) #{operator} #{n}")
	    end
	    #Artist.joins(:artist_portfolio, :artworks).group("artists.id HAVING count(artworks.id) > 2")
	    def construct_and_execute_has_many_through_query(reflection, n, operator, table)
	      foreign_key = reflection.foreign_key
	      association = reflection.name
	      through_model = reflection.options[:through]
	      self.joins(through_model, association)
	      .group("#{table}.id HAVING count(#{association.to_s}.id) #{operator} #{n}")
	    end
	    def construct_and_execute_has_many_query(reflection, n, operator, table)
	      foreign_key = reflection.foreign_key
	      association = reflection.name
	      self.joins(association).group("#{table}.id HAVING count(#{association.to_s}.id) #{operator} #{n}")
	    end
	  end
  end

  # def self.included(receiver)
  #   receiver.extend         ClassMethods
  #   receiver.send :include, InstanceMethods
  # end
end

ActiveRecord::Base.send :include, NumberedRelationships::AmountFilters
