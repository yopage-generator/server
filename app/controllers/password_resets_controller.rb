class PasswordResetsController < ApplicationController
  layout 'auth'

  def new
    render
  end

  def create
    PasswordResetService.new(login: params[:reset_password][:login]).call
    flash.now[:success] = I18n.t('flashes.password_reset.created')
    render
  rescue ActiveRecord::RecordNotFound
    flash.now[:success] = I18n.t('flashes.password_reset.created')
    render
  end

  def edit
    token = params[:id]
    user = User.load_from_reset_password_token token

    if user.blank?
      not_authenticated
      return
    else
      render locals: { user: user, token: token }
    end
  end

  def update
    token = params[:id]
    user = User.load_from_reset_password_token token

    if user.blank?
      not_authenticated
      return
    end

    user.password_confirmation = params[:user][:password_confirmation]
    if user.change_password! params[:user][:password]
      redirect_to root_url, flash: { success: I18n.t('flashes.password_reset.updated') }
    else
      render :edit, locals: { user: user, token: token }
    end
  end
end
