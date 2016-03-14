module TemplaterHelper
  require 'json'

  # Constants
  TAG = Regexp.new(/<\*[^\*]*\*>/)
  START_EACH = Regexp.new(/<\* EACH|<\*EACH/)
  END_EACH = Regexp.new(/<\* ENDEACH|<\*ENDEACH/)
  EACH_CONTENT = Regexp.new(/EACH[^\*]*/)
  TAG_OPEN = "<*"

  def read_template(file_name)
    File.open(file_name, "r") do |f|
      f.readlines
    end
  end

  def read_json(file_name)
    File.open(file_name, "r") do |f|
      f.read
    end
  end

  def get_tokens(line, regex)
    line.scan(regex).to_s.split(/[\s]/)[1].split(".")
  end

  def open_write(out_file)
    File.open(out_file, "w")
  end

  def close_write(output)
    output.close
  end

  def get_files(argv)
    @json_stack = [] #json_stack keeps current working hash/array on top

    if argv.size < 3
      puts "Usage: templater arg1 arg2 arg3"
      exit
    else
      argv.each do |file_name|
        if File.extname(file_name) == ".panoramatemplate"
          @template = read_template(file_name)
        elsif File.extname(file_name) == ".json"
          @data = read_json(file_name)
          @json_stack << JSON.parse(read_json(file_name))
        elsif File.extname(file_name) == ".html"
          @outfile  = open_write(file_name)
        else
          puts "A file extension was incorrect, valid extensions are '.panoramatemplate', '.json' and '.html'"
          exit
        end
      end
    end
  end

end
