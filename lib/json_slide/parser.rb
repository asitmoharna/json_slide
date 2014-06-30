require 'json'
require 'rest_client'

module JsonSlide
  #== Parser
  class Parser
    # Returns a ruby hash by parsing the json
    #
    # === Notes
    # it needs a json string or json file with file path or json file url
    #
    # === Examples
    # parser = JsonSlide::Parser.parse("{\"slide1\":{},\"slide2\":{}}")
    # parser = JsonSlide::Parser.parse('path/to/my/awesome/file.json')
    # parser = JsonSlide::Parser.parse('http://awesome_url.json')
    #
    # === Parameters
    # * json_input: String containing the json string / json file path / json url
    #
    # === Returns
    # * Symbolized ruby hash by parsing the json
    class  << self
      def parse(json_input)
        begin
          json = if(json_input =~ URI::regexp)
            RestClient.get(json_input)
          elsif ( !(json_input).match(/\.json$/i).nil? && File.exist?(json_input) && File.file?(json_input) )
            File.read(json_input)
          else
            json_input
          end
          JSON.parse(json, { symbolize_names: true })
        rescue JSON::ParserError
          raise "Invalid JSON Format!! Please enter a valid json string or json file with path or json file url."
        rescue URI::InvalidURIError
          raise "Invalid JSON url!! Please enter a valid json string or json file with path or json file url."
        rescue => e
          raise e.message
        end
      end
    end

  end
end
