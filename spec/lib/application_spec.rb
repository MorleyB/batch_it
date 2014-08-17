require 'spec_helper'
require 'batch_it/application'
require 'batch_it/file_manager'
require 'batch_it/html_builder'
require 'pry'

RSpec.describe BatchIt::Application do
  let(:STDIN) {
    [ 'destinations.xml',
      'taxonomy.xml',
      'some_output_path'
    ]
  }

  let(:invalid_arguments) {
    [ 'destinations.rb',
      'some_path'
    ]
  }

  let(:output_path) { 'temp' }
  let(:destinations) { [ 'first' ] }
  let(:taxonomy) { 'links' }

  before do
    allow_any_instance_of(BatchIt::Application).to receive(:parse_options).and_return(STDIN)
    @application = BatchIt::Application.new(STDIN)
  end

  describe "#initialize" do
    context "with valid arguments" do
      it "executes #parse_options" do
        expect(@application).to have_received(:parse_options).with(STDIN)
      end

      it "creates a new instance of HtmlBuilder" do
        expect(@application.instance_variable_get(:@html_builder)).to be_instance_of(BatchIt::HtmlBuilder)
      end

      it "creates a new instance of FileManager" do
        expect(@application.instance_variable_get(:@file_manager)).to be_instance_of(BatchIt::FileManager)
      end

      it "sets an instance variable for destinations" do
        expect(@application).to respond_to(:destinations)
      end

      it "sets an instance variable for taxonomy" do
        expect(@application).to respond_to(:taxonomy)
      end

      it "sets an instance variable for output_path" do
        expect(@application).to respond_to(:output_path)
      end
    end
  end

  describe "#run" do
    before do
      @application.instance_variable_set(:@output_path, output_path)
      @application.instance_variable_set(:@destinations, destinations)
      @application.instance_variable_set(:@taxonomy, taxonomy)
      @file_manager = @application.instance_variable_get(:@file_manager)
      @html_builder = @application.instance_variable_get(:@html_builder)
    end

    it "calls #setup_output_directory" do
      expect(@file_manager).to receive(:setup_output_directory).with(output_path)
      @application.run
    end

    context "for each destination" do
      it "calls #add_sample_html_to_output_directory" do
        expect(@html_builder).to receive(:add_sample_html_to_output_directory).exactly(1).times
        @application.run
      end

      it "sets an instance variable for the sample html file" do
        expect(@html_builder).to receive(:copy_html_file).with(output_path)
        @application.run
      end

      it "calls #extract_destination_name" do
        expect(@html_builder).to receive(:extract_destination_name).with(destinations[0])
        @application.run
      end

      it "calls #set_title_h1" do
        allow(@html_builder).to receive(:copy_html_file).with(output_path).and_return('html_obj')
        allow(@html_builder).to receive(:extract_destination_name).with(destinations[0]).and_return('Cambodia')
        expect(@html_builder).to receive(:set_title_h1).with('html_obj', 'Cambodia')
        @application.run
      end

      it "calls #update_secondary_navigation" do
        allow(@html_builder).to receive(:copy_html_file).with(output_path).and_return('html_obj')
        allow(@html_builder).to receive(:extract_destination_name).with(destinations[0]).and_return('Cambodia')
        expect(@html_builder).to receive(:update_secondary_navigation).with('html_obj', 'Cambodia')
        @application.run
      end

      it "calls #add_taxonomy_navigation" do
        allow(@html_builder).to receive(:copy_html_file).with(output_path).and_return('html_obj')
        expect(@html_builder).to receive(:add_taxonomy_navigation).with('html_obj', taxonomy)
        @application.run
      end

      it "calls #add_destination_body_text" do
        allow(@html_builder).to receive(:copy_html_file).with(output_path).and_return('html_obj')
        expect(@html_builder).to receive(:add_destination_body_text).with('html_obj', destinations[0])
        @application.run
      end

      it "calls #write_to_file" do
        allow(@html_builder).to receive(:copy_html_file).with(output_path).and_return('html_obj')
        expect(@file_manager).to receive(:write_to_file).with(output_path, 'html_obj')
        @application.run
      end

      it "calls #rename_sample_html" do
        allow(@html_builder).to receive(:extract_destination_name).with(destinations[0]).and_return('Cambodia')
        expect(@file_manager).to receive(:rename_sample_html).with(output_path, 'Cambodia')
        @application.run
      end

      it "calls #report_progress" do
        expect(@application).to receive(:report_progress)
        @application.run
      end
    end
  end

  describe "#report_progress" do
    it "puts a message to console" do
      destinations << 'second'
      @application.instance_variable_set(:@output_path, output_path)
      expect(STDOUT).to receive(:puts).with("BatchIt complete! Generated HTML files for:(first, second) can be found in the #{output_path} Directory.")
      @application.report_progress(destinations)
    end
  end
end