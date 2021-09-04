class CoursePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end
  
  def show?
    # Allow user to see the course if it is published and apporved or the user is an admin, or the user who created the course or the user has bought the course
    @record.published && record.approved ||
    @user.present? && @user.has_role?(:admin) ||
    @user.present? && @record.user_id == @user.id ||
    @user.present? && @record.bought(@user)
  end
  
  def edit?
    @record.user_id == @user.id
  end
  
  def update?
    @record.user_id == @user.id
  end
  
  def new?
    @user.has_role?(:teacher)
  end
  
  def create?
    @user.has_role?(:teacher)
  end
  
  def destroy?
    @user.has_role?(:admin) || @record.user_id == @user.id
  end
  
  def approve?
    @user.has_role?(:admin)
  end
  
  def owner?
    @record.user_id == @user.id
  end
  
  
end
