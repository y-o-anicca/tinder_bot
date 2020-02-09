require 'selenium-webdriver'
require "./secrets.rb"
include Secrets

class TinderBot
  attr_accessor :driver

  def initialize
    @driver = Selenium::WebDriver.for :chrome
  end

  def login
    self.driver.get('https://tinder.com')

    sleep(3)

    # FaceBookでログインボタン押下
    fb_btn = self.driver.find_element(:xpath, '//*[@id="modal-manager"]/div/div/div/div/div[3]/div[2]/button')
    fb_btn.click

    # windowの切り替え
    base_window = self.driver.window_handles[0]
    self.driver.switch_to.window(self.driver.window_handles[1])

    # ログインフォーム入力と実行
    email_in = self.driver.find_element(:xpath, '//*[@id="email"]')
    email_in.send_keys(FACEBOOK_ID)

    pass_in = self.driver.find_element(:xpath, '//*[@id="pass"]')
    pass_in.send_keys(FACEBOOK_PASS)

    login_btn  = self.driver.find_element(:xpath, '//*[@id="u_0_0"]')
    login_btn.click

    sleep(2)

    self.driver.switch_to.window(base_window)

    # 位置情報と通知のポップアップボタンの押下
    popup_1 = self.driver.find_element(:xpath, '//*[@id="modal-manager"]/div/div/div/div/div[3]/button[1]')
    popup_1.click

    popup_2 = self.driver.find_element(:xpath, '//*[@id="modal-manager"]/div/div/div/div/div[3]/button[2]')
    popup_2.click
  end

  def like
    like_btn = self.driver.find_element(:xpath, '//*[@id="content"]/div/div[1]/div/main/div[1]/div/div/div[1]/div/div[2]/button[3]')
    like_btn.click
  end

  def dislike
    dislike_btn = self.driver.find_element(:xpath, '//*[@id="content"]/div/div[1]/div/main/div[1]/div/div/div[1]/div/div[2]/button[1]')
    dislike_btn.click
  end

  def auto_swipe
    while true
      sleep(0.5)
      begin

        like
      rescue
        begin
          close_popup
        rescue
          close_match
        end
      end
    end
  end

  def close_popup
    popup_3 = self.driver.find_element(:xpath, '//*[@id="modal-manager"]/div/div/div[2]/button[2]')
    popup_3.click
  end

  def close_match
    popup_4 = self.driver.find_element(:xpath, '//*[@id="modal-manager-canvas"]/div/div/div[1]/div/div[3]/a')
    popup_4.click
  end

end

bot = TinderBot.new
bot.login
bot.auto_swipe
