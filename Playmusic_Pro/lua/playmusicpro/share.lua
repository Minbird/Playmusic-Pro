
-- logger level
-- 0 - do not print anything
-- 1 - print error level logs
-- 2 - and print warn level logs
-- 3 - and print debug level logs
PlayMP.logger_level = 1


-- just adding [Playmusic Pro]
PlayMP.system.print = function( str, level )
    print("[Playmusic Pro] " .. level .. " - " .. tostring(str))
end

CreateConVar( "playmp_queue", "0", {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Limit number for media. If set to 0, no limit.", 0 )
CreateConVar( "playmp_queue_user", "0", {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Limit number for media per user. If set to 0, no limit.", 0 )
CreateConVar( "playmp_media_time", "0", {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Time limit for media(sec). If set to 0, no limit.", 0 )
	
CreateConVar( "playmp_MinPerForSkip", "0", {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Minimum percentage of votes to skip media. (30~100)", 30, 100 )