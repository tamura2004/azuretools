require "yaml"
DEBUG = true

class Azure
  def initialize(params)
    @params = params
  end

  def self.exec(params)
    new(params).run
  end

  def run
    case @params
    when String
      if DEBUG
        p @params
      else
        puts %x(params)
      end

    when Array
      @params.each do |param|
        Azure.exec(param)
      end

    when Hash
      cmds = @params.map do |key, value|
        case key.to_s
        when "cmd"
          value
        when "n","g"
          "-#{key} #{value}"
        else
          "--#{key} #{value}"
        end
      end
      Azure.exec(cmds.join(" "))
    end
  end
end

Azure.exec YAML.load(<<EOD)
-
  cmd: az vm list
  n: hoge
  g: fuga
  moga: moge
- az vm list
EOD
