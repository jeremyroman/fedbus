class TripsController < ApplicationController

  before_filter permission_required(:trips), :except => [:index, :show]

  # GET /trips
  # GET /trips.xml
  def index
    @trips = Trip.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @trips }
    end
  end

  # GET /trips/1
  # GET /trips/1.xml
  def show
    @trip = Trip.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @trip }
    end
  end

  # GET /trips/new
  # GET /trips/new.xml
  def new
    @trip = Trip.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @trip }
    end
  end

  # GET /trips/1/edit
  def edit
    @trip = Trip.find(params[:id])
  end

  # POST /trips
  # POST /trips.xml
  def create
    # We have to convert the two posted values for each time into a single string
    # If we don't Trip.new can't populate the Trips values based on the post hash
    @trip = Trip.new(parse_post params[:trip])

    respond_to do |format|
      if @trip.save
        flash[:notice] = 'Trip was successfully created.'
        format.html { redirect_to(@trip) }
        format.xml  { render :xml => @trip, :status => :created, :location => @trip }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @trip.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /trips/1
  # PUT /trips/1.xml
  def update
    @trip = Trip.find(params[:id])

    respond_to do |format|
      if @trip.update_attributes(parse_post params[:trip])
        flash[:notice] = 'Trip was successfully updated.'
        format.html { redirect_to(@trip) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @trip.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /trips/1
  # DELETE /trips/1.xml
  def destroy
    @trip = Trip.find(params[:id])
    @trip.destroy

    respond_to do |format|
      format.html { redirect_to(trips_url) }
      format.xml  { head :ok }
    end
  end


  # Helper functions

  # We have to convert the two posted values for each time into a single string
  # If we don't Trip.new and Trip.update_attributes can't populate the Trips
  # values based on the post hash
  def parse_post params
    p = params
    [:departure, :arrival, :return].each { |x|
      # Skip below if the key we want already exists (convenient for testing)
      next if p.key? x

      i_hour = x.to_s + '(4i)'
      i_min  = x.to_s + '(5i)'
      p[x] = p[i_hour].to_s + ':' + p[i_min].to_s
      p.delete(i_hour)
      p.delete(i_min)
    }

    return p
  end

end
