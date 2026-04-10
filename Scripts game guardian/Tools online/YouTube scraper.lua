
local chat = gg.prompt({'enter link video Youtube'}, {}, {'text'})
if chat == nil then
    return
end

local a = chat[1]

local video_id = a:match("youtu%.be/([^%?]+)")

local url = "https://www.googleapis.com/youtube/v3/videos?key=AIzaSyAw84SRK6coxEtx9hYNwyoi6Cj6jG6dknc&id="..video_id.."&part=snippet,contentDetails,statistics,status"
local response = gg.makeRequest(url)

if response and response.content then
    local json_data = response.content

  local function findInJson(json, key)
        local pattern = '"' .. key .. '"%s*:%s*"([^"]+)"'
        return json:match(pattern)
    end

    local title = findInJson(json_data, "title")
    local description = findInJson(json_data, "description")
    local publishedAt = findInJson(json_data, "publishedAt")
    local viewCount = findInJson(json_data, "viewCount")
    local likeCount = findInJson(json_data, "likeCount")
    local commentCount = findInJson(json_data, "commentCount")

    if description then
        description = description:gsub("\\n", " ")
    end

    local result = "\n--- Info Vídeo ---\n"
    result = result .. "title: " .. (title or "não encontrado") .. "\n\n"
    result = result .. "description: " .. (description or "no found") .. "\n\n"
    result = result .. "publishedAt: " .. (publishedAt or "no found") .. "\n\n"
    result = result .. "Views: " .. (viewCount or "no founds") .. "\n\n"
    result = result .. "like: " .. (likeCount or "no founds") .. "\n\n"
    result = result .. "Comments: " .. (commentCount or "no found") .. "\n"
   
    print(result)
else
    print("Erro request YouTube: ", response and response.status or "unknown")
end