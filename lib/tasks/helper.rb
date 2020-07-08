# frozen_string_literal: true

module Rake
  module Helper
    extend DSL

    def self.rake_alias(old_task, new_task)
      ::Rake::Task[old_task].clear

      desc "~> Aliased / Act as #{new_task}"
      task old_task.to_sym => :environment do
        puts "Aliased Rake Task / Act as \"#{new_task}\"".yellow
        ::Rake::Task[new_task].invoke
      end
    end
  end
end
