class ComplainsController < ApplicationController

    before_action :authenticate_user!
    before_action :set_complain, only: [:show, :edit, :update, :destroy]
    before_action :verify_password_change
    autocomplete :complain, :contravertion
    autocomplete :complain, :crime
    def index
        if user_signed_in?
            @role_current_user = current_user.role

          if      @role_current_user==1
              @patrol_units = Array.new
            PatrolUnit.all.each do |comp|
              if comp.name == nil
                comp.name=""
              end
              @patrol_units << [comp.code + ' ' + comp.name,comp.id]
            end

                if params[:search]
                  @complains = Complain.search(params[:search]).order("created_at DESC")
                else
                 @complains=Complain.all
                 end
          elsif  @role_current_user==2
            if params[:search]
              @complains = Complain.search(params[:search]).order("created_at DESC")
            else
               @complains = Complain.where(:user_id =>current_user.id)
             end
          end
        end
    end
    # GET /complains/1
    # GET /complains/1.json
    def show
      @observationsAux = params[:observationsAux]
      @caseReportAux = params[:caseReportAux]
      @complain = Complain.find(params[:id])
      @complainant = Complainant.where(:complain_id => @complain.id).first
    end
    def caseReport

   @complain = Complain.find(params[:id])
   @complain.completeDate = Date.today
   if @message.save
    redirect_to myHomeMessages_path, :flash => { :success => "Your message was closed." }
   else
    redirect_to myHomeMessages_path, :flash => { :error => "Error closing message." }
   end

    end
    def index_oficial

        #   File.open("/home/nataly/1/aux/911/unidades", "r") do |f|

        #    f.each_line do |line|
        #    @aux2=line

        #    @aux = PatrolUnit.new
        #    if @aux2!=nil
        #        @aux.code =  @aux2
        #      if @aux.valid?

        #        @aux.save!
        #      end
        #    end
        #    end
        #  end
        
    end
    # GET /complains/new
    def new
        if current_user.role==2 ||current_user.role==1
          @complain = Complain.new
          @complainant = Complainant.new
          @crimes = Array.new
          Crime.all.each do |comp|
            @crimes << [comp.code + ' ' + comp.name]
          end
          @contravertions = Array.new
          Contravertion.all.each do |comp|
            @contravertions << [comp.code + ' ' + comp.name]
          end


        else
          redirect_to root_url
        end
  end
    # GET /complains/1/edit
    def edit
        @complain = Complain.find(params[:id])
        @complainant = Complainant.where(:complain_id => @complain.id).first
      else
        if current_user.role==2 ||current_user.role==1
      #  check_box_params[:auxCrime]= @complain.crie.code+ ' ' +@complain.crime.name
          @crimes = Array.new
          Crime.all.each do |comp|
            @crimes << [comp.code + ' ' + comp.name]
          end
          @contravertions = Array.new
          Contravertion.all.each do |comp|
            @contravertions << [comp.code + ' ' + comp.name]
          end
        else
          redirect_to root_url
        end
    end

    # POST /complains
    # POST /complains.json

    def create
      @complain = Complain.new(complain_params)
      @complainant = Complainant.new(complainant_params)
      @crimes = Array.new
      @complain.user_id= current_user.id

      Crime.all.each do |comp|
        @crimes << [comp.code + ' ' + comp.name]
      end
      @contravertions = Array.new
      Contravertion.all.each do |comp|
        @contravertions << [comp.code + ' ' + comp.name]
      end

      if check_box_params[:crime]=='1'
        @auxCrime_id = Crime.where(:code =>(params[:auxCrime]).split[0...2].join(' ')).pluck(:id).first.to_i
      end
      if check_box_params[:contravertion]=='1'
        @auxContravertion_id = Contravertion.where(:code =>(params[:auxContravertion]).split[0...2].join(' ')).pluck(:id).first.to_i
      end
      if @auxCrime_id!=0
        @complain.crime_id = @auxCrime_id
      end
      if @auxContravertion_id!=0
          @complain.contravertion_id = @auxContravertion_id
      end

      respond_to do |format|
        if (check_box_params[:crime]=='0'&& check_box_params[:contravertion]=='0')|| ( @auxCrime_id== 0 && @auxContravertion_id==0 ) || (check_box_params[:crime]=='1' && @auxCrime_id == 0)|| (check_box_params[:contravertion]=='1' && @auxContravertion_id == 0)
          flash[:notice] = "Debe registrar un delito o una contraversion correctamente"
          format.html { render :new }
          format.json { render json: @complain.errors, status: :unprocessable_entity }
        end
        if  @complain.valid?
              if !@complainant.valid?
                format.html { render :new}
                format.json { render json: @complainant.errors, status: :unprocessable_entity }
              else
                @complain.save!
                @complainant.complain_id= @complain.id
                @complainant.save!
                flash[:notice] = "Denuncia registrada exitosamente"
                format.html { redirect_to @complain }
                format.json { render :show, status: :created, location: @complain }
              end
        else
           format.html { render :new}
           format.json { render json: @complain.errors, status: :unprocessable_entity }
         end
      end
    end
    def patrol_unit_asign

      @complain = Complain.find(params[:complain][:complain_id])
       @complain.update_attribute(:patrol_unit_id,  params[:complain][:patrol_unit_id])
   if @complain.save!
    redirect_to complains_path, :flash => { :success => "Your message was closed." }
   else
    redirect_to show_path, :flash => { :error => "Error closing message." }
   end
    end
    # PATCH/PUT /complains/1
    # PATCH/PUT /complains/1.json
    def update
      if @observationsAux==nil
      @complain = Complain.find(params[:id])
      @complain.observations = params[:observations]
      @complainant = Complainant.where(:complain_id => @complain.id).first
      if @complainant==nil
          @complainant = Complainant.new(complainant_params)
      end
      @crimes = Array.new
      Crime.all.each do |comp|
        @crimes << [comp.code + ' ' + comp.name]
        end
      @contravertions = Array.new
      Contravertion.all.each do |comp|
        @contravertions << [comp.code + ' ' + comp.name]
        end

      if check_box_params[:crime]=='1'
        @auxCrime_id = Crime.where(:code =>(params[:auxCrime]).split[0...2].join(' ')).pluck(:id).first.to_i
        puts Crime.where(:code =>(params[:auxCrime]).split[0...2].join(' ')).pluck(:id).first.to_i
      end
      if check_box_params[:contravertion]=='1'
        @auxContravertion_id = Contravertion.where(:code =>(params[:auxContravertion]).split[0...2].join(' ')).pluck(:id).first.to_i
      end
      if @auxCrime_id!=0
        @complain.crime_id = @auxCrime_id
      end
      if @auxContravertion_id!=0
        @complain.contravertion_id = @auxContravertion_id
      end
    end
      respond_to do |format|
        if ((check_box_params[:crime]=='0'&& check_box_params[:contravertion]=='0')|| ( @auxCrime_id== 0 && @auxContravertion_id==0 ) || (check_box_params[:crime]=='1' && @auxCrime_id == 0)|| (check_box_params[:contravertion]=='1' && @auxContravertion_id == 0))
          flash[:notice] = "Debe registrar un delito o una contraversion correctamente"
          format.html { render :new }
          format.json { render json: @complain.errors, status: :unprocessable_entity }
        end
        if  @complain.valid?
              if !@complainant.valid?
                format.html { render :new}
                format.json { render json: @complainant.errors, status: :unprocessable_entity }
              else
                @complain.update_attributes(complain_params)
                @complain.save!
                @complainant.complain_id= @complain.id
                @complainant.save!
                flash[:notice] = "Denuncia registrada exitosamente UPDATE"
                format.html { redirect_to @complain }
                format.json { render :show, status: :created, location: @complain }
              end
        else
           format.html { render :new}
           format.json { render json: @complain.errors, status: :unprocessable_entity }
         end
      end

  end
    # DELETE /complains/1
    # DELETE /complains/1.json
    def destroy
      @complain.destroy
      respond_to do |format|
        format.html { redirect_to complains_url, notice: 'denuncia eliminado exitosamente.' }
        format.json { head :no_content }
      end
    end

      # Use callbacks to share common setup or constraints between actions.
      def set_complain
        @complain = Complain.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def complain_params
        params.require(:complain).permit(:protagonists, :description, :zone, :latitude, :longitude, :crime_id, :observations)
      end
      def check_box_params
        params.require(:complain).permit( :contravertion,:crime, :crime_checkbox , :contravertion_checkbox, :crimeAux,  :crime_id,:contravertion_id,:auxCrime, :auxContravertion, :observations,:patrol_unit)
      end
      def complainant_params
        params.require(:complainant).permit(:name, :last_name,:ci, :phone, :address)
      end
  end
