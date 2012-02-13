# encoding: UTF-8
module Virgola::ExtractionMethods
  extend ActiveSupport::Concern

  def count
    @contents.size-1
  end

  def all
    self.in_groups_of(@contents.size)
  end

  def each
    self.in_groups_of(1) { |group|
      yield group.first
    }
  end

  def in_groups_of(batch_size=1000)
    all_groups = []

    (0..self.count).step(batch_size) { |batch_start|
      batch_offset = batch_start + batch_size
      batch_offset = @contents.size if batch_offset >= @contents.size

      group = self.extract(@contents[batch_start+1, batch_offset])
      (block_given? && group.present?) ? (yield group) : (all_groups += group)
    }

    all_groups
  end
end
