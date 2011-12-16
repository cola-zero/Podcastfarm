class FeedsController < ApplicationController
  before_filter :authenticate

  # GET /feeds
  # GET /feeds.json
  def index
    @feeds = Feed.joins(:users).where(:users => { :id => current_user.id} )

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @feeds }
    end
  end

  # GET /feeds/1
  # GET /feeds/1.json
  def show
    @feed = Feed.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @feed }
    end
  end

  # GET /feeds/new
  # GET /feeds/new.json
  def new
    @feed = Feed.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @feed }
    end
  end

  # GET /feeds/1/edit
  # def edit
  #   @feed = Feed.find(params[:id])
  # end

  # POST /feeds
  # POST /feeds.json
  def create
    @feed = Feed.new(params[:feed])

    respond_to do |format|
      if @feed.save || !(Feed.find_by_url(params[:feed][:url]).nil?)
        @feed.register_user(current_user)
        format.html { redirect_to @feed, notice: 'Feed was successfully created.' }
        format.json { render json: @feed, status: :created, location: @feed }
      else
        format.html { render action: "new" }
        format.json { render json: @feed.errors, status: :unprocessable_entity }
      end
    end
  end

  # put /feeds/1
  # PUT /feeds/1.json
  # def update
  #   @feed = Feed.find(params[:id])

  #   respond_to do |format|
  #     if @feed.update_attributes(params[:feed])
  #       format.html { redirect_to @feed, notice: 'Feed was successfully updated.' }
  #       format.json { head :ok }
  #     else
  #       format.html { render action: "edit" }
  #       format.json { render json: @feed.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # DELETE /feeds/1
  # DELETE /feeds/1.json
  def destroy
    @feed = Feed.find(params[:id])
    @feed.unregister_user(current_user)
    if @feed.users.empty?
      @feed.destroy
    end

    respond_to do |format|
      format.html { redirect_to feeds_url }
      format.json { head :ok }
    end
  end
end
