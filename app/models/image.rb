# == Schema Information
# Schema version: 2
#
# Table name: assets
#
#  id              :integer       not null, primary key
#  filename        :string(255)   
#  width           :integer       
#  height          :integer       
#  content_type    :string(255)   
#  size            :integer       
#  attachable_type :string(255)   
#  attachable_id   :integer       
#  updated_at      :datetime      
#  created_at      :datetime      
#
require 'open-uri'

class Image < ActiveRecord::Base
  set_table_name 'assets'
  belongs_to :attachable, :polymorphic => true

  has_attachment :storage => :file_system, 
    :thumbnails => { :fullscreen => '800x', :thumb => '120>', :tiny => '50>' }, 
    :max_size => 5.megabytes,
    :path_prefix => "public/image_assets"

  # Download from the internets
  def url=(url)
    return unless url =~ /^http:\/\//
    open url do |file|
      self.filename  = File.basename(url)
      self.temp_data = file.read
      self.content_type = file.content_type
    end
    #      logger.warn "Error replacing article image: #{$1}"
    #      logger.info $!.backtrace.collect { |b| " > #{b}" }.join("\n")
  end
  def url
  end
end
