module SeriesHelper

  def self.to_series(params)
    filtered_params = params.permit(:repeat_count, :weight, :rest_time, :order)
    Series.new(filtered_params)
  end

end
