class ReportsController < ApplicationController
  before_action :set_report, only: [:show, :edit, :update, :destroy]
  require 'aws-sdk'

  # GET /reports
  # GET /reports.json
  def index
    @reports = Report.all
  end

  # GET /reports/1
  # GET /reports/1.json
  def show
    Aws.config.update({
      credentials: Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY'])
    })
    
    client = Aws::Rekognition::Client.new(
      region: ENV['AWS_REGION'],
      access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
    )
    
    

    @text_detections_a = client.detect_text({
      image: { # required
        s3_object: {
          bucket: ENV['AWS_BUCKET'],
          name: @report.image_a.key          
        }
      }      
    })

    @text_detections_b = client.detect_text({
      image: { # required
        s3_object: {
          bucket: ENV['AWS_BUCKET'],
          name: @report.image_b.key          
        }
      }      
    })

    @detect_labels_a = client.detect_labels({
      image: { # required
        s3_object: {
          bucket: ENV['AWS_BUCKET'],
          name: @report.image_a.key          
        }
      }   
    })

    @detect_labels_b = client.detect_labels({
      image: { # required
        s3_object: {
          bucket: ENV['AWS_BUCKET'],
          name: @report.image_b.key          
        }
      }     
    })


    @detect_moderation_labels_a = client.detect_moderation_labels({
      image: { # required
        s3_object: {
          bucket: ENV['AWS_BUCKET'],
          name: @report.image_a.key
        },
      },
      min_confidence: 1.0,
    })

    @detect_moderation_labels_b = client.detect_moderation_labels({
      image: { # required
        s3_object: {
          bucket: ENV['AWS_BUCKET'],
          name: @report.image_b.key
        },
      },
      min_confidence: 1.0,
    })
    
    
  end

  # GET /reports/new
  def new
    @report = Report.new
  end

  # GET /reports/1/edit
  def edit
  end

  # POST /reports
  # POST /reports.json
  def create
    @report = Report.new(report_params)

    respond_to do |format|
      if @report.save
        format.html { redirect_to @report, notice: 'Report was successfully created.' }
        format.json { render :show, status: :created, location: @report }
      else
        format.html { render :new }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reports/1
  # PATCH/PUT /reports/1.json
  def update
    respond_to do |format|
      if @report.update(report_params)
        format.html { redirect_to @report, notice: 'Report was successfully updated.' }
        format.json { render :show, status: :ok, location: @report }
      else
        format.html { render :edit }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reports/1
  # DELETE /reports/1.json
  def destroy
    @report.destroy
    respond_to do |format|
      format.html { redirect_to reports_url, notice: 'Report was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_report
      @report = Report.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def report_params
      params.require(:report).permit(:name, :image_a, :image_b)
    end
end
