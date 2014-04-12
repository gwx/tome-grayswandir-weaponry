-- Make the ray
local ray = {}
local tiles = math.ceil(math.sqrt(tx*tx+ty*ty))
local tx = tx * engine.Map.tile_w
local ty = ty * engine.Map.tile_h
local breakdir = math.rad(rng.range(-8, 8))
local rmax = rmax or 200
local gmax = gmax or 200
local bmax = bmax or 200
ray.dir = math.atan2(ty, tx)
ray.size = math.sqrt(tx*tx+ty*ty)
local xoff = rng.range(-3, 3)
local yoff = rng.range(-3, 3)

-- Populate the beam based on the forks
return { generator = function()
	local a = ray.dir
	local rad = rng.range(-3,3)
	local ra = math.rad(rad)
	local r = rng.range(1, ray.size)

	return {
		life = 8,
		size = 4, sizev = -0.1, sizea = 0,

		x = xoff + r * math.cos(a) + 2 * math.cos(ra), xv = 0, xa = 0,
		y = yoff + r * math.sin(a) + 2 * math.sin(ra), yv = 0, ya = 0,
		dir = ray.dir, dirv = 0, dira = 0,
		vel = rng.percent(80) and 2 or 1, velv = 0.2, vela = -0.01,

		r = rng.range(rmax * 0.8, rmax)/255,  rv = -0.02, ra = 0,
		g = rng.range(gmax * 0.8, gmax)/255,  gv = -0.02, ga = 0,
		b = rng.range(bmax * 0.8, bmax)/255,  bv = -0.02, ba = 0,
		a = rng.range(25, 220)/255,   av = 0, aa = 0,
	}
end, },
function(self)
	self.nb = (self.nb or 0) + 1
	if self.nb < 4 then
		self.ps:emit(100*tiles)
	end
end,
8*100*tiles
