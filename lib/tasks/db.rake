# frozen_string_literal: true

Rake::Task['db:migrate'].clear

namespace 'db' do
  desc '~> Aliased / Act as db:schema:dump'
  task migrate: :environment do
    puts 'Aliased / Act as "db:schema:dump"'.yellow
    Rake::Task['db:schema:dump'].invoke
  end
end
