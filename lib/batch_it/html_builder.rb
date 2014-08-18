module BatchIt
  class HtmlBuilder

    def copy_html_file(output_path)
      Nokogiri::HTML(File.open(output_path + '/example.html'))
    end

    def extract_destination_name(destination)
      destination.attributes['title-ascii'].value
    end

    def set_title_h1(html_obj, destination_name)
      header = html_obj.at_css 'h1'
      header.content = 'Lonely Planet: ' + destination_name
    end

    def update_secondary_navigation(html_obj, destination_name)
      sub_header = html_obj.at_css '.secondary-navigation a'
      sub_header.content = destination_name
    end

    def add_taxonomy_navigation(html_obj, taxonomy, output_path)
      navigation = html_obj.at_css '#sidebar .inner'
      navigation.content = ''
      ul = Nokogiri::XML::Node.new 'ul', html_obj
      navigation.add_child(ul)

      node_type = 'li'
      taxonomy_blob = taxonomy.xpath('//taxonomy//node//node_name')
      blob_html_navigation_builder(taxonomy_blob, html_obj, ul, node_type, output_path)
    end

    def add_destination_body_text(html_file, destination)
      content_container = html_file.at_css '#main .inner'
      content_container.content = ''
      h4 = Nokogiri::XML::Node.new 'h4', html_file

      if destination.css('history')
        blob = destination.css('history').text
        h4.content = 'History'
        content_container.add_child(h4)
      end
      if blob.length == 0
        blob = destination.css('overview').text
        h4.content = 'Overview'
        content_container.add_child(h4)
      end

      history_blob = blob.split(/[\n]+/)

      node_type = 'p'
      blob_html_builder(history_blob, html_file, h4, node_type)
    end

    def blob_html_builder(obj, html_obj, parent_node, node_type)
      obj.each do |node|
        if node.length > 0
          p = Nokogiri::XML::Node.new node_type, html_obj
          p.content = node
          parent_node.add_next_sibling(p)
        end
      end
    end

    def blob_html_navigation_builder(obj, html_obj, parent_node, node_type, output_path)
      obj.reverse.each do |node|
        p = Nokogiri::XML::Node.new node_type, html_obj
        a_href = Nokogiri::XML::Node.new 'a', html_obj
        a_href.content = node.text
        a_href['href'] = set_navigation_link(node, output_path)
        parent_node.add_next_sibling(p)
        p.add_child(a_href) if a_href
      end
    end

    def set_navigation_link(node, output_path)
      file_manager = BatchIt::FileManager.new
      name = file_manager.format_name(node.text)
      file = 'file://'
      dir = Dir.pwd
      file.concat(dir).concat("/#{output_path}").concat("/#{name}.html")
    end
  end
end