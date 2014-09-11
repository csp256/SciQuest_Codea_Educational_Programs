--------------------------------------
-- Boom
--------------------------------------

Boom = class()

function Boom:init(x,y)
    self.x = x
    self.y = y
    
    self.del = false
    
    self.t = 0
    
    table.insert(booms, self)
end

function Boom:draw()
    self.t = self.t + DeltaTime
    if 1 < self.t then
        self.del = true
    end
    
    pushMatrix()
    pushStyle()
    
    spriteMode(CENTER)
    translate(self.x, self.y)
    scale(1+self.t, 1+self.t)
    tint(255, 255, 255, 255*(1-self.t))
    sprite("Tyrian Remastered:Explosion Huge")
    
    popStyle()
    popMatrix()
end

function Boom:touched(touch)
    -- Codea does not automatically call this method
end

--------------------------------------
-- Bug
--------------------------------------

Bug = class()

function Bug:init()
    self.x = -200
    self.o = math.random(0, HEIGHT)
    self.y = self.o
    self.w = 0
    
    table.insert(bugs, self)
end

function Bug:draw()
    self.x = self.x + bugSpd * DeltaTime
    
    self.w = 50 * math.sin(score * 5)
    self.y = self.o + self.w
    sprite("SpaceCute:Beetle Ship", self.x, self.y)
end

function Bug:touched(touch)
    -- Codea does not automatically call this method
end


--------------------------------------
-- Helper
--------------------------------------



function intro()
    fill(250, 255, 0, 255)
    font("Inconsolata")
    fontSize(50)
    text("Remember, losing is fun!", WIDTH/2, HEIGHT*3/4)
    spriteMode(CENTER)
    sprite("SpaceCute:Star", WIDTH/3, HEIGHT/2)
    text("good!", WIDTH/3, HEIGHT/3)
    sprite("SpaceCute:Beetle Ship", WIDTH*2/3, HEIGHT/2, 150, 150)
    text("bad!", WIDTH*2/3, HEIGHT/3)
end

function game()
    score = score + DeltaTime
    
    nrg(-decay * DeltaTime)
    starDelay = 1 / sps
    starTimer = starTimer + DeltaTime
    if starDelay < starTimer then
        Star()
        starTimer = 0
    end
    
    for k,v in pairs(booms) do
        v:draw()
        if v.del == true then
            table.remove(booms, k)
        end
    end
    
    for k,v in pairs(stars) do
        v:draw()
        if v.del == true then
            table.remove(stars, k)
            nrg(-5)
        end
    end
    
    for k,bug in pairs(bugs) do
        bug:draw()
    end
    
    spriteMode(CENTER)
    translate(WIDTH/2, 18)
    scale(energy*WIDTH/600, 3)
    sprite("Tyrian Remastered:Bullet Fire D")
end

function fin()
    text("You scored:", WIDTH/2, HEIGHT*2/3)
    fontSize(100)
    text( math.ceil(10*score), WIDTH/2, HEIGHT/2)
end



--------------------------------------
-- Main
--------------------------------------

function setup()
    parameter("bugSpd", 0, 200, 210)
    parameter("radius", 0, 300, 200)
    parameter("acc", 50, 200, 100)
    parameter("sps", 0, 10, 2) -- stars per sec
    starTimer = 0
    parameter("energy", 0, 100, 100)
    parameter("decay", 0, 5, 1)
    score = 0
    watch("score")
    
    INTRO = 1
    GAME = 2
    FIN = 3
    gameState = INTRO
    
    stars = {}
    Star()
    
    bugs = {}
    Bug()
    
    booms = {}
end

function draw()
    spriteMode(CORNER)
    sprite("SpaceCute:Background", 0, 0, WIDTH, HEIGHT)
    
    if gameState == INTRO then
        intro()
    elseif gameState == GAME then
        game()
    elseif gameState == FIN then
        fin()
    end
end

function pyth(a, b)
    dx = a.x - b.x
    dy = a.y - b.y
    return math.sqrt(dx*dx + dy*dy)
end

function touched(t)
    if gameState == INTRO then
        gameState = GAME
    end
    
    nrg(99)
    
    if t.state == BEGAN then
        canTouch = true
        for k,bug in pairs(bugs) do
            if canTouch and pyth(t, bug) < radius then
                print(score)
                Boom(bug.x, bug.y)
                table.remove(bugs, k)
            end
        end
        
        for k,v in pairs(stars) do
            if canTouch and pyth(t, v) < radius then
                nrg(7)
                table.remove(stars, k)
                canTouch = false
            end
        end
        if canTouch == true then 
            nrg(-3)
            Bug()
        end
    end
end

function nrg(e)
    energy = energy + e
    if 100 < energy then
        energy = 100
    elseif energy < 0 then
        energy = 0
        gameState = FIN
    end
end


--------------------------------------
-- Star
--------------------------------------

Star = class()

function Star:init()
    self.x = math.random(0, WIDTH)
    self.y = HEIGHT + 150
    
    self.vel = 0
    
    self.del = false
    
    table.insert(stars, self)
end

function Star:draw()
    spriteMode(CENTER)
    sprite("SpaceCute:Star", self.x, self.y)
    self.vel = self.vel + acc * DeltaTime
    self.y = self.y - self.vel * DeltaTime
    
    if self.y < -60 then 
        self.del = true
    end
end

function Star:touched(touch)
end