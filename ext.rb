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

exts = Hash.new(0)
extsizes = Hash.new(0)

File.open(infile).read.split("\n").each do |line|
  name,size,ext = parse(line)
  exts[ext] += 1 if ext
  extsizes[ext] += size
end

exts.keys.each do |e|
  print extsizes[e], " ", exts[e], " ", e, "\n"
end

