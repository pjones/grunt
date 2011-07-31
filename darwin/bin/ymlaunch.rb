#!/usr/bin/env ruby

################################################################################
require('yaml')
require('erb')
require('ostruct')
require('optparse')
require('fileutils')
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
  def user
    @attributes['UserName']
  end
  
  ##############################################################################
  def valid?
    @errors.clear
    @errors << "type must be one of #{TYPES.join(', ')}" unless TYPES.include?(@type)
    @errors << "missing UserName key" if @type == 'Agent' and user.nil?
    @errors.empty?
  end
  
  ##############################################################################
  def path
    dir = 
      case @type
      when 'Agent'
        File.expand_path("~#{user}/Library/LaunchAgents")
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
    :list   => false,   
    :xml    => false,   
    :load   => false,   
    :remove => false, 
    :debug  => nil,
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
      p.on('--load', 'Load plist files into launchd') {|l| options.load = l}
      p.on('--remove', 'Unload and remove plist files') {|r| options.remove = r}
      p.on('--debug=DIR', 'Enable job debugging, place files in DIR') {|d| options.debug = d}
    end.permute!(arguments)
    
    if arguments.size != 1 or !File.exist?(arguments.first)
      raise("must give a single YAML file")
    end
    
    load_yaml_file(arguments.first)
    
    if options.debug
      if !File.exist?(options.debug)
        raise("debug directory #{options.debug} doesn't exist")
      end

      @jobs.each do |job|
        file = File.expand_path(File.join(options.debug, "#{job.label}.debug"))
        job.attributes['StandardOutPath']   = file
        job.attributes['StandardErrorPath'] = file
        job.attributes['Debug']             = true
      end
    end
  end
  
  ##############################################################################
  def run
    if options.list
      $stdout.puts(@jobs.map {|j| j.path}.join("\n"))
    elsif options.xml
      @jobs.each {|j| j.xml.write($stdout)}
    elsif options.load
      @jobs.each do |job|
        FileUtils.mkdir_p(File.dirname(job.path))
        File.open(job.path, 'w') {|f| job.xml.write(f)}
        FileUtils.chmod(0600, job.path)
        FileUtils.chown(job.user, nil, job.path) if job.user
        system('launchctl', 'load', job.path)
      end
    elsif options.remove
      @jobs.each do |job|
        if File.exist?(job.path)
          system('launchctl', 'unload', job.path)
          File.unlink(job.path)
        end
      end
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
