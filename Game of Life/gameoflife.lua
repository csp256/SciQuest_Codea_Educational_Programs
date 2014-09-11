-- Conway's Game of Life

-- setup() is called once at the start.
function setup()
     -- this changes the size of the simulation. larger numbers will lag the ipad. keep it less then 100.
     size = 50
     -- this creates an empty 'list'. lists are how Lua handles collections of things. 
     -- they are like arrays, vectors, sets, or tuples.
     -- lists have a collection of unique "keys" (indexes) which start at 1 and increment.
     -- each key corresponds to a (non-unique) value. 
     cells = {}
     -- this nested loop constructs a list of lists. this creates a 2 dimensional array.
     -- because the inner and outer loops both run size-many times, the array will be square.
     -- this notation means i will start with a value of 1 and increment to a value of "size".
     for i = 1,size do
         -- we are creating a NEW, empty list here each time the outer loops runs.
         local temp = {}
         -- the inner loop populates the empty "temp" list with true/false (boolean) values
         for j = 1,size do
             -- this corresponds to a 20% chance for the value to be true.
             -- true will correspond to alive, false to dead.
             if math.random(5) == 1 then
                 table.insert(temp, true)
             else
                 table.insert(temp, false)
             end
         end
         -- the temp list is added to the cells list. this is still in the outer loop, 
         -- so it happens multiple times.
         table.insert(cells, temp)
     end
 end
-- end of the setup() function

-- draw() is called once every frame (up to 30 hertz)
 function draw()    
     -- clears the screen
     background(40, 40, 50)
     -- feel free to increase this if the cells look 'blocky'
     strokeWidth(5)

     -- partitions the width and height of the screen into size-many chunks, each dx and dy size     
     dx = WIDTH / size
     dy = HEIGHT / size
     
     -- draws the current contents of the cells list (which is a list of lists of booleans)
     -- this notation will loop once for everything in the cells list (for each list it contains)
     -- that list (value) will be called x, and its index (key) will be called i. 
     for i,x in pairs(cells) do
         -- does the same for each list of booleans, "x".
         for j,y in pairs(x) do 
             -- cells stores boolean values and can thus be used as a conditional
             if cells[i][j] then
                 -- four corners of the rectangle to draw
                 rect(dx*(i-1), dy*(j-1), dx, dy)
             end
         end
     end

     -- this creates a NEW 2D list (each time it is called) called "next".
     -- all values will be false.      
     next = {}
     for i=1,size do
         local temp = {}
         for j=1,size do
             table.insert(temp, false)
         end
         table.insert(next, temp)
     end
     
     local adj = 0
     for i=1,size do
         for j=1,size do
             -- this is a reduced version of the game of life rules.
             -- we dont need to include rules for cells dying, since "next" is all false values.
             -- numAdj(i,j) is short for numberOfLivingCellsAdjacentTo(i,j)
             -- it is defined after the draw() function
             adj = numAdj(i, j)
             if adj == 3 then
                 next[i][j] = true
             end
             if cells[i][j] and adj == 2 then
                 next[i][j] = true
             end         
         end
     end
     
     -- replace cells with our new array.
     cells = next
 end

-- Counts the number of adjacent cells which are alive. 
-- x and y are the inputs. they represent the position in the grid of cells. 
 function numAdj(x, y)
     -- we start counting at 0
     local count = 0
     -- count from (one to the left), to (one to the right)
     for i = x-1,x+1 do
         -- count from (one below), to (one above)
         for j = y-1,y+1 do
             -- this is a compound if statement. COULD be broken up into several 'if' statements
             -- but this implementation is more efficient and avoids being tediously verbose
             -- the first four conditionals (0<i through j<=size) ensure that you are counting 
             -- only cells which actually exist.
             -- the last (i~=x or j~=y) ensures you do not count yourself
             if 0<i and i<=size and 0<j and j<=size and (i~=x or j~=y) then
                 -- cells is an array of true/false boolean values, therefor you can use
                 -- its value as a conditional
                 if cells[i][j] then 
                     count = count + 1
                 end
             end
         end
     end
     -- this is what this function outputs
     return count
 end