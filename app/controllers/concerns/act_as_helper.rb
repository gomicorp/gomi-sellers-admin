module ActAsHelper
  def self.included(base)
    base.extend ClassMethod
  end

  module ClassMethod
    def act_as_helper(name, setter)
      before_action setter
      attr_reader name
      helper_method name
    end
  end

  def act_as_helper(name, setter)
    self.class.attr_reader name
    setter.call
    self.class.helper_method name
  end
end
