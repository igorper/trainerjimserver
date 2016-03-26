module ConditionalRenderHelper

  def conditional_render(resource_list, resource_name)
    latest_timestamp = get_updated_at_timestamp(resource_list)
    fresh_when last_modified: latest_timestamp,
               etag: get_etag(latest_timestamp, resource_list, resource_name),
               template: false
  end

  def get_updated_at_timestamp(resource_list)
    resource_list.maximum(:updated_at).try(:utc)
  end

  def get_etag(latest_timestamp, resource_list, resource_name)
    "#{resource_name};timestamp:#{latest_timestamp};count:#{resource_list.count}"
  end

end
