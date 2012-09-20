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
		self.joins(:jokes).group("jokes.id HAVING count(joker_id) >= n")
	end
end
```
But what if we want to filter a jester's jokes as well?  ActiveSupport defines concerns to make module inclusion really simple:
```ruby
module Humor
	extend ActiveSupport::Concern
	included do
		has_many :jokes
		def with_at_least_n_jokes(n)
			self.joins(:jokes).group("jokes.id HAVING count(joker_id) >= n")
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

This gem provides relief. Instead of defining modules with hard-coded method names and queries, it uses ActiveRecord's reflection capabilities to enable amount-based filtering on all models and their associations:
```ruby
# Class-based filters
Joker.with_at_least(2, :music_instruments)
Joker.with_at_least(200, :jokes)
```

```ruby
# Instance-based association filters
@first_joker = Joker.find(1)
@first_joker.jokes.with_at_least(10, :tomatoes)
```
These also call scoped() on all queries and return an instance of ActiveRecord::Relation, meaning that these methods are chainable:
```ruby
@first_joker.performances.with_at_least(10, :dramatic_moments).where(:duration > 10)
```
## Installation

Add this line to your application's Gemfile:

    gem 'numbered_relationships'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install numbered_relationships

## Usage
This gem extends ActiveRecord, meaning the installation immediately offers the following methods:

```ruby
Joker.with_at_least(1, :joke)
Joker.with_at_most(2, :jokes)
Joker.with_exactly(2, :jokes)
Joker.without(2, :jokes)
Joker.with_more_than(2, :jokes)
Joker.with_less_than(2, :jokes)

j = Joker.find(123)
j.jokes.with_at_least(1, :laugh)
j.jokes.with_at_most(2, :laughs)
j.jokes.with_exactly(2, :laughs)
j.jokes.without(11, :laughs)
j.jokes.with_more_than(18, :laughs)
j.jokes.with_less_than(2, :laughs)
```
It's also possible to use class methods or scopes defined on the association class:
```ruby
Joker.with_at_least(1, [:dirty], :joke)

```
As long as the class method or scope :dirty is defined on Joker:
```ruby
class Joke
  def self.dirty
  	where(funny: true)
  end
end
```
this code will properly filter the results before attempting to group them.  It outputs the following SQL:
```sql
SELECT jesters.* FROM jesters 
INNER JOIN jokes ON jokes.jester_id = jesters.id 
WHERE jokes.funny = 't' 
GROUP BY jesters.id 
HAVING count(jokes.id) >= 1
```
These methods, like all other class methods, are chainable, meaning the following would also work:
```ruby
Joker.with_at_least(1, [:dirty, :insulting, :crying_on_the_floor], :joke)
```

A call to a non-existent association will -- at least for the moment -- simply return:
```ruby
[]
```

## TODO:
1. Improve exception handling.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/clekstro/numbered_relationships)![Travis CI Status](https://secure.travis-ci.org/clekstro/numbered_relationships.png)
