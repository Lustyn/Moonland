-- GLOBALS
-- these are never initialized so dont worry, this is just a hack to get linter-moonscript to shut the f**k up
export jua
export term
export write
export colors
export keys

-- APIS

os.loadAPI "jua"

-- VARIABLES

local w, h
local tickCounter
local player
local ai

-- CLASSES

class Entity
  new: =>
    @x = 1
    @y = 1
    @char = "#"
    @color = colors.white
  setPos: (x, y) =>
    @x = x
    @y = y
  update: =>
    --TODO: update?

class Player extends Entity
  new: =>
    super!
    @char = "@"
    @color = colors.green
  move: (x, y) =>
    @\setPos @x + x, @y + y

class Robot extends Entity
  new: =>
    super!
    @char = "?"
    @color = colors.red
  update: =>
    dx = player.x - @x
    dy = player.y - @y
    if math.abs(dx) > 0
      @x += math.floor(dx/2)
    if math.abs(dy) > 0
      @y += math.floor(dy/2)

-- EVENTS

onKey = (event, key) ->
  if key == keys.left
    player\move -1, 0
  elseif key == keys.right
    player\move 1, 0
  elseif key == keys.up
    player\move 0, -1
  elseif key == keys.down
    player\move 0, 1


onRender = ->
  term.clear!
  -- tick counter
  --term.setCursorPos 1, 1
  --write tickCounter

  -- player
  term.setCursorPos player.x, player.y
  term.setTextColor player.color
  write player.char

  -- robot
  term.setCursorPos ai.x, ai.y
  term.setTextColor ai.color
  write ai.char

  -- debug values
  term.setCursorPos 1, h-1
  write "#{player.x}, #{player.y}"
  term.setCursorPos 1, h
  write "#{ai.x}, #{ai.y}"

onUpdate = ->
  -- increment tick counter
  tickCounter += 1

  -- render
  onRender!

  -- update the player
  player\update!
  ai\update!

onInit = ->
  -- init events
  jua.on "key", onKey

  -- init updates
  jua.setInterval onUpdate, 0

  -- init variables
  w, h = term.getSize!
  tickCounter = 0
  player = Player!
  ai = Robot!

  -- clear the term
  term.clear!
  term.setCursorPos 1, 1
  term.setCursorBlink false

  -- start jua
  jua.run!

onInit!
