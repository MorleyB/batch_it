module BatchIt
  class FileManager

    def setup_output_directory(output_path)
      Dir.mkdir(output_path) unless File.directory?(output_path)
      FileUtils.cp_r(Dir.glob('data/static'), output_path)
    end

    def add_sample_html_to_output_directory(output_path)
      FileUtils.cp_r('data/example.html', output_path)
    end

    def write_to_file(output_path, html_file)
      file_path = output_path + '/example.html'
      File.open(file_path, 'w') {|f| f.write(html_file) }
    end

    def rename_sample_html(output_path, destination_name)
      proper_name = format_name(destination_name)
      File.rename(output_path + '/example.html', output_path + "/#{proper_name}.html")
    end

    def format_name(destination_name)
      destination_name.downcase.gsub(' ', '_')
    end
  end
end