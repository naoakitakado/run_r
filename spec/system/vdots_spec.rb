require 'rails_helper'

RSpec.describe 'VDOTページのコンテンツ閲覧', type: :system do
  before do
    @user = FactoryBot.create(:user)
    @user1 = FactoryBot.create(:user)
    @user2 = FactoryBot.create(:user)
  end

  it 'ベストタイムを登録していないユーザーは、目安ペース説明・走力レベル一覧・練習ペース一覧のみ閲覧できる' do
    # トップページに遷移する
    visit root_path
    # 自分のVDOTページへ遷移する
    visit vdots_path
    # 目安ペース説明のdropdownがある
    expect(page).to have_content('目安ペースの説明')
    # 走力レベル一覧・このvdot30中身（各距離・記録）がある
    expect(page).to have_content('vdot：30')
    expect(page).to have_content('5km')
    expect(page).to have_content('10km')
    expect(page).to have_content('ハーフ')
    expect(page).to have_content('フル')
    expect(page).to have_content('30分')
    expect(page).to have_content('40秒')
    expect(page).to have_content('63分')
    expect(page).to have_content('46秒')
    expect(page).to have_content('2時間')
    expect(page).to have_content('21分')
    expect(page).to have_content('04秒')
    expect(page).to have_content('4時間')
    expect(page).to have_content('49分')
    expect(page).to have_content('17秒')
    # 練習目安ペース一覧・このvdot30の中身（各ペースの種類・ペース）がある
    expect(page).to have_content('J')
    expect(page).to have_content('M')
    expect(page).to have_content('T-40')
    expect(page).to have_content('T-20')
    expect(page).to have_content('7:52')
    expect(page).to have_content('6:51')
    expect(page).to have_content('6:36')
    expect(page).to have_content('6:24')
    expect(page).to have_content('/km')
    # 画面上部のvdotグラフ・グラフ下のバーが表示されていない
    expect(page).to have_no_selector('#graph-area')
    expect(page).to have_no_selector('.graph-bar')
  end

  it'ベストタイムを登録しているユーザーは、目安ペース説明・走力レベル一覧・練習ペース一覧に
    加え、vdotグラフ・グラフ下のバー・各距離のベストタイムに対応したvdot表が表示される' do
    # ログインする
    # 全ベストタイムを登録する
    created_record(@user)
    # 自分のVDOTページへ遷移する
    visit user_vdots_path(@user)
    # 目安ペース説明・走力レベル一覧・練習ペース一覧が存在する
    vdot_contents(@user)
    # 画面上部のvdotグラフ・グラフ下のバーが表示されている
    expect(page).to have_selector('#graph-area')
    expect(page).to have_selector('.graph-bar')
    # 各距離のベストタイムに対応したvdot表が表示されている
    expect(page).to have_content('・5kmの目指すべきタイムと、同レベルの他種目のタイムです！')
    expect(page).to have_content('・10kmの目指すべきタイムと、同レベルの他種目のタイムです！')
    expect(page).to have_content('・ハーフの目指すべきタイムと、同レベルの他種目のタイムです！')
    expect(page).to have_content('・フルの目指すべきタイムと、同レベルの他種目のタイムです！')
  end

end