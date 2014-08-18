require 'spec_helper'
require 'batch_it/application'
require 'batch_it/file_manager'
require 'batch_it/html_builder'
require 'pry'
require 'nokogiri'

RSpec.describe BatchIt::Application do
  let(:STDIN) {
    [ 'data/destinations.xml',
      'data/taxonomy.xml',
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

  describe "#report_progress" do
    it "puts a message to console" do
      destinations << 'second'
      @application.instance_variable_set(:@output_path, output_path)
      expect(STDOUT).to receive(:puts).with("BatchIt complete! \n Generated HTML files for: \n first,\nsecond\n HTML files can be found in the #{output_path} directory.")
      @application.report_progress(destinations)
    end
  end
end