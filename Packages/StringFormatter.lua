local StringFormatter = {}

function StringFormatter.toCamelCase(str)
	local words = string.split(str, " ")

	for i, word in ipairs(words) do
		word = string.lower(word)

		if i > 1 then
			word = string.gsub(word, "^%l", string.upper)
		end

		words[i] = word
	end

	return table.concat(words)
end

return StringFormatter
