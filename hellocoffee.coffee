#Игра змейка, массив змеи - массив координат блоков игрового поля

pointIndicator    = null
points            = 0
gameOverIndicator = null
newGame           = null
fieldWidth        = 80
fieldHeight       = 30
gameField         = null
startX            = 40
startY            = 15
caneat            = false

#направления движения

LEFT  = 1
UP    = 2
RIGHT = 3
DOWN  = 4

direction = RIGHT

snake = [[startX, startY], [startX - 1, startY], [startX - 2, startY]]

xeatcoord = null
yeatcoord = null

go = null

#создание игрового поля
createGameField = ->
    table = document.createElement("table")
    table.id = "snake"
    thead = document.createElement("thead")
    thead.appendChild row = document.createElement("tr")

    for [0...3]        
        row.appendChild th = document.createElement("th")        
        if !_i 
            th.colSpan = 20
            pointIndicator = document.createElement("span");
            pointIndicator.innerHTML = "POINTS: " + 0
            th.appendChild pointIndicator
        else if _i == 1
            th.colSpan = 40
            newGame = document.createElement("span")
            newGame.innerHTML = "START"
            newGame.style.cursor = "pointer"
            th.appendChild newGame
            newGame.onclick = ->
                                start()                                
        else 
            gameOverIndicator = document.createElement("span")
            gameOverIndicator.style.color = "red"
            th.appendChild gameOverIndicator            
            th.colSpan = 20
    gameField = tbody = document.createElement("tbody")
    for [0...fieldHeight]
        tbody.appendChild row = document.createElement("tr")        
        for [0...fieldWidth]
            row.appendChild td = document.createElement("td")    
    table.appendChild thead
    table.appendChild tbody
    document.body.appendChild table    

#обработчик смены неправления движения    
document.body.onkeydown =(e)->
    e = e || window.event
    switch e.keyCode
        when 37 then if direction != RIGHT then direction = LEFT
        when 38 then if direction != DOWN then direction = UP            
        when 39 then if direction != LEFT then direction = RIGHT
        when 40 then if direction != UP then direction = DOWN

move =->
    canmove = false    
    switch direction
        when LEFT then canmove  = leftMovePossible()
        when RIGHT then canmove = rightMovePossible()
        when DOWN then canmove  = downMovePossible()
        when UP then canmove    = upMovePossible()
    if canmove
        if caneat
            grow()
            caneat = false
            placeEat()
        else
            moveSnake()
    else
        endGame()

leftMovePossible = ->   
    if snake[0][0] - 1 < 0 or gameField.rows[snake[0][1]].cells[snake[0][0] - 1].className == "snakeBody" then return false
    if gameField.rows[snake[0][1]].cells[snake[0][0] - 1].className == "eat" then caneat = true
    return true

rightMovePossible = ->
    if snake[0][0] + 1 == fieldWidth or gameField.rows[snake[0][1]].cells[snake[0][0] + 1].className == "snakeBody" then return false
    if gameField.rows[snake[0][1]].cells[snake[0][0] + 1].className == "eat" then caneat = true
    return true

downMovePossible = ->
    if snake[0][1] + 1 == fieldHeight or gameField.rows[snake[0][1] + 1].cells[snake[0][0]].className == "snakeBody" then return false
    if gameField.rows[snake[0][1] + 1].cells[snake[0][0]].className == "eat" then caneat = true
    return true
               
upMovePossible = ->
    if snake[0][1] - 1 < 0 or gameField.rows[snake[0][1] - 1].cells[snake[0][0]].className == "snakeBody" then return false
    if gameField.rows[snake[0][1] - 1].cells[snake[0][0]].className == "eat" then caneat = true
    return true

moveSnake = ->
    #стерли змею
    for [0...snake.length]
        gameField.rows[snake[_i][1]].cells[snake[_i][0]].className = ""
    snake.pop()
    snake.unshift([snake[0][0], snake[0][1]])
    switch direction
        when LEFT then snake[0][0]  -= 1
        when RIGHT then snake[0][0] += 1
        when DOWN then snake[0][1]  += 1
        when UP then snake[0][1]    -= 1
    #нарисовали змею
    for [0...snake.length]
        gameField.rows[snake[_j][1]].cells[snake[_j][0]].className = "snakeBody"    

grow = ->
    snake.unshift([snake[0][0], snake[0][1]])
    switch direction        
        when LEFT then snake[0][0]  -= 1
        when RIGHT then snake[0][0] += 1
        when DOWN then snake[0][1]  += 1
        when UP then snake[0][1]    -= 1
    gameField.rows[snake[0][1]].cells[snake[0][0]].className = "snakeBody"
    pointIndicator.innerHTML = "POINTS: " + ++points    
     
placeEat = ->
    xeatcoord = getRandNum(0, fieldWidth - 1)
    yeatcoord = getRandNum(0, fieldHeight - 1)
    while gameField.rows[yeatcoord].cells[xeatcoord].className == "snakeBody" 
        xeatcoord = getRandNum(0, fieldWidth - 1)
        yeatcoord = getRandNum(0, fieldHeight - 1)
    gameField.rows[yeatcoord].cells[xeatcoord].className = "eat"

endGame = ->
    gameOverIndicator.innerHTML = "YOU LOOSE"
    clearInterval(go)    

getRandNum =(min, max)->
    rand = min - 0.5 + Math.random()*(max-min+1);
    return Math.round(rand);

#создали поле
createGameField()

start = ->    
    #если игра уже идет, или закончилась, очистим поле, убьем таймер
    #очистим змею
    for [0...snake.length]
        gameField.rows[snake[_i][1]].cells[snake[_i][0]].className = ""
    #начальное положение змея
    snake = [[startX, startY], [startX - 1, startY], [startX - 2, startY]]
    clearInterval(go)
    if xeatcoord != null
        gameField.rows[yeatcoord].cells[xeatcoord].className = ""
    direction = RIGHT
    pointIndicator.innerHTML = "POINTS: " + 0
    points = 0;
    gameOverIndicator.innerHTML = ""
    #положили змею
    for [0...snake.length]
        gameField.rows[snake[_j][1]].cells[snake[_j][0]].className = "snakeBody"
    #положили еду
    placeEat()
    #запустили змею
    go = setInterval(move, 100)

start()