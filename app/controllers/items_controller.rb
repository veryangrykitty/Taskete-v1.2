class ItemsController < ApplicationController
  before_action :set_item, only: [:destroy, :move]

  # def index
  #   @items = Item.all
  #   #change it to include task_id when task is connected

  #   respond_to do |format|
  #     format.html
  #     format.text { render partial: @items, formats: [:html] }
  #   end
  # end

  def new
    @item = Item.new
    @task = Task.find(params[:task_id])
    respond_to do |format|
      # format.html
      format.text { render partial: 'items/itemform', locals: { item: @item, task: @task }, formats: [:html] }
    end
  end

  def create
    item_params = JSON.parse(request.body.read)
    @item = Item.new
    @item.title = item_params['title']
    @item.task = Task.find(item_params['taskId'])
    @task = @item.task

    if @item.save
      respond_to do |format|
        format.text { render partial: 'items/item', locals: { item: @item, task: @task, workflow: @item.task.workflow }, formats: [:html] }
      end
    else
      redirect_to dashboard_path
    end
  end

  def destroy
    @item.destroy
    redirect_to dashboard_path
  end

  def move
    @item.insert_at(params[:position].to_i)
    @item.update(move_item_params)
    head :ok
  end

  private

  # def item_params
  #   params.require(:item).permit(:title, :task_id)
  # end

  def move_item_params
    params.permit(:task_id, :position, :id)
  end

  def set_item
    @item = Item.find(params[:id])
  end
end
