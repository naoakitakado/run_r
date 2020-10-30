class UsersController < ApplicationController
  include Vdots

  def show
    @user = User.find(params[:id])
    @tweets = @user.tweets.page(params[:page]).per(8).order('created_at DESC')

    get_record(params[:id])    # 各ベストタイムのレコードを取得
    get_five_vdot              # 登録してある5kmのベストタイムを元に、5kmのvdot（走力レベル）を取得
    get_ten_vdot               # 登録してある10kmのベストタイムを元に、10kmのvdot（走力レベル）を取得
    get_half_vdot              # 登録してあるハーフのベストタイムを元に、ハーフのvdot（走力レベル）を取得
    get_full_vdot              # 登録してあるフルのベストタイムを元に、フルのvdot（走力レベル）を取得
    target_record_and_pace     # 目指すべきベストタイムと推奨ペースを取得
    runner_title               # 走力に応じた称号を取得
  end

  def followings
    @user = User.find(params[:id])
    @users = @user.followings.page(params[:page]).per(5)
    render 'show_followings'
  end

  def followers
    @user = User.find(params[:id])
    @users = @user.followers.page(params[:page]).per(5)
    render 'show_followers'
  end

  private

  def runner_title    # 走力に応じた称号を取得
    vdots = [@five_vdot, @ten_vdot, @half_vdot, @full_vdot]
    max_vdot = vdots.max

    # 最大走力レベルに対応する称号を取得
    # (計算方法)          5 - (最大走力レベル ÷5 )(端数切捨て) ただし0より小さくはならないようにする
    @runner_level_num = [5 - (max_vdot / 5).to_i, 0].max
  end
end
