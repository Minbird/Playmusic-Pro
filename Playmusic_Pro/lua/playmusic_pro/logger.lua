PlayMP.Logger = {}
PlayMP.Logger.levels = {}
PlayMP.Logger.levels.info = Color(255,255,255)
PlayMP.Logger.levels.warn = Color(255,100,0)
PlayMP.Logger.levels.error = Color(255,0,0)
PlayMP.Logger.levels.debug = Color(0,255,255)

PlayMP.Logger.log = function( str, level )
    PlayMP.system.print( str, level )
end