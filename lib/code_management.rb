module CodeManagement
  require 'open3'
  require 'timeout'

  private

  # make file with source code, return full path to this file in unique temp directory
  def make_file_with_source_code(dir, code, file_extension)
    file = File.open("#{dir}/main#{file_extension}", 'w')
    file.write code
    file_path = file.path
    file.close

    file_path
  end

  # compile file with source code, return hash with full path, stderr (if there is no problems it's empty), exit code
  # (if != 0 there are some problems), timeout expired - bool value (true, if compilation take more than 10 seconds)
  # then stopping compilation
  def compile_file(dir, command)
    stdout, stderr, status = nil
    timeout_expired = false

    begin
      Timeout::timeout(10) do
        stdout, stderr, status = Open3.capture3(command)
      end
    rescue TimeoutError
      timeout_expired = true
    end

    {path: "#{dir}/out", stderr: stderr, exitcode: status.exitstatus, timeout_expired: timeout_expired}
  end

  # TODO: добавить для остальных языков + варианты под линукс/винду
  # COMPILING COMMANDS FOR DIFFERENT LANGUAGES

  # compile command for c++ language
  def cpp_compiling_command(dir, file_path)
    "g++ #{file_path} -o #{dir}/out"
  end

  # compile command for c language
  def c_compiling_command(dir, file_path)
    "gcc #{file_path} -o #{dir}/out"
  end

  # compile command for cpp (windows) language
  def cpp_windows_compiling_command(dir, file_path)
    "i686-w64-mingw32-c++ #{file_path} -o #{dir}/out.exe"
  end
end