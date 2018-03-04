require 'httparty'
require 'base64'

class BaiduFace
  include HTTParty

  base_uri 'https://aip.baidubce.com'

  headers 'Content-Type':	'application/x-www-form-urlencoded'
  # default_options

  class GetAccessTokenError < StandardError; end
  class FaceApiVistError < StandardError; end

  @@access_token = nil
  attr_accessor :api_key, :secret_key

  def initialize(api_key, secret_key)
    @api_key = api_key
    @secret_key = secret_key
    @@access_token ||= refresh_accesss_token
    self.class.default_params access_token: access_token
  end

  # 获取当前的access_token
  def access_token
    @@access_token
  end

  # 刷新access_token
  #"access_token"=>"24.c7c0fd336284d8e99039d5dc82b98a26.2592000.1522747065.282335-10878238"
  def refresh_accesss_token
    url = "https://aip.baidubce.com/oauth/2.0/token?grant_type=client_credentials&client_id=#{api_key}&client_secret=#{secret_key}"
    resp = self.class.get(url)
    if resp.code != 200
      raise GetAccessTokenError, resp['error_description']
    else
      resp['access_token']
    end
  end

  # 注册人脸
  # options: {uid: uid, group_id: group_id, image: image, user_info: user_info, action_type: action_type}
  def add(options)
    resp = self.class.post('/rest/2.0/face/v2/faceset/user/add', {body: options})
    if resp.code != 200
      raise FaceApiVisitError, resp['error_msg']
    end
    resp
  end

  # 人脸集合中查找
  # options: {image: image, group_id: group_id, ext_filelds: ext_fields, user_top_num: user_top_num}
  def identify(options)
    self.class.post('/rest/2.0/face/v2/identify', {body: options})
  end
end