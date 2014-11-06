# [Emerson](http://en.wikipedia.org/wiki/Ralph_Waldo_Emerson)

transcendent views. **(WIP)**

## Installation

Add this line to your application's Gemfile:

    gem 'emerson'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install emerson

## An Overview of Emerson -- In Practice, with a bit of the Philosophy

### NOTES

* This document is an early working draft... please do add notes/comments/questions.
* Emerson is, first and foremost, a demonstration of a philosophy.  I do not necessarily push people to use the framework or any of its components (though I am thrilled that so many do use the JavaScript already).  Rather, embracing the sort of conventions that Emerson demonstrates, leading to code that "tells cohesive story", is the real point. #SharedUnderstanding, #Mindfulness, #Empathy ... lead to a more easily designed & developed product.
* Emerson is a work-in-progress that has been developed over the course of a decade or so.  There is much more on the way, but I am now ready to begin sharing it with the world.

### (Some of the many) TODOs

* Split this content into the following separate docs, on Github:
    * Emerson (theory/philosophy)
    * Emerson Javascript (concrete library docs)
    * Emerson Ruby (concrete library docs)

### Some Explanation via Recent Dialog

1) *"What exactly does it do?"*

*Emerson... the big picture (a bit of the theory/philosophy):*

* Provides conventions leading to team-wide shared understanding by way of:
    * File system and code structure[^1].
    * Naming suggestions/hints.
    * Clean separation of concerns, with appropriate/beneficial (and soft) constraints, leading to clear presentation-tier architecture[^1] and well-factored code.
    * Patterns that encourage the code to “tell a story”... what part it plays in the overall domain model of the system[^2], how it is related to associated code, hints at when to refactor it.
* Extends/Promotes the notion of “View” beyond the server--side templates, to be inclusive of:
    * Server-side rendering logic (e.g., HTML vs. JSON vs. ...)
    * DRY/re-used server-side templates
    * Behavior (JS)
    * Presentation (CSS, images, other assets)
* Architecturally, Emerson is designed to be modular and unobtrusive. e.g., you can always write straight-up jQuery or Rails.

*Emerson... the JS library:*

