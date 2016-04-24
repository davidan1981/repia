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
`Repia::BaseController`, which gracefully handles all errors using
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
