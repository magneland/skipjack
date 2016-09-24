# Skipjack

This creates a "tracer bullet" branch that speeds through a Continuous Integration system by skipping all tests. It only works for Ruby projects, and only for [minitest](https://github.com/seattlerb/minitest) tests. There's probably even more disclaimers needed, but you get the point.

It skips tests by rewriting:

    def test_some_useful_thing

as:

    def test_some_useful_thing; skip(your_custom_message)

## Usage

    ./skipjack.rb <project_base_path> <your_custom_message>
    cd <project_base_path>
    find . -name "*_test.rb" -exec git add {} \; # or something like that
