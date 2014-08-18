require 'spec_helper'
require 'batch_it/application'
require 'batch_it/file_manager'
require 'batch_it/html_builder'
require 'fakefs/safe'
require 'pry'


RSpec.describe BatchIt::FileManager do

  let(:file_manager) { BatchIt::FileManager.new }
  let(:output_path) { 'temp' }


  before do
    FakeFS.activate!
  end

  describe "#setup_output_directory" do
    it "creates new directory from given path" do
      expect(Dir).to receive(:mkdir).with(output_path)
      file_manager.setup_output_directory(output_path)
    end

    it "creates new subdirectory for static assets" do
      expect(FileUtils).to receive(:cp_r)
      file_manager.setup_output_directory(output_path)
    end
  end

  describe "#write_to_file" do
    it "writes the data to the file" do
      raw_html = double('html')
      path = output_path + '/example.html'
      expect(File).to receive(:open).with(path, 'w')
      file_manager.write_to_file(output_path, raw_html)
    end
  end

  describe "#rename_sample_html" do
    it "renames the file to match the destination name" do
      expect(File).to receive(:rename)
      file_manager.rename_sample_html(output_path, 'Bali')
    end
  end

  describe "#format_name" do
    it "lowercases the name and replaces white space with underscores" do
      destination_name = 'Bali_Asia'
      expect(file_manager.format_name(destination_name)).to eq('bali_asia')
    end
  end

  after do
    FakeFS::FileSystem.clear
    FakeFS.deactivate!
  end

end