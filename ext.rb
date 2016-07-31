# list all extentions
#
#


# find log line format
# -rw-r--r--  1 ringo  staff  334  7  9  2011 /Users/ringo/wise9mmo/trial/node/http.js

def parse(l)
  tks = l.split(" ")
#  print l, "\n"
  size = tks[4].to_i
  name = tks[8..-1].join(" ")
  tks = l.split(".")
  ext = nil
  if tks.size >= 2 and tks[-1].length < 6 then
    ext = tks[-1]
  end
#  print "size:", size, "\n"
#  print "name:", name, "\n"
#  print "ext:", ext,"\n"
  return [name,size,ext]
end



infile = "find.out"

extcounts = Hash.new(0)
extsizes = Hash.new(0)
extlists = Hash.new()  # hash table of an array of file names
extlogs = Hash.new() # hash table of an array of find outputs
filesizes = Hash.new()

cnt=0
File.open(infile).read.split("\n").each do |line|
  name,size,ext = parse(line)
  next if ext==nil
  extcounts[ext] += 1 
  extsizes[ext] += size 
  extlists[ext] = [] if extlists[ext] == nil
  extlists[ext].push(name)
  extlogs[ext] = [] if extlogs[ext] == nil
  extlogs[ext].push(line)
  filesizes[name] = size
  
  cnt+=1
  print(".") if cnt%10000==0

#  break if cnt == 300000 
end

exts = extsizes.keys
exts.sort! do |a,b|
  avg_a = extsizes[a] / extcounts[a]
  avg_b = extsizes[b] / extcounts[b]
  avg_a <=> avg_b
end
  
exts.each do |e|
#  print extsizes[e], " ", extcounts[e], " ", e, "\n"
  avg = extsizes[e] / extcounts[e]
  print extsizes[e], " ", extcounts[e], " ", extlists[e].size, " ", avg, " ", e, "\n" 
end


to_check = [ "JPG", "jpg", "MOV", "pdf", "doc","docx","png","PNG", "m4a","wav","WAV","mp4","mov","MP4","flv","avi","AVI","FLV" ]

$skips = [ "Applications" ]

def to_skip(fn)
  $skips.each do |sk|
    return true if fn.include?(sk)
  end
  return false
end

to_check.each do |e|
  print "dupcheck for #{e}:\n"
  
  files = extlists[e]
  next if !files
  
  files.each do |f_a|
    next if to_skip(f_a)
    
    sz_a = filesizes[f_a]
    print "hoge: #{f_a}\n" if sz_a == nil
    next if sz_a < 1024*16
    
    files.each do |f_b|
      sz_b = filesizes[f_b]
      if f_a != f_b and sz_a == sz_b then
        fa=f_a.sub(" ","\\ ")
        fb=f_b.sub(" ","\\ ")
        print "#{sz_a} #{fa} #{fb}\n"
        break
      end
    end
  end
  print "done\n"
end