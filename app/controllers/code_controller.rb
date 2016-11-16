class CodeController < ApplicationController
  include CodeManagement

  attr_accessor :code
  attr_accessor :language
  attr_accessor :log
  # index action
  def index
    if request.post?
      @code = params[:code_editor]
      @language = params[:language]
      if (@code.blank?)
        #flash[:error] = 'Source code is empty!'
        #render :index
        @log = 'Source code is empty!'
      elsif (@language.blank?)
        #flash[:error] = 'Please, choose language!'
        @log = 'Please, choose language!'
      else
        make_and_send_compiled_file(@code, @language)
      end
    end
  end

  private

  # make and send compiled file, or if there are some problems, make flash[:error] and stopping further implementation
  def make_and_send_compiled_file(code, language)
    Dir.mktmpdir do |dir|
      compiling_hash_info = get_compiled_file(dir, code, language)

      if (compiling_hash_info[:timeout_expired])
        @log = 'Timeout expired (10 seconds >)'
        return
      end

      if (compiling_hash_info[:exitcode] == 0)
        send_compiled_file(compiling_hash_info[:path])
        return
      else
        @log = "#{compiling_hash_info[:stderr]}. Exit code: #{compiling_hash_info[:exitcode]}"
      end
    end
  end

  # get compiled file, first - make file with source code, then try to compile
  def get_compiled_file(dir, code, language)
    command = nil
    file_path = make_file_with_source_code(dir, code)

    case language
      when 'C'
        command = c_compiling_command(dir, file_path)
      when 'C++'
        command = cpp_compiling_command(dir, file_path)
    end

    compile_file(dir, command)
  end

  # send compiled file
  def send_compiled_file(compiled_file_path)
    File.open("#{compiled_file_path}", 'r') do |f|
      send_data(f.read, type: 'application/bin', filename: 'out')
    end
  end
end
