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
filesizes = Hash.new()

cnt=0
File.open(infile).read.split("\n").each do |line|
  name,size,ext = parse(line)
  next if ext==nil
  extcounts[ext] += 1 
  extsizes[ext] += size 
  extlists[ext] = [] if extlists[ext] == nil
  extlists[ext].push(name)
  filesizes[name] = size
  
  cnt+=1
  print(".") if cnt%10000==0

  break if cnt == 200000 
end

exts = extsizes.keys
exts.sort! do |a,b|
  extsizes[a] <=> extsizes[b]
end
  
exts.each do |e|
#  print extsizes[e], " ", extcounts[e], " ", e, "\n"
  avg = extsizes[e] / extcounts[e]
  print extsizes[e], " ", extcounts[e], " ", extlists[e].size, " ", avg, " ", e, "\n" 
end


