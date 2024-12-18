function love.load()  
    love.window.setTitle("Cat Game")  
    love.window.setMode(612, 423) 

    -- Load images  
    background = love.graphics.newImage("background.png")  
    catIdleImage = love.graphics.newImage("cat_idle.png")  
    catLeftImage = love.graphics.newImage("cat_left.png")   
    catRightImage = love.graphics.newImage("cat_right.png") 
    catLayingImage = love.graphics.newImage("cat_laying.png")  

    -- Load music  
    backgroundMusic = love.audio.newSource("background_music.mp3", "stream")  
    backgroundMusic:setLooping(true)
    love.audio.play(backgroundMusic)

    -- Cat state  
    cat = {x = 200, y = 300, layingDown = false, chasing = false, direction = "right"}
    ball = nil  
    ballsChased = 0  
    maxBallsBeforeLaying = math.random(3, 6)  
    pettingTime = 0 
    isPetting = false

end  

local function updateCatDirection()  
    if ball then  
        if ball.x > cat.x then  
            cat.direction = "right"
        elseif ball.x < cat.x then  
            cat.direction = "left"
        end  
    end  
end  

function love.update(dt)  
    if isPetting then  
        pettingTime = pettingTime + dt 
        if pettingTime >= 6 then
            isPetting = false  
            cat.layingDown = false 
            cat.chasing = false 
            ballsChased = 0 
            maxBallsBeforeLaying = math.random(3, 6)
        end  
    else  
        if ball and not cat.layingDown then  
            cat.chasing = true
            if cat.x < ball.x then  
                cat.x = cat.x + 100 * dt  
            elseif cat.x > ball.x then  
                cat.x = cat.x - 100 * dt  
            end  
            
            if math.abs(cat.x - ball.x) < 10 and math.abs(cat.y - ball.y) < 10 then  
                ballsChased = ballsChased + 1  
                ball = nil  
                if ballsChased >= maxBallsBeforeLaying then  
                    cat.layingDown = true  
                    cat.chasing = false 
                    maxBallsBeforeLaying = math.random(3, 6) 
                end  
            end  

            updateCatDirection()   
        else  
            cat.chasing = false
        end  
    end  
end  

function love.mousepressed(x, y, button, istouch, presses)  
    if button == 1 and cat.layingDown and not isPetting then  
        isPetting = true
        pettingTime = 0
    elseif button == 1 and not cat.layingDown then  
        ball = {x = x, y = cat.y} 
    end  
end  

function love.draw()  
    love.graphics.draw(background, 0, 0)  
 
    if cat.layingDown then  
        love.graphics.draw(catLayingImage, cat.x - catLayingImage:getWidth()/2, cat.y - catLayingImage:getHeight()/2) 
    elseif cat.chasing then  
        if cat.direction == "right" then  
            love.graphics.draw(catRightImage, cat.x - catRightImage:getWidth()/2, cat.y - catRightImage:getHeight()/2)
        else  
            love.graphics.draw(catLeftImage, cat.x - catLeftImage:getWidth()/2, cat.y - catLeftImage:getHeight()/2)   
        end  
    else  
        love.graphics.draw(catIdleImage, cat.x - catIdleImage:getWidth()/2, cat.y - catIdleImage:getHeight()/2) 
    end  

    if ball then  
        love.graphics.setColor(1, 0, 0)
        love.graphics.circle("fill", ball.x, ball.y, 10)  
    end  

    love.graphics.setColor(1, 1, 1)  
    love.graphics.print("Click to spawn a ball!", 10, 10)  
    if cat.layingDown then  
        love.graphics.print("Click to pet the cat! (6 seconds)", 10, 30)  
    end  
end