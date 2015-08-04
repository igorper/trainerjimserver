module ConditionalRenderHelper

  def conditional_render(resource_list, resource_name)
    latest_timestamp = resource_list.maximum(:updated_at).try(:utc)
    fresh_when last_modified: latest_timestamp,
               etag: "#{resource_name};timestamp:#{latest_timestamp};count:#{resource_list.count}",
               template: false
  end

end
