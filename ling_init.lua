ling = {
    font = {
        default = love.graphics.newFont("assets/font/default.otf",15)
    }
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
    class = require"misc/class"
    love.graphics.setFont(ling.font.default)
    return ling
end

return load()