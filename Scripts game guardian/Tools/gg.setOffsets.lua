function gg.setOffsets(region, search, type, refine, type2, result, address, flags, value, freeze, toast)
	gg.setRanges(region)

	if search ~= nil then
		gg.searchNumber(search, type)
	end

	if refine ~= nil then
		gg.refineNumber(refine, type2)
	end

	local results = gg.getResults(result)

	for i, v in ipairs(results) do
		if address ~= nil then
			results[i].address = v.address + address
		end
		if flags ~= nil then
			results[i].flags = flags
		end
		if value ~= nil then
			results[i].value = value
		end
		if freeze ~= nil then
			results[i].freeze = freeze
			results[i].freezeType = gg.FREEZE_NORMAL
		end
	end

	gg.addListItems(results)

	if toast ~= nil then
		gg.toast(toast)
	end

	gg.clearResults()
end


--how to use

gg.setOffsets(
    region,
    search,
    type,
    refine,
    type2,
    result,
    address,
    flags,
    value,
    freeze,
    toast
)

gg.setOffsets(
    32,
    "11;1;1;2;1;1;2;1;1;1;1;0E;0F;0W;0W;0F;0E;1::737",
    4,
    "0",
    16,
    500,
    nil,
    16,
    "40000",
    false,
    "ok"
)