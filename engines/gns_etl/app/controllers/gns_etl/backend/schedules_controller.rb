module GnsEtl
  module Backend
    class SchedulesController < GnsCore::Backend::BackendController
      before_action :set_schedule, only: [:start, :edit, :update, :destroy]
  
      # GET /schedules
      def list
        @schedules = Schedule.all.order(:id)
        
        render layout: nil
      end
  
      # GET /schedules/1
      def show
      end
  
      # GET /schedules/new
      def new
        @schedule = Schedule.new
      end
  
      # GET /schedules/1/edit
      def edit
      end
  
      # POST /schedules
      def create
        @schedule = Schedule.new(schedule_params)
        @schedule.status = GnsEtl::Schedule::STATUS_NEW
        
        if @schedule.save
          render json: {
            status: 'success',
            message: 'Schedule was successfully created.',
          }
        else
          render :new
        end
      end
  
      # PATCH/PUT /schedules/1
      def update
        if @schedule.update(schedule_params)
          redirect_to @schedule, notice: 'Schedule was successfully updated.'
        else
          render :edit
        end
      end
  
      # DELETE /schedules/1
      def destroy
        @schedule.destroy
        redirect_to schedules_url, notice: 'Schedule was successfully destroyed.'
      end
      
      # START /schedules/1
      def start
        @schedule.start
        GnsEtl::ScheduleJob.set(wait: 1.minutes).perform_later(@schedule, {})
        
        render json: {
          status: 'success',
          message: 'Schedule was successfully started.',
        }
      end
  
      private
        # Use callbacks to share common setup or constraints between actions.
        def set_schedule
          @schedule = Schedule.find(params[:id])
        end
  
        # Only allow a trusted parameter "white list" through.
        def schedule_params
          params.fetch(:schedule, {}).permit(:name)
        end
    end
  end
end
