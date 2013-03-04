class Luma
  
  attr_reader :path, :cmd
  
  def initialize(path)
    @path = path
    @cmd = nil
  end
  
  def command
    #convert sunny.jpeg -colorspace gray -format "%[fx:100*mean]%%" info:
    @cmd = Cocaine::CommandLine.new("convert", "#{@path} -colorspace gray -format '%[fx:100*mean]%%' info:")
  end
    
  def to_i
    command.run.sub(%r[%\s],'').to_i
  end  
  
  
end