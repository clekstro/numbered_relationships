# NumberedRelationships

This gem implements basic filtering of ActiveRecord models on the class and instance level based
on the amount of relationships belonging to the object or its associations.

## Benefits/ Raison d'Etre
Defining a scope or model method that implements such basic having/count functionality on an
ActiveRecord model is trivial:

```ruby
class Joker << ActiveRecord::Base
	has_many :jokes

	def self.with_at_least_n_jokes(n)
		self.joins(:jokes).group("jokes.id HAVING count(joker_id) > n")
	end
end
```
To avoid reptition, we can define an ActiveSupport::Concern and include it in whatever models we'd like:
```ruby
module Humor
	extend ActiveSupport::Concern
	included do
		has_many :jokes
		def with_at_least_n_jokes(n)
			self.joins(:jokes).group("jokes.id HAVING count(joker_id) > n")
		end
	end
end

class Joker < ActiveRecord::Base
	include Humor
end
```
Great! We can find the really humurous
```ruby
Joker.with_at_least_n_jokes(200)
```
But the following might break, as the hard-coded foreign key "joker_id" might not exist in the 
jesters table.
```ruby
class Jester < ActiveRecord::Base
	include Humor
end
```
The problem is quite clear: the scopes define queries using specific implementation details,
making reuse nearly impossible.

But there's also a larger issue here: jokes are only one possible association.  If we want the
Jester model to include, say, music_instruments -- and to be able to filter on their amount --
we're back at square one, writing another module for each association.

This gem provides relief. Instead of defining modules with hard-coded method names and queries, it uses the ActiveRecord's reflection capabilities to enable amount-based filtering on all modelsk
every 
```ruby
Joker.with_at_least(2, :music_instruments)
Joker.with_at_least(200, :jokes)
```

## In the works
While not fully implemented, the first stable release will allow filtering on associations:
```ruby
@first_joker = Joker.find(1)
@first_joker.jokes.with_at_least(10, :tomatoes)
```

## Installation

Add this line to your application's Gemfile:

    gem 'numbered_relationships'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install numbered_relationships

## Usage
To gain access to class methods, include the module in your model as shown below:

```ruby
class Joker << ActiveRecord::Base
	include NumberedRelationships::AmountBased
	has_many :jokes
end
```

The Joker class would then have access to the following class methods:
```ruby
Joker.with_at_least(2, :jokes)
Joker.with_at_most(2, :jokes)
Joker.with_exactly(2, :jokes)
Joker.without(2, :jokes)
Joker.with_more_than(2, :jokes)
Joker.with_less_than(2, :jokes)
```

The gem analyzes the relationship between models through reflection, meaning it should generate the correct SQL regardless of the type of ActiveRecord relationship.  The following relationship macros (in ActiveRecord speak) are currently supported:
- :has_many
- :has_many, :through
- :has_and_belongs_to_many

As filtering isn't merely limited to the class or scope level, filtering on instances of ActiveRecord::Relation is also supported, as long as the module has been registered.


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
