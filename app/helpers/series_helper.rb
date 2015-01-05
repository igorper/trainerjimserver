module SeriesHelper

  def self.to_new_series(params)
    Series.new(params.permit(:repeat_count, :weight, :rest_time, :order))
  end

end
