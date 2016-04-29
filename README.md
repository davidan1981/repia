# repia

[![Build Status](https://travis-ci.org/davidan1981/repia.svg?branch=master)](https://travis-ci.org/davidan1981/repia)
[![Coverage Status](https://coveralls.io/repos/github/davidan1981/repia/badge.svg?branch=master)](https://coveralls.io/github/davidan1981/repia?branch=master)
[![Code Climate](https://codeclimate.com/github/davidan1981/repia/badges/gpa.svg)](https://codeclimate.com/github/davidan1981/repia)
[![Gem Version](https://badge.fury.io/rb/repia.svg)](https://badge.fury.io/rb/repia)

Rails Essential Plug-in for API (or repia) is a Rails plugin that serves as
a collection of features that are useful for RESTful API development.

## Install

Add `gem 'repia'` to your project `Gemfile`.

## How to Use Repia

Edit `application_controller.rb` as the following:

    class ApplicationController < Repia::BaseController
    end

This will allow all controllers in the project to inherit from
`Repia::BaseController`, which gracefully handles all _code_ errors using
pre-defined HTTP errors. 

Next, update all models that need UUID as a primary identifier:

    class Something < ActiveRecord::Base
      include Repia::UUIDModel
    end

This will trigger UUID generation before a record object is created. Note
that migration must look similar to this:

    class CreateSomethings < ActiveRecord::Migration
      def change
        create_table :somethings, id: false do |t|
          t.string :uuid, primary_key: true, null: false
          t.string :name
          t.timestamps null: false
        end
      end
    end

## Middleware

When developing a JSON API, it is annoying to see non-JSON error responses
from a middleware. There are two prominent cases: `405 Method Not Allowed`
and `404 Not Found`. The former occurs when the request method is invalid
and the latter happens when the route does not match any controller or
action. Since these are caught within middleware, `rescue_from` does not
really help. So repia provides two useful components for this.

### Method Not Allowed

This class is a middleware that can be inserted (preferrably after
`ActionDispatch::RequestId`) to catch 405 errors. Instead of using a view
template, it will return a simple JSON response with a status of 405.

### Routing Error

Routing errors can be caught using `BaseController#exceptions_app`. To
configure it, add this to `config/application.rb`:

    config.exceptions_app = lambda {|env| ApplicationController.action(:exceptions_app).call(env)}

*NOTE*: To enable this feature in development and in test,
`config/environments/development.rb` and `config/environments/test.rb` must
have 

    config.consider_all_requests_local = false
