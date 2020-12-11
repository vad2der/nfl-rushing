class Api::V1::RushStatController < ApplicationController
  before_action :set_params
  def index
    from_record = @page_size * (@page_number - 1)
    result = RushStat.search_by_name(@query, @sort_column, @sort_order, from_record, @page_size)
    render json: result, status: :ok
  rescue => err
    puts err
    render json: err.to_json, status: :internal_server_error
  end

  private

  def rush_stat_params
    params.permit(:query, :sort_column, :sort_order, :page_size, :page_number, rush_stat: {})
  end

  def set_params
    @query = rush_stat_params[:query]
    @sort_column = rush_stat_params[:sort_column]
    @sort_order = rush_stat_params[:sort_order]
    @page_size = rush_stat_params[:page_size].to_i
    @page_number = rush_stat_params[:page_number].to_i
  end
end
