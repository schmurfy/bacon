# Bacon

This is my personal fork of the [bacon test](https://github.com/chneukirchen/bacon) framework tailored to my needs, here is
a non exhaustive list of changes worth mentioning:

- added a new default nicer output formatter, I look at tests most of my work days
  and got tired of the old standard look.
- added some optional extensions:
  - mocha integration: allow using mocha expectations
  - eventmachine integration: make your tests run inside the eventmachine loop

# Using it

In your project add this to your Gemfile:

```ruby
gem "schmurfy-bacon"
```

And then the simplest test would be:  
(you might want to split the common part to a spec_helper.rb file and requires it in your tests)

```ruby
require "rubygems"
require "bundler/setup"
require "bacon"

# Without that nothing will be shown after the tests
Bacon.summary_on_exit()

# Using mocha
# require "bacon/ext/mocha"

# Using eventmachine
# require "bacon/ext/em"

describe "My test" do
  before do
    @v = 42
  end
  
  should "run" do
    @v.should == 42
  end
end

```

Check the examples directory for more.



# Screenshot

![](https://github.com/schmurfy/bacon/raw/master/screenshot.png)

