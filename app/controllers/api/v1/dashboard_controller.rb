class Api::V1::DashboardController < ActionController::Base

  include AuthenticationHelper

  def rating_counts
    when_trainer do
      month_ago = DateTime.now.ago(31.days)
      @rating_counts = User.find_by_sql([%{
SELECT
  u.id,
  COALESCE(too_hard_rating_count.cnt, 0) AS too_hard_count,
  COALESCE(too_easy_rating_count.cnt, 0) AS too_easy_count,
  COALESCE(okay_rating_count.cnt, 0) AS okay_count
FROM
  users AS u
LEFT OUTER JOIN
  (SELECT m.trainee_id as trainee_id, count(se.*) as cnt
  FROM measurements m
  INNER JOIN series_executions se ON m.id = se.measurement_id
  WHERE se.rating = 0 AND m.start_time >= :since
  GROUP BY m.trainee_id) as too_hard_rating_count ON too_hard_rating_count.trainee_id = u.id
LEFT OUTER JOIN
  (SELECT m.trainee_id as trainee_id, count(se.*) as cnt
  FROM measurements m
  INNER JOIN series_executions se ON m.id = se.measurement_id
  WHERE se.rating = 2 AND m.start_time >= :since
  GROUP BY m.trainee_id) as too_easy_rating_count ON too_easy_rating_count.trainee_id = u.id
LEFT OUTER JOIN
  (SELECT m.trainee_id as trainee_id, count(se.*) as cnt
  FROM measurements m
  INNER JOIN series_executions se ON m.id = se.measurement_id
  WHERE se.rating = 1 AND m.start_time >= :since
  GROUP BY m.trainee_id) as okay_rating_count ON okay_rating_count.trainee_id = u.id
WHERE
  u.trainer_id = :trainer_id AND
  (COALESCE(too_hard_rating_count.cnt, 0) > 0 OR
  COALESCE(too_easy_rating_count.cnt, 0) > 0 OR
  COALESCE(okay_rating_count.cnt, 0) > 0)
ORDER BY u.id
}, trainer_id: current_user.id, since: month_ago])
    end
  end

  def total_rest
    when_trainer do
      month_ago = DateTime.now.ago(31.days)
      @rest_times = User.find_by_sql([%{
SELECT
  u.id,
  SUM(se.rest_time) rest_time
FROM
  users u
  INNER JOIN measurements m ON m.trainee_id = u.id
  INNER JOIN series_executions se ON se.measurement_id = m.id
WHERE
  u.trainer_id = :trainer_id AND
  m.start_time >= :since
GROUP BY u.id
}, trainer_id: current_user.id, since: month_ago])
      render :rest_times
    end
  end

  def planned_rest
    when_trainer do
      month_ago = DateTime.now.ago(31.days)
      @rest_times = User.find_by_sql([%{
SELECT
  u.id,
  SUM(s.rest_time) rest_time
FROM
  users u
  INNER JOIN measurements m ON m.trainee_id = u.id
  INNER JOIN series_executions se ON se.measurement_id = m.id
  INNER JOIN series s ON s.id = se.series_id
WHERE
  u.trainer_id = :trainer_id AND
  m.start_time >= :since
GROUP BY u.id
}, trainer_id: current_user.id, since: month_ago])
      render :rest_times
    end
  end

  def monthly_overview
    when_trainer do
      @measurements = Measurement.where('start_time >= :month_ago', month_ago: DateTime.now.ago(31.days))
                          .joins(:trainee)
                          .where('users.trainer_id = :trainer_id', trainer_id: current_user.id)
    end
  end
end