# docspec

[![Build Status](https://travis-ci.com/skippi/docspec.svg?branch=master)](https://travis-ci.com/skippi/docspec)
[![Read the Docs (version)](https://img.shields.io/readthedocs/pip/stable.svg)](https://skippi.github.io/docspec/)

A crystal library for automatically testing documentation examples.

Docspec is crystal's equivalent of a doctest library.

## Use Cases

* Docspec encourages documentation by creating tests from it.
* Docspec encourages testing by reducing boilerplate code for test cases.
* Docspec encourages fast development by reducing boilerplate code for test
  cases.

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  docspec:
    github: skippi/docspec
```

## Usage

Docspec parses source files for any commented codeblocks with code in them. For
each codeblock line with a prefix of `>>`, it executes the line and stores the
result. If the line also had an expression appended with `# =>`, then docspec
will test that the result equals the appended expression.

In this example, we will fully doctest `Foo.bar`, while ignoring doctesting for
`Foo.add`. Note the usage of `>>`:

```crystal
# src/foo.cr

module Foo
  # Returns "hello world".
  #
  # ```
  # >> Foo.bar # => "hello world"
  #
  # >> name = "say #{Foo.bar}"
  # >> name # => "say hello world"
  # ```
  def self.bar
    "hello world"
  end

  # Adds two numbers.
  #
  # ```
  # Foo.add(1, 3) # => 4
  # Foo.add(-2, -4) # => -6
  # ```
  def self.add(a, b)
    a + b
  end
end
```

Require docspec and doctest the source file using a relative path:

```crystal
# spec/foo_spec.cr

require "docspec"

Docspec.doctest("../src/foo.cr")
```

Lastly, run your tests in your project's root directory.

```bash
crystal spec
```

## Documentation

* [Official docs](https://skippi.github.io/docspec/)

## Contributing

1. Fork it ( [https://github.com/skippi/docspec/fork](https://github.com/skippi/docspec/fork) )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

* [skippi](https://github.com/skippi)  - creator, maintainer
