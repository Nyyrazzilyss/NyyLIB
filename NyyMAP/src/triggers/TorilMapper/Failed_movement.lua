-- failed room movement

-- Animated plants secure your feet and prevent your exit!

-- Alas, you cannot go that way. . . .


-- You're busy spellcasting! - follow has already processed
-- need to record last room/direction

--< 104h/104H 118v/126V P: std > 
--Bloogak lumbers down.
--You follow Bloogak down.

--A magic force blocks movement downwards.
--Irohple leaves down.

--< 104h/104H 118v/126V P: std > 

-- Changed to erase entire queue

--map:clearQueue() -- <-- already sent movements still need to be processeed



-- need to pop last sent movement from queue

map:removeMovement()

-- Erase unsent movements from queue

map:trimMovement()

-- error above: What about movements already sent/not yet processed?