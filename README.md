# FooMangler

A simple gem that is supposed to help me convert between different tabular formats (primarily CSV).

It reads some tabular format from somewhere mangles it (thus the name) according to some user-defined rules, and writes the result in some tabular format to somewhere.

Since this kind of stuff comes up annoyingly often, the primary design goals are:

* Extensibility
  * Different import sources and export targets
    * Currently local files only
  * Different import formats and export formats
    * Currently CSV only
  * Pluggable transformations
    * Simple, convenient representation
      * Rows are represented as Hashes
    * Multiple transformations can be added
* Configurability via a DSL

## TODO

* Add specs, since the current code was just hacked together
* Clean up
  * Current DSL
* Add
  * Runner and proper executable
  * OptionParsing
