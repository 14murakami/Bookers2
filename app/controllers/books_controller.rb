class BooksController < ApplicationController
  before_action :ensure_correct_user, only:[:edit, :update]

  def new
    @book = Book.new
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    @books = Book.page(params[:page])
    if @book.save
      flash[:notice] = "You have crearted book successfully."
      redirect_to controller: :books, action: :show, id: @book.id
    else
      render :index
    end
  end

  def index
    @books = Book.page(params[:page])
    @book = Book.new
  end

  def show
    @book = Book.new
    @books = Book.find(params[:id])
    @user = User.find_by(id: @books.user_id)
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      flash[:notice] = "You have updated book successfully."
      redirect_to book_path(@book.id)
    else
      render :edit
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:title, :body, :profile_image)
  end

  def ensure_correct_user
    @book = Book.find(params[:id])
    unless @book.user == current_user
    redirect_to books_path
    end
  end

end