[emerson-js](https://github.com/coreyti/emerson-js) is a lightweight framework designed to introduce web presentation-tier conventions with the aim of supporting shared understanding and team cohesion. It acts as a thin abstraction layer on top of jQuery (or in theory, Ender or Zepto), providing code patterns which are designed to:

* Avoid “jQuery spaghetti”.
* Tell a “story”, in the language of the “product”.

Concretely, Emerson makes use of conventions to ease things such as:

* Decorating the DOM with jQuery + “view behavior”.
* Organizing view behavior into modules via “traits”.
* Unified AJAX request and response handling.
* Seamless updates/replacements of content via “sinks” (as in [“heat sink](http://en.wikipedia.org/wiki/Heat_sink)... draws content to it).
* Coding style.

*Additionally:*

* Works well with Rails UJS.
* ...

*Emerson... the Ruby library:*

`emerson`, the Ruby gem, is a Rails engine for providing:

* `emerson-js` assets for the Rails asset pipeline
* A Responder and other components to assist in rendering responses in the Emerson fashion (**NOTE:** this is in the “pre-release” version of the gem)

2) *"What problems is it intended to solve? What was the motivation for creating it?"*

The approaches taken by Emerson are well-suited for web applications of the “progressive enhancement” variety.

That is, for those applications which do not necessarily benefit from moving to a full-blown client-side MVC framework, Emerson (or the like) fits nicely.
￼￼
In this way Emerson serves a space much like that intended by:

  * [ElementalJS](http://pivotallabs.com/introducing-elementaljs/), built by [Pivotal Labs](http://pivotallabs.com/), where I was a consultant for 5 years and developed much of what has become Emerson to date -- Emerson's grand-parent introduced the "data-presents" and "data behaviors" to folks at Pivotal -- *I'm absolutely thrilled that they've taken it on and built Elemental, earnestly and sincerely*.
  * [React.js](http://facebook.github.io/react/) (“Lots of people use React as the V in MVC” -- from the linked website), while doing much more (in my opinion) to encourage well-factored, maintainable code.

Emerson, as it exists today, expects that the same templates are used for handling of server-side rendered requests (Rails HTML format), as for client-side updates (Rails JSON format). The Model and Controller (etc.) aspects of the application are handled entirely on the server, and `emerson-js` decorates the DOM with desired behavior. In this way we avoid duplication of, for example, Model concepts between server & client and rendering concepts between request/response formats.

Potential benefits:

* SEO, I18n, accessibility concerns are handled server-side (where capabilities are much more evolved/advanced), thereby fully supporting non-JS clients such as many search engine crawlers and screen readers.
* ...

3) *"Why would I choose to use this over something like [Ember](http://emberjs.com/), [Angular](https://angularjs.org/#/), or [other JS frameworks](http://todomvc.com/)"*

Many web applications benefit little from moving to, and accepting the overhead of, a full-blown client-side MVC (or similar) framework. For many applications, the “progressive enhancement” approach is more appropriate. That is a space for Emerson.

4) *"What's your plan for it going forward? Is it going to continue to grow it and maintain it?"*

I’ve been looking forward to advancing Emerson. Now that it’s gaining more attention, I’m excited to take that on in coming months and continuing to use & maintain it ongoing.

Note too that there are a number of capabilities found in earlier implementations of what has become Emerson that I have not yet ported over.

I’ve been sticking to a “pull” model, in which I do not add new functionality until I (or another user) feels a need. An example is [one-way](http://serenadejs.org/binding_data.html) [data](http://rivetsjs.com/) [binding](http://emberjs.com/guides/object-model/bindings/).

5) *"Would you recommend that we keep using it?"*
￼
Unless there is a real need for client-side MVC, I’d suggest sticking with Emerson. From what I know of [the project], Emerson will provide the functionality necessary in the most lightweight and clear fashion.

### Auxiliary Points

Generally (in current-day practice), we are working within the notion of "View" when attaching (unobtrusive enhancement) behavior. However, there is nothing enforcing this or disallowing us from changing the implementation.

Emerson has attempts to push/force nothing; only to encourage a "pull-model".  When people ask, "how would I write this in `emerson-js`?", my answer is always, "how would you write it in jQuery?".

---

## Code examples (VERY WIP):

1. A Github GIST from [Rachel Heaton](https://github.com/rheaton) on getting Emerson running: https://gist.github.com/rheaton/3062378
2. A made up example for a product:

        # overview/discussion...
        # ------------------------------------------------------------
        We want to implement a recipe editor in the “in-place editor”
        fashion: 

        Upon clicking editable content, that content is replaced by a
        form. 

        Additionally, we’ve decided that recipes, (perhaps) distinct
        from other in-place-editable content, should become
        highlighted upon rollover, to indicate editability.

        For the sake of keeping the conversation simple, we will use
        Rails conventions in these examples. Note, however, that the
        philosophy and techniques herein are not specific to Rails.

        Further, many of the specifics detailed below should be
        considered suggestions, but are not requirements for Emerson.

        For example, where I prefer to author “data-view” attributes with values that mimic the filesystem organization, thereby augmenting the “story telling” aspect of the code, many others find that awkward -- “data-view=’recipe-page’” works just fine -- it is not the particular conventions that matter; only that there are conventions.
        ￼
        # filesystem...
        # ------------------------------------------------------------
        app/
          assets/
            javascripts/
              views/
                recipes/
                  edit.js
                  show.js
              stylesheets/
                views/
                  recipes/
                    edit.css.scss
                    show.css.scss
          views/
            recipes/
              edit.html.erb
              show.html.erb

        # controllers...
        # ------------------------------------------------------------
        #   - app/controllers/recipes_controller.rb
        #   - app/controllers/recipes/steps_controller.rb

        TODO: Demonstrate Responder, Scope, etc. usage.

        # template...
        #   - app/views/recipies/show.html.erb
        # ------------------------------------------------------------
        <article data-view=”recipes/show” data-traits=”inplace-editor”>
          <header>
            <h1><%= recipe.title %></h1>
          </header>

          <section class=”ingredients”>
            <ul data-outlet=”inplace-list”
                data-path=”<%= edit_recipe_ingredients_path(recipe) %>”>
              <%- ingredients.each do |ingredient| %>
              <li><%= ingredient %></li>
              <%- end %>
            </ul>
          </section>

          <section class=”steps”>
            <ol data-outlet=”inplace-list”
                data-path=”<%= edit_recipe_steps_path(recipe) %>”>
              <%- steps.each do |step| %>
              <li><%= step %></li>
              <%- end %>
            </ol>
          </section>
        </article>

        # response as HTML...
        #  - GET /recipes/show format: HTML
        #  - NOTE:renders with layout
        # ------------------------------------------------------------
        <html>
          <body>
            <main role=”main”> <!-- or whatever layout DOM is desired -->
              <article data-view=”recipes/show” data-traits=”inplace-editor”>
                <header>
                  <h1>Spaghetti</h1>
                </header>

                <section class=”ingredients”>
                  <ul data-outlet=”inplace-list”
                      data-path=”/recipes/123/ingredients/edit”>
                    <li>1 lb Pasta</li>
                  </ul>
                </section>

                <section class=”steps”>
                  <ol data-outlet=”inplace-list”
                      data-path=”/recipes/123/steps/edit”>
                    <li>Boil water</li>
                  </ol>
                </section>
              </article>
            </main>
          </body>
        </html>

        # response as JSON (simplified)...
        #  - GET /recipes/show format: JSON
        #  - NOTE:renders same ERB template as with HTML requests,
        #    sans the layout.
        # ------------------------------------------------------------
        {
          data : { ... },
          view : “<article data-view=’recipes/edit’ ...>...</article>”
        }

        # Behavior: An example jQuery implementation
        # ------------------------------------------------------------
        (function($) {
          // A basic jQuery extension to add “in-place editing”.
          $.fn.extend(‘inplaceEdit’, function() {
            this.each(function() {
              var show = $(this);
              var path = show.data(‘path’);

              $.get(path, function(data, status, xhr) {
                var edit = $(data.view);
                show.replaceWith(edit);
              });
            });
          
            return this;
          });

          // On document.ready, attach view/trait behavior to rendered
          // DOM.
          $(function() {
            $(‘article[data-view=”recipes/edit”]’).each(function() {
              $(this).showIcon(); // ???
            });

            $(‘article[data-view=”recipes/edit”]’)
              .on(‘mouseenter’, ‘[data-outlet^=”inplace”]’, function(e) {
                $(e.target).trigger(‘inplace:hover’);
              })
              .on(‘inplace:hover’, function(e) {
                $(e.target).highlight();
              })
              .on(‘inplace:click’, function(e) {
                $(e.target).inplaceEdit();
              });
            });
        })(jQuery);

        # Behavior: A naïve Emerson implementation
        # ------------------------------------------------------------
        (function($, define) {
          var view = define('recipes/show', {
            initialize : function() {
              this.showIcon(); // ???
            },

            subscribe : {
              '[data-outlet^=”inplace”]' : {
                ‘mouseenter’ : function() {
                  // $(e.target, this).trigger(‘inplace:hover’);
                  this.outlet('inplace')
                    .trigger(‘inplace:hover’);
                }
              },

              ‘inplace:hover’ : function() {
                $(e.target).highlight();
              }
            }
          });
        })(Emerson.base, Emerson.view);

        # Behavior: Another Emerson implementation
        # ------------------------------------------------------------
        (function($, define) {
          // TODO
        })(Emerson.base, Emerson.view);

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Contributors

* [Corey Innis](http://github.com/coreyti) -- creator, author, spiritual guide, madman.
* [Rachel Heaton](https://github.com/rheaton) -- ever-patient user, supporter, evangelist, co-author and co-presenter, spirtually-benevolent hard-ass.
* [George Brocklehurst](https://github.com/georgebrock) -- editorial reviewer.
* [Pivotal Labs crew](http://pivotallabs.com/) -- Inspiration, support, patience. Also for bringing [ElementalJS](http://pivotallabs.com/introducing-elementaljs/) into the game.
* [JB Steadman](https://twitter.com/jbsteadman) -- Loving supporter and foundational inspiration for the HTML-thru-JSON component/option ... Amazing guy. If you haven't yet met, change that.
* [Scott Walker](https://github.com/swalke16) -- User, feedback provider; responsible for the dialog above.
* [James Martinez](#) -- support/excitement
* ...many more -- **TODO**

*most importantly...*

* You...?

[^1]: What code to write, where to put it, what to name it.
[^2]: We observe that domain-based modeling is generally done well for the server-side components of a web application, but the patterns and conventions are not promoted through the presentation tier and client-side.
