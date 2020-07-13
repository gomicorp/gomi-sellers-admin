module Sellers
  class Grade < ApplicationRecord
    validates_inclusion_of :name, in: %w[beginner bronze silver gold]
    validates_uniqueness_of :name

    BEGINNER = find_or_create_by(name: 'beginner')
    BRONZE = find_or_create_by(name: 'bronze')
    SILVER = find_or_create_by(name: 'silver')
    GOLD = find_or_create_by(name: 'gold')

    def self.beginner
      BEGINNER
    end

    def self.bronze
      BRONZE
    end

    def self.silver
      SILVER
    end

    def self.gold
      GOLD
    end
  end
end
