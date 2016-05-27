# ActiveRecord::MigrationNotes

ActiveRecord Migration Notes hooks into the Rails migrations and monitors if the migrations contain a note methods that should be shown afterwards.

## Why?

Have you ever been in a situation where you have to deploy some code and forgot what special things you had to execute manually after a migration?

Searching for this answer within pull requests, issues, code comments, tickets, emails, faxes made me think this should be easier.

Why not give the developer who creates the migration, an easy way to add some additional notes to the migration?

![image](https://i.imgur.com/P2H99Fy.png)

## Installation

Add this line to your Rails application's Gemfile:

```ruby
gem 'activerecord-migration_notes'
```

And then execute:

    $ bundle

## Usage

You can now add two new methods within your migration called `up_notes` (trigged on `rake db:migrate`) and `down_notes` (triggered on `rake db:rollback`).

Both these methods are optional and you do not have to specify them both.

### Example

```ruby
class AddSomeBreakingChanges < ActiveRecord::Migration
  def change
    # your normal migration task
  end

  def up_notes
    <<-NOTES
      Please run the following manually to not break the DB!

      $ rake some_task
    NOTES
  end

  def down_notes
    "All is well no additional notes"
  end
end
```

## TODO

* test if we covered all other cases like `db:down` and `db:up`
* ... more?
* probably add some docs

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
