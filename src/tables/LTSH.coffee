r = require 'restructure'

# Linear Threshold table
# Records the ppem for each glyph at which the scaling becomes linear again, 
# despite instructions effecting the advance width
module.exports = new r.Struct
  version:    r.uint16
  numGlyphs:  r.uint16
  yPels:      new r.Array(r.uint8, 'numGlyphs')