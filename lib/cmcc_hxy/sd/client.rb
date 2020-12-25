# encoding: utf-8

require 'base64'
require 'openssl'
require 'net/http'
require 'securerandom'
require 'cmcc_hxy/config'
require 'cmcc_hxy/rest_client'
require 'active_support/core_ext/hash'

class CmccHxy::SD::Client
  def initialize(key:, cpcode:, sale_modal_id:)
    @key = key
    @cpcode = cpcode
    @sale_modal_id = sale_modal_id
  end

  def request(service_name, param_list)
    body = ''
    uri  = URI.parse(CmccHxy::Config.hxy_sd_url)
    post = Net::HTTP::Post.new(uri.path, 'content-type' => 'text/xml; charset=UTF-8')
    xml  = request_xml_template(service_name, param_list)
    coxt = Base64.encode64(encrypt(xml)).gsub(/\n/, '')
    Net::HTTP.new(uri.host, uri.port).start {|http|
      http.request(post, coxt) { |response|
        body = response.body
      }
    }
    parse(body)
  end

  def parse(body)
    xml_to_hash(decrypt(Base64.decode64(body)))
  end

  def encrypt(context)
    cipher = OpenSSL::Cipher::DES.new(:ECB).encrypt.tap { |obj| obj.key = @key }
    cipher.update(context) + cipher.final
  end

  def decrypt(context)
    cipher = OpenSSL::Cipher::DES.new(:ECB).decrypt.tap { |obj| obj.key = @key }
    (cipher.update(context) + cipher.final).force_encoding('utf-8')
  end

  def hash_to_xml(hash)
    serialize(hash).join
  end

  def xml_to_hash(xml)
    Hash.from_xml(xml)
  end

  private

  def serialize(hash_obj)
    hash_obj.map do |key, val|
      noderize(key, val)
    end
  end

  def noderize(key, val)
    if val.class == Hash
      node_value = serialize(val).join
    else
      node_value = val.nil? ? "" : val
    end

    "<#{key}>#{node_value}</#{key}>"
  end

  def request_xml_template(service_name, param_list)
    <<-EOF
    <?xml version="1.0" encoding="UTF-8"?>
    <request>
      <SystemInfo>
        <SystemName>SDEDUYJ</SystemName>
        <Version>1.0</Version>
        <RequestInfo>
          <CpCode>#{@cpcode}</CpCode>
          <SaleModalId>#{@sale_modal_id}</SaleModalId>
          <SerialId>#{SecureRandom.hex(8)}</SerialId>
          <RequestTime>#{Time.now.strftime("%F %T")}</RequestTime>
        </RequestInfo>
      </SystemInfo>
      <ServiceInfo>
        <ServiceName>#{service_name}</ServiceName>
        <ParamList>
          #{hash_to_xml(param_list)}
        </ParamList>
      </ServiceInfo>
    </request>
    EOF
  end
end

