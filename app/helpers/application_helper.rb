module ApplicationHelper
  def full_title(page_title = '')
    base_title = "需給管理システム"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end

  def set_time(params, period)
    if params["#{period}_at_date"].present?
      count = 1
      period_date = params["#{period}_at_date"].split("-")
      period_date.each do |pd|
        params["#{period}_at(#{count}i)"] = pd
        count += 1
      end
    end
  end

  def reset_time(period)
    if params["#{period}_at_date"].blank?
      3.times do |n|
        n += 1
        params["#{period}_at(#{n}i)"] = ""
      end
    end
  end

  def get_date(variable, period)
    if variable["#{period}_at"].present?
      year = variable["#{period}_at"].strftime("%Y")
      month = variable["#{period}_at"].strftime("%m")
      day = variable["#{period}_at"].strftime("%d")
      "#{year}-#{month}-#{day}"
    end
  end

  # sort
  def sort_asc(column_to_be_sorted, search_params = nil, remote = false)
    opts = { :column => column_to_be_sorted, :direction => "asc" }
    # opts.merge!(search_params) if search_params.present?
    link_to "▲", opts, remote: remote
  end

  def sort_desc(column_to_be_sorted, search_params = nil, remote = false)
    opts = { :column => column_to_be_sorted, :direction => "desc" }
    # opts.merge!(search_params) if search_params.present?
    link_to "▼", opts, remote: remote
  end

  def sort_direction
    %W(asc desc).include?(params[:direction]) ? params[:direction] : "asc"
  end

  def ajax_redirect_to(redirect_url)
    { js: "window.location.replace('#{redirect_url}');" }
  end
end
