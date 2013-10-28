function strsplit(delimiter, text)
  local list = {}
  local pos = 1
  if string.find("", delimiter, 1) then -- this would result in endless loops
    error("delimiter matches empty string!")
  end
  while 1 do
    local first, last = string.find(text, delimiter, pos)
    if first then -- found?
      table.insert(list, string.sub(text, pos, first-1))
      pos = last+1
    else
      table.insert(list, string.sub(text, pos))
      break
    end
  end
  return list
end



if term == nil then
    width,height = 50, 30
    write = io.write
else
    width,height = term.getSize()
    term.clear()
    term.setCursorPos(1, 1)
end

print("width: "..width.." height: "..height)

glider = [[     
   O 
    O
  OOO ]]

glider_gun = [[


                            O           
                          O O           
                OO      OO            OO
               O   O    OO            OO
    OO        O     O   OO              
    OO        O   O OO    O O           
              O     O       O           
               O   O                    
                OO                      ]]

seed = glider_gun

seed_str = strsplit("\n", seed)
world = {}

for h = 1, height do
    print("reading height: "..h)
    world[h] = {}
    for w = 1, width do
        if (h <= #seed_str and w <= #seed_str[h]) then
            print("thing is "..seed_str[h]:sub(w, w))
            if (seed_str[h]:sub(w, w) == "O") then
                world[h][w] = true
            end
            if world[h][w] then print("alive at "..h..", "..w) end
        end
    end
end

-- return a table containing the surrounding points to check
-- points maybe out of range, so check for that
function surrounding(xval, yval)
    coords = {}
    coords[xval - 1] = {yval - 1, yval, yval + 1}
    coords[xval] = {yval - 1, yval + 1}
    coords[xval + 1] = {yval - 1, yval, yval + 1}
    return coords
end

function living_neighbours(this_height, this_width)
    count = 0
    for h, widxs in pairs(surrounding(this_height, this_width)) do
        if (h <= height and h > 0) then
            for k, w in pairs(widxs) do
                if (w > 0 and world[h][w]) then
                    count = count + 1
                end
            end
        end
    end
    return count
end

function print_world(world)
    if term ~= nil then
        term.clear()
    end
    for h = 1, height do
        for w = 1, width do
            if world[h][w] then
                write("0")
            else
                write(" ")
            end
        end
        write("\n")
    end
end

print_world(world)
while true do
    new_world = {}
    for h = 1, height do
        new_world[h] = {}
        for w = 1, width do
            alives = living_neighbours(h, w)
            if world[h][w] then
                if (alives == 2 or alives == 3) then
                    new_world[h][w] = true
                end
            elseif (alives == 3) then
                new_world[h][w] = true
            end
        end
    end
    world = new_world
    print_world(world)
    if sleep then
        sleep(0)
    else
        os.execute("sleep 0.2")
    end
end
