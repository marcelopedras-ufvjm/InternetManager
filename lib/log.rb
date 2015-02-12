require 'singleton'
require 'logger'

class Log
  include Singleton

  def initialize
    @log = Logger.new(STDOUT)
  end

  def info(text)
    @log.info text
  end

  def error(text)
    @log.error text
  end

  def debug(text)
    @log.debug text
  end
end