module GnsEtl
  module Backend
    class SchedulesController < GnsCore::Backend::BackendController
      include GnsCore::ApplicationHelper
      
      before_action :set_schedule, only: [:edit, :update, :logs,
                                          :start, :extract, :transfer]
  
      # GET /schedules
      def list
        @schedules = Schedule.all.order(:id)
        
        render layout: nil
      end
  
      # GET /schedules/1
      def logs
        @logs = @schedule.logs
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
      
      # Start running action
      def start
        limit = params[:limit]
        if request.post?
          if !limit.present? or !(limit.to_i != 0)
            @schedule.errors.add('limit', "not be blank (and must be a number)")
          end
          
          if @schedule.errors.empty?
            # run in background
            GnsEtl::ScheduleJob.perform_now(@schedule, {limit: limit})
            
            render json: {
              status: 'success',
              message: 'Schedule was successfully started.',
            }
          end
        end
      end
      
      # extract data action
      def extract
        limit = params[:limit]
        if request.post?
          if !limit.present? or !is_number?(limit)
            @schedule.errors.add('limit', "not be blank (and must be a number)")
          end
          
          if @schedule.errors.empty?
            # run in background
            GnsEtl::WorkerStartCopy.perform_later(@schedule, {limit: limit}) if @schedule.status == GnsEtl::Schedule::STATUS_NEW
            
            render json: {
              status: 'success',
              message: 'The schedule is copying data.',
            }
          end
        end
      end
      
      # Copy running action
      def transfer
        limit = params[:limit]
        if request.post?
          if !limit.present? or !is_number?(limit)
            @schedule.errors.add('limit', "not be blank (and must be a number)")
          end
          
          if @schedule.errors.empty?
            # run in background
            GnsEtl::WorkerStartTransfer.perform_later(@schedule, {limit: limit}) if @schedule.status == GnsEtl::Schedule::STATUS_COPIED
            
            render json: {
              status: 'success',
              message: 'The schedule is transferring data.',
            }
          end
        end
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
