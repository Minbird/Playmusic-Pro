
PlayMP.Poly = {}

function PlayMP.AddPolyData( uni, data )

	table.insert( PlayMP.Poly, {Data=data,Uni=uni} )
	
end

function PlayMP.GetPoly(uni)
	
	for k, v in pairs(PlayMP.Poly) do
		if v.Uni == uni then
			return v.Data
		end
	end
	
	error("Request With Wrong PolyName: " .. uni)
	
end

PlayMP.AddPolyData( "TriangleToRight30", {
	{ x = 6, y = 5 },
	{ x = 22, y = 15 },
	{ x = 6, y = 25 }
} )

PlayMP.AddPolyData( "TriangleToRight30_2", {
	{ x = 6, y = 5 },
	{ x = 23, y = 15 },
	{ x = 6, y = 25 }
} )