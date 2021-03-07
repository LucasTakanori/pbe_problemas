require 'ruby-nfc'
require 'logger'

$logger = Logger.new(STDOUT)

def p(str)
  $logger.debug str
end

readers = NFC::Reader.all

# The order of tag types in poll arguments defines priority of tag types
puts "Esperant targeta"
readers[0].poll(IsoDep::Tag, Mifare::Classic::Tag, Mifare::Ultralight::Tag) do |tag|
  begin
    tagstr = "#{tag}"[0..8].upcase
    puts "Targeta llegida UID: #{tagstr}"
    puts "Esperant targeta"

  rescue Exception => e
    p e
  end
end
