class PcoursesController < ApplicationController
  # GET /pcourses
  # GET /pcourses.xml
  def index
    @pcourses = Pcourse.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @pcourses }
    end
  end

  # GET /pcourses/1
  # GET /pcourses/1.xml
  def show
    @pcourse = Pcourse.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @pcourse }
    end
  end

  # GET /pcourses/new
  # GET /pcourses/new.xml
  def new
    @pcourse = Pcourse.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @pcourse }
    end
  end

  # GET /pcourses/1/edit
  def edit
    @pcourse = Pcourse.find(params[:id])
  end

  # POST /pcourses
  # POST /pcourses.xml
  def create
    @pcourse = Pcourse.new(params[:pcourse])

    respond_to do |format|
      if @pcourse.save
        flash[:notice] = 'Pcourse was successfully created.'
        format.html { redirect_to(@pcourse) }
        format.xml  { render :xml => @pcourse, :status => :created, :location => @pcourse }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @pcourse.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /pcourses/1
  # PUT /pcourses/1.xml
  def updater
    @pcourse = Pcourse.find(params[:id])

    respond_to do |format|
      if @pcourse.update_attributes(params[:pcourse])
        flash[:notice] = 'Pcourse was successfully updated.'
        format.html { redirect_to(@pcourse) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @pcourse.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /pcourses/1
  # DELETE /pcourses/1.xml
  def destroy
    @pcourse = Pcourse.find(params[:id])
    @pcourse.destroy

    respond_to do |format|
      format.html { redirect_to(pcourses_url) }
      format.xml  { head :ok }
    end
  end
end
