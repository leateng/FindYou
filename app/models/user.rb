require 'digest'
require 'baidu_face'

class User < ApplicationRecord
  API = BaiduFace.new('I7GjQK3oFkfGOZXemaBcfGeA', '6LKW0PCFbInRwfOavMyjkErGDPcrXAlz')

  validates_presence_of :name
  validates_presence_of :image

  attr_accessor :file

  before_validation :set_image
  before_save :save_image_file
  after_save :register_user

  def save_image_file
    File.open("#{Rails.root}/public/uploads/#{self.image}", "wb+") do |f|
      f.write file_content
    end
  end

  def set_image
    self.image = "#{calc_md5}.#{file.original_filename.split('.').last}"
  end

  def calc_md5
    Digest::MD5.hexdigest(file_content)
  end

  def file_content
    file.rewind
    file.read
  end

  ## options: {uid: uid, group_id: group_id, image: image, user_info: user_info, action_type: action_type}
  def register_user
    ret = API.add(uid: self.id.to_s, group_id: "default", image: Base64.encode64(file_content), user_info: self.name, action_type: "append")
    binding.pry
  end

  # 人脸集合中查找
  # options: {image: image, group_id: group_id, ext_filelds: ext_fields, user_top_num: user_top_num}
  def self.identify(options)
    API.identify options
  end
end
