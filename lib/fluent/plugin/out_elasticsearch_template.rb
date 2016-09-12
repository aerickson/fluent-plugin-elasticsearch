module Fluent::ElasticsearchOutputTemplate

  def get_template(template_file)
    if !File.exists?(template_file)
      raise "If you specify a template_name you must specify a valid template file (checked '#{template_file}')!"
    end
    file_contents = IO.read(template_file).gsub(/\n/,'')
    JSON.parse(file_contents)
  end

  def template_exists?(name)
    client.indices.get_template(:name => name)
    return true
  # TODO: causes error when fluent-plugin-amazonelasticseasrch uses this plugin
  #   - figure out why...
  rescue Elasticsearch::Transport::Transport::Errors::NotFound
  # rescue
    return false
  end

  def template_put(name, template)
    client.indices.put_template(:name => name, :body => template)
  end

  def template_install(name, template_file)
    if !template_exists?(name)
      template_put(name, get_template(template_file))
      log.info("Template configured, but no template installed. Installed '#{name}' from #{template_file}.")
    else
      log.info("Template configured and already installed.")
    end
  end

end
