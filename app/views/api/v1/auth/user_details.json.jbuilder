json.partial! 'api/v1/auth/user_immediate_details', user: @user

json.is_trainer @user.trainer?