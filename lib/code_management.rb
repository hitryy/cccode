module CodeManagement
  def make_file_with_source_code(dir, code)
    file = File.open("#{dir}/main.c", 'w')
    file.write code
    file_path = file.path
    file.close

    file_path
  end

  def compile_file(file_path, dir, arguments = nil)
    `gcc #{file_path}`
    compiled_file_path = dir + '/a.out'
    compiled_file_path
  end
end