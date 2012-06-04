require 'sprockets'
require 'tilt'

module Sprockets
  class CommonJS < Tilt::Template
    self.default_mime_type = 'application/javascript'

    def self.default_namespace
      'this.require'
    end

    def prepare
      @namespace = self.class.default_namespace
    end

    attr_reader :namespace

    def evaluate(scope, locals, &block)
      if File.extname(scope.logical_path) == '.module'
        path = scope.logical_path
        path = path.gsub(/^\.?\//, '') # Remove relative paths
        path = path.chomp('.module')   # Remove module ext

        scope.require_asset 'sprockets/commonjs'

        code = ''
        code << "#{namespace}.define({#{path.inspect}:"
        code << 'function(exports, require, module){'
        code << data
        code << ";}});\n"
        code
      else
        data
      end
    end
  end

  register_postprocessor 'application/javascript', CommonJS
  append_path File.expand_path('../../../assets', __FILE__)
end