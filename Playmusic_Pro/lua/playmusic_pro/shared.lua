

	CreateConVar( "playmp_queue", "0", {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Limit number for media. If set to 0, no limit.", 0 )
	CreateConVar( "playmp_queue_user", "0", {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Limit number for media per user. If set to 0, no limit.", 0 )
	CreateConVar( "playmp_media_time", "0", {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Time limit for media(sec). If set to 0, no limit.", 0 )
	
	CreateConVar( "playmp_MinPerForSkip", "0", {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Minimum percentage of votes to skip media. (30~100)", 30, 100 )

	--CreateClientConVar( "playmp_queue", "0", true, false, "Limit number for media. If set to 0, no limit.", 0 )
	--CreateClientConVar( "playmp_queue_user", "0", true, false, "Limit number for media per user. If set to 0, no limit.", 0 )
	--CreateClientConVar( "playmp_media_time", "0", true, false, "Time limit for media(sec). If set to 0, no limit.", 0 )
