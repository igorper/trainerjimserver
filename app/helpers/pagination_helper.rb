module PaginationHelper

  def pagination?
    :page.in?(params)
  end

  def pagination_info?
    params[:pagination_info]
  end

  def paginate(list_to_paginate, items_per_page)
    if pagination?
      list_to_paginate = list_to_paginate.page(params[:page]).per(items_per_page)
    elsif pagination_info?
      render json: pagination_info(list_to_paginate.page(0), items_per_page)
    end
    list_to_paginate
  end

  def pagination_info(list_to_paginate, items_per_page)
    {total_items: list_to_paginate.total_count, items_per_page: items_per_page}
  end

end
