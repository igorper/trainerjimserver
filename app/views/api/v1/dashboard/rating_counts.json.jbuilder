json.array! @rating_counts do |rating_count|
  json.user_id rating_count.id
  json.(rating_count, :too_hard_count, :too_easy_count, :okay_count)
end