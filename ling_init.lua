ling = {
    font = {}
}

love_callback = {
	"update",
	"draw",
	"keypressed",
	"keyreleased",
	"mousemoved",
	"mousepressed",
	"mousereleased",
	"wheelmoved",
	"textedited",
	"textinput",
}

function load()
	love.graphics.setDefaultFilter("nearest","nearest")
	class = require"misc/class"
	ling.font.default = love.graphics.newFont("assets/font/default.otf",16)
    love.graphics.setFont(ling.font.default)
    return ling
end

return load()