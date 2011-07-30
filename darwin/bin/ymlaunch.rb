#!/usr/bin/env ruby

################################################################################
require('yaml')
require('erb')
require('ostruct')
require('optparse')
require('rexml/document')

################################################################################
class Job
  
  ##############################################################################
  TYPES = %w(Agent Daemon)
  
  ##############################################################################
  PLIST_DOCTYPE = [
    'plist',
    'PUBLIC',
    '-//Apple Computer//DTD PLIST 1.0//EN',
    'http://www.apple.com/DTDs/PropertyList-1.0.dtd',
  ]
  
  ##############################################################################
  attr_reader(:label)
  attr_reader(:attributes)
  attr_reader(:errors)
  
  ##############################################################################
  def initialize (label, attributes)
    @label = label
    @attributes = attributes
    @type = attributes.delete('Type')
    @attributes['Label'] = @label
    @errors = []
  end
  
  ##############################################################################
  def valid?
    @errors.clear
    @errors << "type must be one of #{TYPES.join(', ')}" unless TYPES.include?(@type)
    @errors << "missing UserName key" if @type == 'Agent' and !@attributes.has_key?('UserName')
    @errors.empty?
  end
  
  ##############################################################################
  def path
    dir = 
      case @type
      when 'Agent'
        File.expand_path("~#{@attributes['UserName']}/Library/LaunchAgents")
      when 'Daemon'
        '/Library/LaunchDaemons'
      else
        raise("WTF, #{@type} not handled")
      end
    
    File.join(dir, "#{@label}.plist")
  end
  
  ##############################################################################
  def xml
    doc  = REXML::Document.new
    doc << REXML::XMLDecl.new
    doc << REXML::DocType.new(PLIST_DOCTYPE)
    write_value(doc.add_element('plist', 'version' => '1.0'), @attributes)
    doc
  end
  
  ##############################################################################
  private
  
  ##############################################################################
  def write_value (parent, value)
    case value
    when true, false
      parent.add_element(value.to_s)
    when String
      parent.add_element('string').text = value
    when Fixnum
      parent.add_element('integer').text = value.to_s
    when Float
      parent.add_element('real').text = value.to_s
    when Array
      array = parent.add_element('array')
      value.each {|v| write_value(array, v)}
    when Hash
      dict = parent.add_element('dict')
      value.each do |k,v| 
        dict.add_element('key').text = k
        write_value(dict, v)
      end
    end
  end
end

################################################################################
class Command
  
  ##############################################################################
  DEFAULT_OPTIONS = {
    :list => false,
    :xml  => false,
  }
  
  ##############################################################################
  attr_reader(:options)
  
  ##############################################################################
  def initialize (arguments)
    @options = OpenStruct.new(DEFAULT_OPTIONS)
    @jobs = []
    
    OptionParser.new do |p|
      p.on('-h', '--help', 'This message') {$stdout.puts(p); exit}
      p.on('--list', 'List files that will be generated') {|l| options.list = l}
      p.on('--xml', 'Dump XML to STDOUT') {|x| options.xml = x}
    end.permute!(arguments)
    
    if arguments.size != 1 or !File.exist?(arguments.first)
      raise("must give a single YAML file")
    end
    
    load_yaml_file(arguments.first)
  end
  
  ##############################################################################
  def run
    if options.list
      $stdout.puts(@jobs.map {|j| j.path}.join("\n"))
    elsif options.xml
      @jobs.each {|j| j.xml.write($stdout)}
    else
      raise("try using --help")
    end
  end
  
  ##############################################################################
  private
  
  ##############################################################################
  def load_yaml_file (file)
    data = YAML.load(ERB.new(File.read(file)).result)
    
    raise("yaml file should contain a hash") unless data.is_a?(Hash)
    raise("each entry in yaml file should be a hash") unless data.values.all? {|e| e.is_a?(Hash)}
    
    @jobs = data.map {|label, attrs| Job.new(label, attrs)}
    bad = @jobs.select {|j| !j.valid?}
    
    if !bad.empty?
      bad.each do |job|
        $stderr.puts("job #{job.label} is invalid:")
        job.errors.each {|e| $stderr.puts("\t#{e}")}
      end
      
      raise("invalid daemons or agents")
    end
  end
end

################################################################################
begin
  Command.new(ARGV).run
rescue RuntimeError => e
  $stderr.puts($0 + ": ERROR: #{e}")
  exit(1)
end
