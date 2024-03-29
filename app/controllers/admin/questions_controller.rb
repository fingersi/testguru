class Admin::QuestionsController < Admin::BaseController

  before_action :find_test, only: %i[index new create]
  before_action :find_question, except: %i[index new create]

  rescue_from ActiveRecord::RecordNotFound, with: :rescue_question_not_found

  def index
    @questions = @test.questions
  end

  def show
  end

  def edit
  end

  def update
    if @question.update(question_params)
      redirect_to admin_question_path(@question)
    else
      render :edit
    end
  end

  def new
    @question = @test.questions.new
  end

  def create
    @question = @test.questions.new(question_params)
    if @question.save
      redirect_to admin_question_path(@question)
    else
      flash.alert = t('Cannot_save_badge')
      render :new
    end
  end

  def destroy
    @question.destroy
  end

  private

  def find_question
    @question = Question.find(params[:id])
  end

  def find_test
    @test = Test.find(params[:test_id])
  end

  def rescue_question_not_found
    redirect_to root_path, alert: t('.no_question')
  end

  def question_params
    params.require(:question).permit(:body)
  end
end
