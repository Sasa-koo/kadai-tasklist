class TasksController < ApplicationController
  before_action :require_user_logged_in
  before_action :correct_user, only: [:destroy, :show, :edit, :update]
  #before_action :set_task, only: [:edit, :update, :destroy]
  
  def index
    @pagy, @tasks = pagy(current_user.tasks.order(id: :desc), items:3)
  end

  def show
    unless @task
      redirect_to root_url
    end
  end

  def new
    @task = Task.new
  end

  def create
    @task = current_user.tasks.build(task_params)
    if @task.save
      flash[:success] = 'タスクが正常に投稿されました'
      redirect_to root_url
    else
      @pagy, @tasks = pagy(current_user.tasks.order(id: :desc))
      flash.now[:danger] = 'タスクが投稿されませんでした'
      render 'tasks/new'
    end
  end

  def edit
  end

  def update

    if @task.update(task_params)
      flash[:success] = 'タスクは正常に更新されました'
      redirect_to @task
    else
      flash.now[:danger] = 'タスクは更新されませんでした'
      render :edit
    end
  end

  def destroy
    @task.destroy
    
    flash[:success] = 'タスクは正常に削除されました'
    redirect_to root_url
  end
  
  private

  # Strong Parameter
  def task_params
    params.require(:task).permit(:content, :status)
  end
  
  def correct_user
    @task = current_user.tasks.find_by(id: params[:id])
    unless @task
      redirect_to root_url
    end
  end
end