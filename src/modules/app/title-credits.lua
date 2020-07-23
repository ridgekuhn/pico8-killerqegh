function credits_init()
	music(0)

	_update = credits_update
	_draw = credits_draw
end

function credits_update()
	if(time() > 8.7) then
		title_init()
		return
	end
end

function credits_draw()
	cls()

	if(time() < 3) then
		print_centered('a', nil, -21)
		print_centered('totally non-commercial', nil, -14)
		print_centered('fan game by:', nil, -7)
		print_centered('ridgek', nil, 7)
		print_centered('𝘩𝘵𝘵𝘱𝘴://𝘳𝘪𝘥𝘨𝘦𝘬.𝘪𝘵𝘤𝘩.𝘪𝘰', nil, 14)
	elseif(time() < 6) then
		print_centered('all intellectual property', nil, -14)
		print_centered('contained within', nil, -7)
		print_centered('is the property of')
		print_centered('its respective owners', nil, 7)
	else
		print_centered("please don't sue me")
	end
end
