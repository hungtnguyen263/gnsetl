module GnsEtl
  module Backend
    class MappingsController < GnsCore::Backend::BackendController
      before_action :set_mapping, only: [:edit, :update]#, :select_source_fields, :select_destination_fields]
  
      # GET /mappings
      def list
        @mappings = Mapping.search(params).paginate(:page => params[:page], :per_page => params[:per_page])
        
        render layout: nil
      end
  
      # GET /mappings/1
      def show
      end
  
      # GET /mappings/new
      def new
        @mapping = Mapping.new
      end
  
      # GET /mappings/1/edit
      def edit
      end
  
      # POST /mappings
      def create
        @mapping = Mapping.new(mapping_params)
  
        if @mapping.save
          render json: {
            status: 'success',
            message: 'Mapping was successfully created.',
          }
        else
          render :new
        end
      end
  
      # PATCH/PUT /mappings/1
      def update
        if @mapping.update(mapping_params)
          render json: {
            status: 'success',
            message: 'Mapping was successfully updated.',
          }
        else
          render :edit
        end
      end
      
      def select_source_fields
        render layout: nil
      end
      
      def select_destination_fields
        render layout: nil
      end
  
      private
        # Use callbacks to share common setup or constraints between actions.
        def set_mapping
          @mapping = Mapping.find(params[:id])
        end
  
        # Only allow a trusted parameter "white list" through.
        def mapping_params
          params.fetch(:mapping, {}).permit(:source_table, :source_field, :destination_table, :destination_field, :default_value)
        end
    end
  end
end
