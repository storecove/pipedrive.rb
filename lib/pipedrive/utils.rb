module Pipedrive
  module Utils
    extend ActiveSupport::Concern

    def follow_pagination(method, args, params)
      start = params[:start] || 0
      limit = params[:limit] || 100
      count = 0
      loop do
        res = __send__(method, *args, params.merge(start: start, limit: limit))
        break if !res.try(:data) || !res.success?
        res.data.each do |item|
          count += 1
          yield item
        end
        break if count >= limit
        break unless res.try(:additional_data).try(:pagination).try(:more_items_in_collection?)
        start = res.try(:additional_data).try(:pagination).try(:next_start)
      end
    end
  end
end
