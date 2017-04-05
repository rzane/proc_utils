# ProcUtils

A set of functional utilities for working with callables in Ruby.

Heavily inspired by [lodash](https://lodash.com/docs).

## Introduction

I love Symbol#to_proc. It just feels good.

```ruby
emails.each(&:deliver)
```

However, if your method takes an argument, you need to refactor to use a block.

```
emails.each { |email| email.deliver(:hello) }
```

What if you could do this?

```
emails.each(&:deliver.partial(:hello))
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'proc_utils'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install proc_utils

## Extending Procs

Because this is a core extension, you have to opt-in.

```
require 'proc_utils/core_ext/proc'
```

Now, procs will have the following methods:

* partial
* partial_right
* bind
* flip
* wrap
* compose
* memoize
* once

## Extending Symbols

```
require 'proc_utils/core_ext/symbol'
```

Now, symbols will have the following methods:

* partial
* partial_right
* bind
* memoize
* once

## Using without CoreExtensions

I get it, core extensions are scary. Lucky for you, ProcUtils offers pure functions.

For example:

```
func = proc { |name| puts name }
func = ProcUtils.bind(func, 'Rick Flair')
func.call
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/rzane/proc_utils.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
