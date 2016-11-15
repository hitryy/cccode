class CodeController < ApplicationController
  include CodeManagement

  attr_accessor :code

  def index
    if request.post?
      @code = params[:code]
      if (@code.blank?)
        flash[:error] = 'Source code is empty!'
        #redirect_to :back
      else
        get_compiled_file(@code)
      end
    end
  end

  private

  def get_compiled_file(code)
    Dir.mktmpdir do |dir|
      file_path = make_file_with_source_code dir, code
      path = compile_file file_path, dir
      send_data path
    end
  end
end
