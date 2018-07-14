local window = js.global
local doc = window.document
local msgs = { 
          LABEL = "Вы слева. Выберите камень, ножницы или бумагу", 
          TIE = "Ничья. Продолжайте играть!",
          PLAYER_WIN = "Вы выиграли. Можно закончить игру.",
          COMPUTER_WIN = "Вы проиграли. Продолжайте играть, не сдавайтесь!"
      }
local result = {ROCK = 1, SCISSORS = 2, PAPER = 3}      
local imageWidth = 200
local imageHeight = 85
local position = {{x=0, y=0}, {x=0, y=85}, {x=0, y=170}}      

local div = doc:createElement("div")
div.style.width = 480 .. "px"
div.style.margin = "0 auto"
div.style.textAlign = "center"
doc.body:appendChild(div)

local canvasLeft = doc:createElement("canvas")
canvasLeft.width = imageWidth
canvasLeft.height = imageHeight
div:appendChild(canvasLeft)
local contextLeft = canvasLeft:getContext("2d")

local canvasRight = doc:createElement("canvas")
canvasRight.width = imageWidth
canvasRight.height = imageHeight
div:appendChild(canvasRight)
local contextRight = canvasRight:getContext("2d")

local label = doc:createElement("h4")
label:appendChild(doc:createTextNode(msgs["LABEL"]))
div:appendChild(label)

local imageLeft = js.new(window.Image, imageWidth, imageHeight)
local imageRight = js.new(window.Image, imageWidth ,imageHeight)
imageLeft.src = "left.png"
imageRight.src = "right.png"

imageLeft:addEventListener("load", function() 
    contextLeft:drawImage(imageLeft, position[1]["x"], position[1]["y"], imageWidth, imageHeight, 0, 0, imageWidth, imageHeight)
  end)
imageRight:addEventListener("load", function() 
    contextRight:drawImage(imageRight, position[1]["x"], position[1]["y"], imageWidth, imageHeight, 0, 0, imageWidth, imageHeight)
  end)

function calculateResult(p, c) 
  if p == c then 
    return msgs["TIE"]
  elseif p == result["PAPER"] and c == result["ROCK"] then 
    return msgs["PLAYER_WIN"]
  elseif p == result["ROCK"] and c == result["SCISSORS"] then 
    return msgs["PLAYER_WIN"]
  elseif p == result["SCISSORS"] and c == result["PAPER"] then 
    return msgs["PLAYER_WIN"]
  else 
    return msgs["COMPUTER_WIN"]
  end
end

function startGame(e)
  math.randomseed(os.time())
  local p = result[e.id]
  contextLeft:drawImage(imageLeft, position[p]["x"], position[p]["y"], imageWidth, imageHeight, 0, 0, imageWidth, imageHeight)
  local c = math.random(3)
  contextRight:drawImage(imageRight, position[c]["x"], position[c]["y"], imageWidth, imageHeight, 0, 0, imageWidth, imageHeight)
  label.firstChild.nodeValue = calculateResult(p, c)
end

local canvasR = doc:createElement("canvas")
canvasR.width = 145
canvasR.height = 125
canvasR.id = "ROCK"
canvasR.style.cursor = "pointer"
div:appendChild(canvasR)
local contextR = canvasR:getContext("2d")

local canvasS = doc:createElement("canvas")
canvasS.width = 145
canvasS.height = 125
canvasS.id = "SCISSORS"
canvasS.style.cursor = "pointer"
div:appendChild(canvasS)
local contextS = canvasS:getContext("2d")

local canvasP = doc:createElement("canvas")
canvasP.width = 138
canvasP.height = 125
canvasP.id = "PAPER"
canvasP.style.cursor = "pointer"
div:appendChild(canvasP)
local contextP = canvasP:getContext("2d")

local imageChoice = js.new(window.Image, 400, 125)
imageChoice.src = "choice.png"

imageChoice:addEventListener("load", function() 
    contextR:drawImage(imageChoice, 0, 0, 145, 125, 0, 0, 145, 125)
    contextS:drawImage(imageChoice, 136, 0, 145, 125, 0, 0, 145, 125)
    contextP:drawImage(imageChoice, 262, 0, 138, 125, 0, 0, 138, 125)
  end)

canvasR:addEventListener("click", startGame)
canvasS:addEventListener("click", startGame)
canvasP:addEventListener("click", startGame)