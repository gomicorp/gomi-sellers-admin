# frozen_string_literal: true

Rake::Task['db:migrate'].clear
Rake::Task['db:schema:load'].clear

namespace 'db' do
  desc '~> Aliased / Act as db:schema:dump'
  task migrate: :environment do
    puts 'Aliased / Act as "db:schema:dump"'.yellow
    Rake::Task['db:schema:dump'].invoke
  end

  namespace :schema do
    desc '~> Aliased / Act as db:schema:dump'
    task load: :environment do
      puts 'Aliased / Act as "db:schema:dump"'.yellow
      Rake::Task['db:schema:dump'].invoke
    end
  end
end
