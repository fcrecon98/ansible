# 2016/06/24 : morihaya : Created for MHF lbby servers log

require 'fluent/parser'

module Fluent
  class TextParser
    class MhfLbbyXml < Parser
      # Register this parser as "mhf_lbby_xml"
      Plugin.register_parser("mhf_lbby_xml", self)

      config_param :delimiter, :string, :default => " " # delimiter is configurable with " " as default
      config_param :time_format, :string, :default => nil # time_format is configurable

      # This method is called after config_params have read configuration parameters
      def configure(conf)
        super

        if @delimiter.length != 1
          raise ConfigError, "delimiter must be a single character. #{@delimiter} is not."
        end

        # TimeParser class is already given. It takes a single argument as the time format
        # to parse the time string with.
        @time_parser = TimeParser.new(@time_format)
      end

      # This is the main method. The input "text" is the unit of data to be parsed.
      # If this is the in_tail plugin, it would be a line. If this is for in_syslog,
      # it is a single syslog message.
      def parse(text)

        #print "Before : ",text,"\n" # For DEBUG
        # Replace ' ' to _
        text2 = text.gsub(/(\w) (\w)/,'\1_\2')
        # Replace Logtype (ext:"<dst" to "type=dst" )
        text3 = text2.gsub(/^<(\w+)_/,'LogTAG=\1 ')
        # Delete Shingle Quote
        text4 = text3.gsub(/'/,'')
        # Delete Tail word (ext:"/>")
        text5 = text4.gsub(/[^ ]+$/,'')
        # Rename Second tim (ext:"<glg tim='09:30:59' uid='xxxxx' xxx tim='724' xxx /> to <glg tim='09:30:59' uid='xxxxx' xxx glgtim=724 xxx />
        text6 = text5.gsub(/tim=(\d+) /,'glgtim=\1 ')

        #print "After  : ",text3,"\n" # For DEBUG

        # Split Time & Others
        arrs = text6.split(" ", 3)
        dummy,time = arrs[1].split("=")
        key_values = arrs[0] + " " + arrs[2]
        
        #p time  # For DEBUG
        #p key_values  # For DEBUG

        # Parse by configured format
        time = @time_parser.parse(time)

        record = {}
        key_values.split(@delimiter).each { |kv|
          k, v = kv.split("=", 2)
          record[k] = v
        }
        
        yield time, record
      end
    end
  end
end

