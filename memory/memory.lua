window = js.global
VISIBLE_TIME = 1000
VISIBLE_DECK_TIME = 3000
CARD_HEIGHT = 96
CARD_WIDTH = 71
NUM_CARDS = 16
IMG_PATH = "images/"
CARD_BACK = IMG_PATH .. "1COVER.gif"
wrong = 0
lastClicked = nil
cards = {}
deck = {"2_BUB.gif", "3_BUB.gif", "4_BUB.gif", "5_BUB.gif", "6_BUB.gif", "7_BUB.gif", "8_BUB.gif", "9_BUB.gif", "10_BUB.gif", "A_BUB.gif", "J_BUB.gif", "K_BUB.gif", "Q_BUB.gif", "2_CH.gif", "3_CH.gif", "4_CH.gif", "5_CH.gif", "6_CH.gif", "7_CH.gif", "8_CH.gif", "9_CH.gif", "10_CH.gif", "A_CH.gif", "J_CH.gif", "K_CH.gif", "Q_CH.gif", "2_PIK.gif", "3_PIK.gif", "4_PIK.gif", "5_PIK.gif", "6_PIK.gif", "7_PIK.gif", "8_PIK.gif", "9_PIK.gif", "10_PIK.gif", "A_PIK.gif", "J_PIK.gif", "K_PIK.gif", "Q_PIK.gif", "2_TREF.gif", "3_TREF.gif", "4_TREF.gif", "5_TREF.gif", "6_TREF.gif", "7_TREF.gif", "8_TREF.gif", "9_TREF.gif", "10_TREF.gif", "A_TREF.gif", "J_TREF.gif", "K_TREF.gif", "Q_TREF.gif"}

function table.shuffle(t)
  math.randomseed(os.time())
  local counter = #t
  while counter > 1 do
      local index = math.random(counter)
      t[index], t[counter] = t[counter], t[index]
      counter = counter - 1
  end
  return t
end

function table.slice(t, first, last, step)
  local sliced = {}

  for i = first or 1, last or #t, step or 1 do
    sliced[#sliced+1] = t[i]
  end

  return sliced
end

function table.copy(orig)
  local copy
  if type(orig) == 'table' then
    copy = {}
    for _, v in ipairs(orig) do
      table.insert(copy, v)
    end
  else -- number, string, boolean, etc
    error("Copy for table only!")
  end
    return copy
end

function table.merge(t1, t2)
  for i, v in ipairs(t2) do table.insert(t1, v) end
end

function newGame() 
  wrong = 0
  window.document:getElementById("wrong").innerHTML = 0
  table.shuffle(deck)
  cards = table.slice(deck, 1, NUM_CARDS / 2)
  table.merge(cards, table.copy(cards))
  table.shuffle(cards);

  local imgs = window.document:getElementsByTagName("img")
  
  for i=1, imgs.length do
    imgs[i-1].src = IMG_PATH .. cards[i]
  end
  
  window:setTimeout(function () 
    for i=1, imgs.length do
      imgs[i-1].src = CARD_BACK
    end
  end, VISIBLE_DECK_TIME)
end

function cardClicked(e) 
  local clickedCard = e -- e.target -- По какой карте кликнули?
  -- Если карта уже перевёрнута, игнорируем её
  --if (!clickedCard.src.endsWith(CARD_BACK)) return;
  print(e)
  if clickedCard.src:find(CARD_BACK) == nil then return end
  -- Переворачиваем карту
  local clickedNumber = tonumber(clickedCard.alt) -- порядковый номер
  clickedCard.src = IMG_PATH .. cards[clickedNumber]
  if lastClicked == nil then
    lastClicked = clickedCard
  else
    if clickedCard.src ~= lastClicked.src then -- we have a match!
      wrong = wrong + 1
      window.document:getElementById("wrong").innerHTML = wrong
      -- Переворачиваем обратно
      local tmp = lastClicked
      window:setTimeout(function () 
        clickedCard.src = CARD_BACK
        tmp.src = CARD_BACK;
        --lastClicked = null;
      end, VISIBLE_TIME)
    end
    lastClicked = nil
  end
end

box = window.document:getElementById("box")
img = nil
for i=1, NUM_CARDS do
  img = window.document:createElement("img") --new Image(CARD_WIDTH, CARD_HEIGHT);
  img.width = CARD_WIDTH
  img.height = CARD_HEIGHT
  img:addEventListener("click", cardClicked)
  img.alt = tostring(i)
  box:appendChild(img)
end
window.document:getElementById("new"):addEventListener("click", newGame)
newGame()