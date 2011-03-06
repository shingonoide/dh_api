require 'uri'
require 'net/https'
require 'json'

module DhApi
  class Account
    @@host = 'api.dreamhost.com'

    def initialize(api_key)
      @api_key = api_key
    end

    # Return Hash of domains objects
    def domains
      request('domain-list_domains')
    end

    #Return Hash of users objects
    def users(passwords=false)
      if passwords
        request('user-list_users')
      else
        request('user-list_users_no_pw')
      end
    end

    def dns(cmd='list', entry={})
      case cmd
        when 'list'
          request('dns-list_records')
        when 'add'
          request('dns-add_record', {'record' => entry['record'], 'type' => entry['type'], 'value' => entry['value']})
        when 'remove'
          request('dns-remove_record', {'record' => entry['record'], 'type' => entry['type'], 'value' => entry['value']})
        else
          raise APIParameterError, 'Unknown DNS command'
      end
    end

    private
    def request(cmd, values={}, use_post=false)
      values = {
          'key' => @api_key,
          'format' => 'json',
          'cmd' => cmd,
      }.merge(values)

      connection = Net::HTTP.new(@@host, 443)
      connection.use_ssl=true
      connection.verify_mode = OpenSSL::SSL::VERIFY_NONE

      begin
        response =
            if use_post
              post = Net::HTTP::Post.new('/')
              post.form_data=values
              connection.request(post)
            else
              prepare_query_string=''
              values.each_pair { |key, value|
                prepare_query_string << "#{key}=#{value}&"
              }
              querystring = "/?#{prepare_query_string}"
              connection.get(querystring)
            end
      rescue => error
        raise APIRequestError, error.message
      end
      if %w[200 304].include?(response.code)
        data = JSON.parse(response.body)
      elsif response.code == '503'
        raise APIRequestError, response.message
      elsif response.code == '401'
        raise APIRequestError, 'Authentication error. please check if username and key are correct'
      else
        raise APIRequestError, "Dreamhost API response: ##{response.code}, message: #{response.message}"
      end
      if data['result'] == 'success'
        return data['data']
      else
        raise APIRequestError, "#{data['data']}: #{data['reason']}"
      end
    end
  end

  class APIRequestError < StandardError;
  end
  class APIParameterError < StandardError;
  end
end
