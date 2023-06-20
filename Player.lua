Player = Class{}

function Player:init(x, y)
	self.x = x
	self.y = y
	
	self.width = 26
	self.height = 6
end

function Player:render()
	love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end