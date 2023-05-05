class UserLogsController < ApplicationController
  def index
    @user_logs = UserLog.all
  end

  def user_history
    # ดึงข้อมูล logs จากฐานข้อมูล
    @user_logs = UserLog.order(created_at: :desc)
  
    # กลับลำดับข้อมูล
    @user_logs = @user_logs.reverse
  end
  
end
