class Api::V1::UserController < Api::V1::ApiController


  def create
    user = User.new(user_params)
    if !user.unique?
      user.valid?
      conflict user.errors
    elsif user.save
      render json: user
    elsif check_validation user
      error
    end
  end

  private
    def user_params
      params.require(:user).permit(:email, :nickname, :password, :password_confirmation)
    end

end
