require 'rubygems'
require 'active_resource'

module Meetalendar
  module Admin
    module MeetupApi
      class SearchController < Comfy::Admin::Cms::BaseController

        def show
          @parameters = parameters
        end

        def new
          @groups = Meetalendar::MeetupApi.search_groups parameters
        rescue HTTPClient::BadResponseError => e
          raise unless e.res&.status == HTTP::Status::UNAUTHORIZED
          Rails.logger.warn [e.message, *e.backtrace].join($/)
          flash[:danger] = "Could not load groups and events from meetup. Is the client authorized to the Meetup API?"
          redirect_to action: :show
        end

        private

        def parameters
          if params[:parameters].present?
            JSON.parse(params[:parameters])
          else
            {country: 'DE', state: 'Sachsen', location: 'Dresden', category: '34', page: 200}
          end
        end

      end
    end
  end
end