---deserialize actor state frames

--******
--models
--******
---deserialize frame strings
function actors:deserialize_frames()
	for k, state in pairs(self.states) do
		for table, strings in pairs(state.frames) do
			if(table == 'sprites' or
				table == 'hitboxes'
			) then
				for i=1, #strings do
					if(type(strings[i] == 'string')) then
						strings[i] = split(strings[i], ",")
					end
				end
			end
		end
	end
end

