# Need to add to application.rb (or initializers/assets.rb depends on the version or rails you use) the following line
# config.assets.paths << Rails.root.join('tmp', 'compiled_css')

module Customizable
  attr_reader :compiled

  def filename
    self.to_param
  end

  def self.default_setting
    file = File.open(File.join(Rails.root, 'app', 'assets', 'stylesheets', '_variables.scss'))
    default = {}
    file.each_line do |line|
      if line.match /\$(.*):(.*) !default;/
        default[$1.strip] = $2.gsub('!default', '').strip;
      end
    end
    default.with_indifferent_access
  end

  private

  def create_asset
    body = ERB.new(File.read(File.join(Rails.root, 'app', 'assets', 'stylesheets', '_template.scss.erb'))).result(binding)
    tmp_themes_path = File.join(Rails.root, 'tmp', 'compiled_css')

    FileUtils.mkdir_p(tmp_themes_path) unless File.directory?(tmp_themes_path)
    File.open(File.join(tmp_themes_path, "#{filename}.scss"), 'w') { |f| f.write(body) }

    env = if Rails.application.assets.is_a?(Sprockets::Index)
      Rails.application.assets.instance_variable_get('@environment')
    else
      Rails.application.assets
    end

    env.find_asset(filename)
  end

  def compiled_css
    Sass::Engine.new(create_asset.body, {
      syntax: :scss,
      style: Rails.env.development? ? :nested : :compressed,
      cache: false,
      read_cache: false
    }).render
  end

  def compile_css
    @compiled = true
    require 'tempfile'

    puts "="*40
    puts settings.collect &:value
    puts "="*40

    file = Tempfile.open [filename, ".css"]
    begin
      file.write compiled_css
      file.flush
      self.stylesheet = file
    ensure
      file.close
      file.unlink
    end
  end
end
