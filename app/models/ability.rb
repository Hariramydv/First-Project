class Ability
  include CanCan::Ability

    def initialize(user)

      user ||= User.new
      if user.has_role? :admin
        can :manage, :all
      else
        can :read, :all
        can :update ,Property do |property|
          property.user==user
        end
        can :destroy ,Property do |property|
          property.user==user
        end
      end
    end
  
end
