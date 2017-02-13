require 'ouidb/version'
require 'ouidb/mac_range'
require 'ouidb/manufacturer'

require 'pathname'

module Ouidb
  DB_PATH = Pathname(__FILE__).parent + 'data'
end
