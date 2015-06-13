module AuthenticationHelper

  include HttpResponseHelper

  def when_signed_in
    if user_signed_in?
      yield
    else
      render_unauthorized
    end
  end

  def when_admin
    if user_signed_in? && current_user.administrator?
      yield
    else
      render_unauthorized
    end
  end

  def when_trainer_of(trainee_id)
    trainee_id = trainee_id.to_i
    if user_signed_in?
      if trainee_id == current_user.id
        yield current_user
      else
        trainee = try_get_trainee(current_user, trainee_id)
        if trainee
          yield trainee
        else
          render_unauthorized
        end
      end
    else
      render_unauthorized
    end
  end

  def admin_or_trainer_of?(user, trainee_id)
    user.administrator? || user.id == trainee_id || try_get_trainee(user, trainee_id)
  end

  def trainer_of?(trainer, trainee)
    trainee.trainer && trainee.trainer.id == trainer.id
  end

  private

  def try_get_trainee(trainer, trainee_id)
    trainee = trainee_with_trainer(trainee_id)
    (!trainee.nil? && trainer_of?(trainer, trainee)) ? trainee : nil
  end

  def trainee_with_trainer(trainee_id)
    User.includes(:trainer)
        .references(:trainer)
        .find_by_id(trainee_id)
  end
end
