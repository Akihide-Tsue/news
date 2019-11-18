# -*- coding:utf-8 -*-
module ActionView
  module Renderable
    private
    def compile_with_magic_comment!(render_symbol, local_assigns)
      locals_code = local_assigns.keys.map { |key| "#{key} = local_assigns[:#{key}];" }.join

      source = <<-end_src
        # -*- coding:utf-8 -*-
        def #{render_symbol}(local_assigns)
          old_output_buffer = output_buffer;#{locals_code};#{compiled_source}
        ensure
          self.output_buffer = old_output_buffer
        end
      end_src

      begin
        ActionView::Base::CompiledTemplates.module_eval(source, filename, 0)
      rescue Errno::ENOENT => e
        raise e # Missing template file, re-raise for Base to rescue
      rescue Exception => e # errors from template code
        if logger = defined?(ActionController) && Base.logger
          logger.debug "ERROR: compiling #{render_symbol} RAISED #{e}"
          logger.debug "Function body: #{source}"
          logger.debug "Backtrace: #{e.backtrace.join("\n")}"
        end

        raise ActionView::TemplateError.new(self, {}, e)
      end
    end
    alias_method_chain :compile!, :magic_comment
  end
end


# -*- coding:utf-8 -*-
module ActionController
  class Request
    private
    def normalize_parameters_with_force_encoding(value)
      (_value = normalize_parameters_without_force_encoding(value)).respond_to?(:force_encoding) ? 
         _value.force_encoding(Encoding::UTF_8) : _value
    end
    alias_method_chain :normalize_parameters, :force_encoding
  end
end