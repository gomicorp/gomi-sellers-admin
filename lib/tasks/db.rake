# frozen_string_literal: true

require_relative 'helper'

Rake::Helper.rake_alias 'db:migrate', 'db:schema:dump'
Rake::Helper.rake_alias 'db:schema:load', 'db:schema:dump'
