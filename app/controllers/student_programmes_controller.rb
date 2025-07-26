class StudentProgrammesController < ApplicationController
  # GET /student_programmes
  # GET /student_programmes.xml
  def index
    @student_programmes = StudentProgramme.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @student_programmes }
    end
  end

  # GET /student_programmes/1
  # GET /student_programmes/1.xml
  def show
    @student_programme = StudentProgramme.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @student_programme }
    end
  end

  # GET /student_programmes/new
  # GET /student_programmes/new.xml
  def new
    @student_programme = StudentProgramme.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @student_programme }
    end
  end

  # GET /student_programmes/1/edit
  def edit
    @student_programme = StudentProgramme.find(params[:id])
  end

  # POST /student_programmes
  # POST /student_programmes.xml
  def create
    @student_programme = StudentProgramme.new(params[:student_programme])

    respond_to do |format|
      if @student_programme.save
        flash[:notice] = 'StudentProgramme was successfully created.'
        format.html { redirect_to(@student_programme) }
        format.xml  { render :xml => @student_programme, :status => :created, :location => @student_programme }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @student_programme.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /student_programmes/1
  # PUT /student_programmes/1.xml
  def updater
    @student_programme = StudentProgramme.find(params[:id])

    respond_to do |format|
      if @student_programme.update_attributes(params[:student_programme])
        flash[:notice] = 'StudentProgramme was successfully updated.'
        format.html { redirect_to(@student_programme) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @student_programme.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /student_programmes/1
  # DELETE /student_programmes/1.xml
  def destroy
    @student_programme = StudentProgramme.find(params[:id])
    @student_programme.destroy

    respond_to do |format|
      format.html { redirect_to(student_programmes_url) }
      format.xml  { head :ok }
    end
  end
end
