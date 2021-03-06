JSON Rails Templates
====================

This gem allows you to write simple Rails views for JSON output.

When you want JSON output, you normally just define ``as_json`` on each
model, and ``respond_with`` the object. But sometimes you want the same
model to display differently from different controllers. In that case,
you have a few options:

1. Don't use the default ``respond_to``.

   You'd use specialized ``as_json`` methods, and have each controller
   call the appropriate specialized method. We went through this, and it
   did not work so well. We ended up with a lot of different ``as_json``
   methods. It felt like we were doing too much work in the models that
   did not feel like it belonged there.

2. Use a presenter class.

   We tried this as well, and it felt too heavy-handed. We ended up with
   lots of classes that didn't seem to be doing much.

   We're considering trying a variant of this called [DCI][http://en.wikipedia.org/wiki/Data,_Context,_and_Interaction]
   (Data, Context, and Interaction). The idea is that the model contains
   only data, and when we need some behavior from the object, we inject a
   module into the object with the behavior only for that specific
   context. So each view would be considered a different context, with an
   ``as_json`` appropriate for that context.

3. Use a JSON view file.

   This seems the simplest, and fits in pretty well with the way Rails
   works, especially with HTML. It takes the (Rails-ish) perspective that
   we're just looking at different views of the same model object, and
   keeps these different views out of the model.

   We tried this with plain ERB, but it didn't work out too well -- we
   had to jump through some hoops to output raw text.


## Example ##

This template:

    string_literal: 'this is a string'
    string_expression: 'this is a string'.gsub('string', 'String!')
    integer_literal: 123
    integer_expression: 1 + 2
    float_literal: 1.234
    float_expression: Math::PI * 2
    boolean_literal: true
    boolean_expression: 'Craig' == 'Buchek'
    null_literal: nil
    array_literal: ['string', 123, 1.234, false]
    array_expression: Array.new(3, 'hello')
    hash_literal: {a: 1, b: '2', 'c' => 3}
    nested_contexts:
      child:
        grandchild: 1

will render JSON equivalent to (ignoring whitespace differences):

    {
      "string_literal": "this is a string",
      "string_expression": "this is a String!",
      "integer_literal": 123,
      "integer_expression": 3,
      "float_literal": 1.234,
      "float_expression": 6.283185307179586,
      "boolean_literal": true,
      "boolean_expression": false,
      "null_literal": null,
      "array_literal": ["string", 123, 1.234, false],
      "array_expression": ["hello", "hello", "hello"],
      "hash_literal": { "a": 1, "b": "2", "c": 3 }
      "nested_contexts": {
        "child": {
          "grandchild": 1
        }
      },
    }


## Notes ##

* Nesting levels are indicated by 2 spaces. Indenting with non-space whitespace characters or an odd number of spaces will raise an exception.


## TODO ##

1. Iterating over an array of objects, specifying how to render each.
1. Compile templates instead of using `eval`.
1. Integrate with tilt.

Implement these translations:

1. hash expression
1. object
1. array of objects
1. partial
1. partial with an object
1. partial with a collection

Consider these ideas:

1. Allow a toggle to omit nil/null from being included in output.
    - Could use a sigil when you really do want to include a nil/null: ``VisibleNull(nil)``
1. Allow (or require) commas at end of each line.
1. Use ``as_json`` where available for objects when there is no partial.
1. Translate dates/times to strings automatically.
1. Generate an error when encountering a date/time expression.
1. Generate an error when encountering an object with no partial or ``as_json``.
    - May try ``to_json`` or ``to_hash`` as well.
1. Require or allow {} or [] around the top-level content.
1. Allow specifying a context, so we can just do ``attribute`` on the right side everywhere instead of ``resource.attribute``.
    - Probably use a syntax like ``=object_or_hash``.
1. Override ``render()`` to return hashes and arrays instead of a string.


## Credits ##

JSON Rails Templates was originally written by Craig Buchek.

Ideas were contributed by Amos King.

The impetus for creating this gem came from experience working on a
project along with Matt Simpson, Helena Wotring, and Nick Bimpasis.


## Copyright ##

Copyright © 2011 by BoochTek, LLC.
Copyright © 2012 by Asynchrony Solutions, LLC.

Released under the MIT license.
