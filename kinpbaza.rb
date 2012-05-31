require 'json'

def search_by_file(path)
  require 'digest/sha1'
  hash = Digest::SHA1.hexdigest(File.new(path).readpartial(1024 * 1024))
  make_request "/films/search-by-file", {:filepath => path, :hash => hash}
end

def make_request(path, params, method="GET")
  require "open-uri"
  uri = URI.escape("http://api.kinobaza.tv"+path+"?"+params.map { | key, value | "#{key}=#{value}" }.join("&"))

  JSON.parse(open(uri.to_s).read)

end
#`ls -RB /media/ | grep -i '.\(avi\|mkv\)$'`
IO.popen('find /media/ /home/ \( ! -regex ".*/\..*" \) -type f | grep  -i ".\(avi\|mkv\)$"').each_line {|s|       
  puts s + search_by_file(s.strip).map { | key, value | "#{key}: #{value}" }.join(" ")
  sleep 5  
}

