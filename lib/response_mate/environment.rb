# coding: utf-8

class ResponseMate::Environment

  attr_accessor :filename, :env, :environment_text

  delegate :[], to: :env

  def initialize(filename)
    parse(filename)
  end

  def parse(filename)
    @env = {}
    @filename = filename
    if filename && !File.exists?(filename)
      puts filename.red << ' does not seem to exist'
      return
    end

    if !filename && File.exists?(ResponseMate.configuration.environment)
      @filename = ResponseMate.configuration.environment
    end

    if @filename
      begin
        @environment_text = File.read filename
      rescue Errno::ENOENT
        puts 'Could not read' << filename.red
        exit 1
      end

      @env = YAML.load(environment_text) || {}
    end
  end
end
