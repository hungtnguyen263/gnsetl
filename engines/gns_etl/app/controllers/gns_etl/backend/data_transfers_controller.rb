module GnsEtl
  module Backend
    class DataTransfersController < GnsCore::Backend::BackendController
      before_action :set_data_transfer, only: [:show, :edit, :update, :destroy]
  
      # GET /data_transfers
      def list
        #@data_transfers = DataTransfer.all
      end
  
      # GET /data_transfers/1
      def show
      end
  
      # GET /data_transfers/new
      def new
        @data_transfer = DataTransfer.new
      end
  
      # GET /data_transfers/1/edit
      def edit
      end
  
      # POST /data_transfers
      def create
        @data_transfer = DataTransfer.new(data_transfer_params)
  
        if @data_transfer.save
          redirect_to @data_transfer, notice: 'Data transfer was successfully created.'
        else
          render :new
        end
      end
  
      # PATCH/PUT /data_transfers/1
      def update
        if @data_transfer.update(data_transfer_params)
          redirect_to @data_transfer, notice: 'Data transfer was successfully updated.'
        else
          render :edit
        end
      end
  
      # DELETE /data_transfers/1
      def destroy
        @data_transfer.destroy
        redirect_to data_transfers_url, notice: 'Data transfer was successfully destroyed.'
      end
  
      private
        # Use callbacks to share common setup or constraints between actions.
        def set_data_transfer
          @data_transfer = DataTransfer.find(params[:id])
        end
  
        # Only allow a trusted parameter "white list" through.
        def data_transfer_params
          params.fetch(:data_transfer, {})
        end
    end
  end
end
