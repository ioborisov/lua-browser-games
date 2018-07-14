package.path = package.path .. ';../libs/?.lua'
require("utf8data")
require("utf8")
window = js.global
currentWord = ""
numWin = 0
numLose = 0
secondsLeft = 0
TTL = 15
timer = nil
strTimer = nil
btnStart = nil 
txtResult = nil
interval = "секунд"
intervalEnding = {"", "а", "ы"}
strings = {
  pushbutton = "Нажмите кнопку \"Играть\".",
  gameover = "Игра закончена. ",
  time = "Осталось ",
  timeover = "Время истекло. ",
  good = "Угадали. "
}
wordList = {"АНТИЛОПА", "БЕГЕМОТ", "АВТОМОБИЛЬ", "ФУТБОЛ", "ПАРОВОЗ", "КОРОБКА", "ПИАНИНО", "ТЕЛЕВИЗОР", "РЕСТОРАН", "ОЛИМПИАДА"}
-- Вспомогательные функции
-- Перемешиваем значения в таблице
-- void table.shuffle(table t)
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
-- Разбиваем строку по символам, преобразуя в таблицу
-- table string:split()
function string:split()
  local t = {}
  for i=1, string.utf8len(self) do
    table.insert(t, string.utf8sub(self, i, i))
  end
  return t
end
-- Делаем правильные окончания
function ending(num, str, t)
  if num%100 >= 11 and num%100 <= 14 then return str .. t[1] end
  local n = num%10
  if n == 1 then return str .. t[2] end
  if n == 2 or n == 3 or n == 4 then return str .. t[3] end
  return str .. t[1]
end

-- Выбираем случайное слово, перемешиваем его и запускаем счётчик
-- void getNewWord()
function getNewWord() 
  if #wordList == 0 then
    strTimer.innerHTML = strings["gameover"]
    return
  end 
  secondsLeft = TTL
  changeTimer()
  table.shuffle(wordList)
  currentWord = table.remove(wordList, 1)
  -- перепутанная строка
  window.document:getElementById("strWord").innerHTML = table.concat(table.shuffle(currentWord:split())) 
  txtResult.value = ""  -- очистка поля ввода
  txtResult:focus()
  btnStart.disabled = "disabled"
  txtResult.disabled = ""
  timer = window:setInterval(getTime, 1000) -- запуск таймера
end
function getTime() 
  secondsLeft = secondsLeft - 1
  changeTimer()
  if secondsLeft <= 0 then  -- время вышло
    numLose = numLose + 1
    window.document:getElementById("strLose").innerHTML = numLose
    window:clearInterval(timer)
    btnStart.disabled = ""
    btnStart:focus()
    txtResult.disabled = "disabled"
  end
end

function changeTimer() 
  if secondsLeft == 0 then strTimer.innerHTML = strings["timeover"] .. strings["pushbutton"]; return end
  strTimer.innerHTML = strings["time"] .. secondsLeft .. " " .. ending(secondsLeft, interval, intervalEnding );
end
-- Прверяем то, что вводит пользователь
function checkInput() 
  if string.utf8upper(txtResult.value) == currentWord then  -- игрок угадал
    numWin = numWin + 1
    window.document:getElementById("strWin").innerHTML = numWin
    btnStart.disabled = ""
    window:clearInterval(timer)
    strTimer.innerHTML = strings["good"] .. strings["pushbutton"]
    btnStart:focus()
    txtResult.disabled = "disabled"
  end
end
-- init
txtResult = window.document:getElementById("txtResult")
txtResult:addEventListener("keyup", checkInput)
btnStart = window.document:getElementById("btnStart")
btnStart:addEventListener("click", getNewWord)
strTimer = window.document:getElementById("strTimer")
strTimer.innerHTML = strings["pushbutton"]
