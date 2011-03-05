module DhApi
  class Account
    @@host = 'api.dreamhost.com'
    def initialize(dh_username, api_key)
      @username = dh_username
      @api_key = api_key
    end

    def domains

    end

    def request(cmd, values={},use_post=false)
      values = {
        'username' => @username,
        'key'      => @api_key,
        'format'   => 'json',
        'cmd'      => cmd,
      }.merge(values)

      connection = Net::HTTP.new(@@host, 443)
      connection.use_ssl=true
      connection.verify_mode = OpenSSL::SSL::VERIFY_NONE

      begin
        if use_post
          post = Net::HTTP::Post.new('/')
          post.form_data=values
          connection.request(post)
        else
          prepare_query_string=''
          values.each_pair{|key,value|
            prepare_query_string << "#{key}=#{value}&"
          }
          querystring = "/?#{prepare_query_string}"

        end
      rescue => error
        raise APIRequestError, error.message
      end

    end

  end
end
