class CodeController < ApplicationController
  include CodeManagement

  attr_accessor :code
  attr_accessor :language
  attr_accessor :log
  attr_accessor :code_to_display
  attr_accessor :code_link

  # index action
  def index
    if request.post?
      @log = nil
      @code = params[:code_editor]
      @language = params[:language]

      if (@code.blank?)
        @log = 'Source code is empty!'
      elsif (@language.blank?)
        @log = 'Please, choose language!'
      else
        if (params[:save])
          save
        else
          make_and_send_compiled_file(@code, @language)
        end
      end
    end
  end

  # show code, based on id (unique_link)
  def show
    code_temp = Code.find_by(unique_link: params[:id])

    if (code_temp)
      @code_to_display = code_temp.source_code
    else
      render 'error_code_not_found'
    end
  end

  private

  # save code in db
  def save
    date = Time.now
    unique_string = SecureRandom.hex(4)
    code_temp = Code.find_by(unique_link: unique_string)

    if (code_temp)
      while (code_temp[:unique_string] == unique_string)
        unique_string = SecureRandom.hex(4)
      end
    end

    code = Code.new(source_code: @code, unique_link: unique_string, datetime_of_creation: date)
    code.save
    @code_link = code[:unique_link]
  end

  # make and send compiled file, or if there are some problems, make flash[:error] and stopping further implementation
  def make_and_send_compiled_file(code, language)
    Dir.mktmpdir do |dir|
      compiling_hash_info = get_compiled_file(dir, code, language)

      if (compiling_hash_info[:compile_file][:timeout_expired])
        @log = 'Timeout expired (10 seconds >)'
        return
      end

      if (compiling_hash_info[:compile_file][:exitcode] == 0)
        send_compiled_file(compiling_hash_info[:compile_file][:path], compiling_hash_info[:is_compilated_for_windows])
        return
      else
        @log = "#{compiling_hash_info[:compile_file][:stderr]}. Exit code: #{compiling_hash_info[:compile_file][:exitcode]}"
      end
    end
  end

  # get compiled file, first - make file with source code, then try to compile
  def get_compiled_file(dir, code, language)
    command = nil
    is_compiled_for_windows = false;

    case language
      when 'C++'
        command = cpp_compiling_command(dir, make_file_with_source_code(dir, code, '.cpp'))
      when 'C'
        command = c_compiling_command(dir, make_file_with_source_code(dir, code, '.c'))
      when 'C++ (Windows)'
        command = cpp_windows_compiling_command(dir, make_file_with_source_code(dir, code, '.cpp'))
        is_compiled_for_windows = true
    end

    {compile_file: compile_file(dir, command), is_compilated_for_windows: is_compiled_for_windows}
  end

  # send compiled file
  def send_compiled_file(compiled_file_path, is_compiled_for_windows = false)
    execute_file_extension = nil

    if (is_compiled_for_windows)
      compiled_file_path = compiled_file_path + '.exe'
      execute_file_extension = 'out.exe'
    else
      execute_file_extension = 'out'
    end

    File.open("#{compiled_file_path}", 'r') do |f|
      send_data(f.read, type: 'application/bin', filename: execute_file_extension)
    end
  end
end
