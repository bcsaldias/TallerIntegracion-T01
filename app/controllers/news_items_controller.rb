class NewsItemsController < ApplicationController
  before_action :set_news_item, only: [:show, :edit, :update, :destroy]

  # GET /news_items
  # GET /news_items.json
  def index
    @news_items = NewsItem.formatted_list
  end

  # GET /news_items/1
  # GET /news_items/1.json
  def show
      @comments = Comment.where(news_item_id: @news_item.id).entries
      @comment = @news_item.comments.build #Comment.new
  end

  # GET /news_items/new
  def new
    @news_item = NewsItem.new
    @maximum_length = NewsItem.validators_on( :lead ).first.options[:maximum]
    @current_length = 0
  end

  # GET /news_items/1/edit
  def edit
    @maximum_length = NewsItem.validators_on( :lead ).first.options[:maximum]
    @current_length = @news_item.lead.size
  end

  # POST /news_items
  # POST /news_items.json
  def create
    @news_item = NewsItem.new(news_item_params)

    respond_to do |format|
      if @news_item.save
        format.html { redirect_to new_news_item_comment_path(news_item_id:@news_item.id,
                    _index: true, _admin: true), notice: 'Noticia creada exitosamente.' }
        format.js
        format.json { render :show, status: :created, location: @news_item }
      else
        format.html { render :new }
        format.json { render json: @news_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /news_items/1
  # PATCH/PUT /news_items/1.json
  def update
    respond_to do |format|
      if @news_item.update(news_item_params)
        format.html { redirect_to new_news_item_comment_path(news_item_id:@news_item.id,
                    _index: true, _admin: true), notice: 'Noticia editada exitosamente.' }
        format.json { render :show, status: :ok, location: @news_item }
      else
        format.html { render :edit }
        format.json { render json: @news_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /news_items/1
  # DELETE /news_items/1.json
  def destroy
    @title = @news_item.title
    @news_item.destroy
    respond_to do |format|
      format.html { redirect_to news_items_url, notice: 'Noticia "'+ @title +\
                            '" ha sido eliminada exitosamente junto a sus comentarios.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_news_item
      @news_item = NewsItem.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def news_item_params
      params.require(:news_item).permit(:title, :lead, :body)
    end
end
