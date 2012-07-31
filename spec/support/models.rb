class CompanyProfile
  include Virgola

  column :email
  column :phone

  belongs_to :developer

  def initialize
    yield self if block_given?
  end

  def ==(profile)
    return false unless profile.is_a?(self.class)
    self.email == profile.email && self.phone == profile.phone
  end
end

class Task
  include Virgola

  column :title
  column :description

  belongs_to :developer, inverse_of: 'tasks'

  def initialize
    yield self if block_given?
  end

  def ==(task)
    return false unless task.is_a?(self.class)
    self.title == task.title && self.description == task.description
  end
end

class Developer
  include Virgola

  column :id
  column :name

  has_many :tasks,   type: Task,           inverse_of: 'developer'
  has_one  :profile, type: CompanyProfile, inverse_of: 'developer'

  def initialize
    yield self if block_given?
  end

  def ==(pip)
    return false unless pip.is_a?(self.class)
    self.id == pip.id && self.name == pip.name && self.tasks == pip.tasks && self.profile == pip.profile
  end
end