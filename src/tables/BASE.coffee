r = require 'restructure'
{ScriptList, FeatureList, LookupList, Coverage, ClassDef, Device} = require './opentype'

BaseCoord = new r.VersionedStruct r.uint16,
  1: # Design units only
    coordinate:   r.int16   # X or Y value, in design units
    
  2: # Design units plus contour point
    coordinate:     r.int16   # X or Y value, in design units
    referenceGlyph: r.uint16  # GlyphID of control glyph
    baseCoordPoint: r.uint16  # Index of contour point on the referenceGlyph
    
  3: # Design units plus Device table
    coordinate:   r.int16                         # X or Y value, in design units
    deviceTable:  new r.Pointer(r.uint16, Device) # Device table for X or Y value

BaseValues = new r.Struct
  defaultIndex:   r.uint16  # Index of default baseline for this script-same index in the BaseTagList
  baseCoordCount: r.uint16
  baseCoords:     new r.Array(new r.Pointer(r.uint16, BaseCoord), 'baseCoordCount')
  
FeatMinMaxRecord = new r.Struct
  tag:        new r.String(4)  # 4-byte feature identification tag-must match FeatureTag in FeatureList
  minCoord:   new r.Pointer(r.uint16, BaseCoord, type: 'parent') # May be NULL
  maxCoord:   new r.Pointer(r.uint16, BaseCoord, type: 'parent') # May be NULL
  
MinMax = new r.Struct
  minCoord:           new r.Pointer(r.uint16, BaseCoord)  # May be NULL
  maxCoord:           new r.Pointer(r.uint16, BaseCoord)  # May be NULL
  featMinMaxCount:    r.uint16                            # May be 0
  featMinMaxRecords:  new r.Array(FeatMinMaxRecord, 'featMinMaxCount') # In alphabetical order

BaseLangSysRecord = new r.Struct
  tag:    new r.String(4)  # 4-byte language system identification tag
  minMax: new r.Pointer(r.uint16, MinMax, type: 'parent')

BaseScript = new r.Struct
  baseValues:         new r.Pointer(r.uint16, BaseValues) # May be NULL
  defaultMinMax:      new r.Pointer(r.uint16, MinMax)     # May be NULL
  baseLangSysCount:   r.uint16                            # May be 0
  baseLangSysRecords: new r.Array(BaseLangSysRecord, 'baseLangSysCount') # in alphabetical order by BaseLangSysTag

BaseScriptRecord = new r.Struct
  tag:      new r.String(4)  # 4-byte script identification tag
  script:   new r.Pointer(r.uint16, BaseScript, type: 'parent')
  
BaseScriptList = new r.Array(BaseScriptRecord, r.uint16)

# Array of 4-byte baseline identification tags-must be in alphabetical order
BaseTagList = new r.Array(new r.String(4), r.uint16)

Axis = new r.Struct
  baseTagList:    new r.Pointer(r.uint16, BaseTagList)  # May be NULL
  baseScriptList: new r.Pointer(r.uint16, BaseScriptList)

module.exports = new r.Struct
  version:      r.uint32                        # Version of the BASE table-initially 0x00010000
  horizAxis:    new r.Pointer(r.uint16, Axis)   # May be NULL
  vertAxis:     new r.Pointer(r.uint16, Axis)   # May be NULL