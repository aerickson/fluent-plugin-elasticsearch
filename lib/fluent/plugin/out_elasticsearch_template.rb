module Fluent::ElasticsearchOutputTemplate

  def get_template
    if !File.exists?(@template_file)
      raise "If you specify a template_name you must specify a valid template file (checked '#{@template_file}')!"
    end
    file_contents = IO.read(@template_file).gsub(/\n/,'')
    template = JSON.parse(file_contents)
    return template
  end

  def template_exists?(name)
    client.indices.get_template(:name => name)
    return true
  rescue
    return false
  end

  def template_put(name, template)
    client.indices.put_template(:name => name, :body => template)
  end

  def template_install(name, template_file)
    if !template_exists?(name)
      template_put(name, get_template())
      log.info("Template configured, but no template installed. Installed '#{name}' from #{template_file}.")
    else
      log.info("Template configured and already installed.")
    end
  end

end
