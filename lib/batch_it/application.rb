module BatchIt
  class Application

    attr_reader :destinations, :taxonomy, :output_path

    def initialize(argv)
      @destinations, @taxonomy, @output_path = parse_options(argv)
      @html_builder = BatchIt::HtmlBuilder.new
      @file_manager = BatchIt::FileManager.new
    end

    def run
      @file_manager.setup_output_directory(@output_path)
      all_destinations = []

      @destinations.each do |destination|
        @html_builder.add_sample_html_to_output_directory

        html_file = @html_builder.copy_html_file(@output_path)
        destination_name = @html_builder.extract_destination_name(destination)
        all_destinations << destination_name

        @html_builder.set_title_h1(html_file, destination_name)
        @html_builder.update_secondary_navigation(html_file, destination_name)
        @html_builder.add_taxonomy_navigation(html_file, @taxonomy)
        @html_builder.add_destination_body_text(html_file, destination)

        @file_manager.write_to_file(@output_path, html_file)
        @file_manager.rename_sample_html(output_path, destination_name)
      end

      report_progress(all_destinations)
    end

    def report_progress(all_destinations)
      destinations = all_destinations.join(", ")
      puts "BatchIt complete! Generated HTML files for:(#{destinations}) can be found in the #{@output_path} Directory."
    end

    def parse_options(argv)
      parser = OptionParser.new
      parser.on('-h', '--help') {
        puts 'Application requires 3 path for a destinations.xml, taxonomy.xml and an output path.'
        exit
      }
      parser.parse(argv)

      begin
        argv.each do |arg|
          if !arg.include?('xml')
            @output_path = arg
          else
            doc = Nokogiri::XML(File.open(arg))

            case doc.children[0].name
            when 'destinations'
              @destinations = doc
            when 'taxonomies'
              @taxonomy = doc
            end
          end
        end

        raise 'destination.xml is required' if !@destinations
        raise 'taxonomy.xml is required' if !@taxonomy
        raise 'An output path for the generated html files is required' if !@output_path
      rescue Exception => ex
        puts "#{ex.message()}. Please use -h or --h for usage instructions."
        exit(1)
      end
    end

  end
end
