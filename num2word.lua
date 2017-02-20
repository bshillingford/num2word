function string.pyslice(s, from, to) -- python-style string slice
    -- 0-indexed and possibly negative:
    if from == nil then from = 0 end
    if to == nil then to = #s end
    if from < 0 then from = from + #s end
    if to < 0 then to = to + #s end
    from = from + 1 -- now increment for 1-indexing, but not for the end index since exclusive
    return s:sub(from, to)
end

local ones = {[1]="one",[2]="two",[3]="three",[4]="four",
                    [5]="five",[6]="six",[7]="seven",[8]="eight",
                    [9]="nine",[0]="zero",[10]="ten"}
local teens = {[11]="eleven",[12]="twelve",[13]="thirteen",
                     [14]="fourteen",[15]="fifteen"}
local tens = {[2]="twenty",[3]="thirty",[4]="forty",
                    [5]="fifty",[6]="sixty",[7]="seventy",
                    [8]="eighty",[9]="ninety"}
local lens = {[3]="hundred",[4]="thousand",[6]="hundred",[7]="million",
                    [8]="million", [9]="million",[10]="billion"--,[13]="trillion",[11]="googol",
                    }

local function num2word(num)
    local word

    if num > 999999999 then
        return "Number more than 1 billion"
    end

    -- Ones
    if num < 11 then
        return ones[num]
    end
    -- Teens
    if num < 20 then
        word = (num > 15) and (ones[num%10] .. "teen") or teens[num]
        return word
    end
    -- Tens
    if num > 19 and num < 100 then
        word = tens[tonumber(tostring(num):sub(1,1))]
        if tostring(num):sub(2,2) == "0" then
            return word
        else
            word = word .. " " .. ones[num%10]
            return word
        end
    end

    -- First digit for thousands,hundred-thousands.
    if lens[#(tostring(num))] and #(tostring(num)) ~= 3 then
        word = ones[tonumber(tostring(num):sub(1,1))] .. " " .. lens[#(tostring(num))]
    else
        word = ""
    end

    -- Hundred to Million
    if num < 1000000 then
        -- First and Second digit for ten thousands.
        if #(tostring(num)) == 5 then
            word = num2word(tonumber(tostring(num):pyslice(0,2))) .. " thousand"
        end
        -- How many hundred-thousand(s).
        if #(tostring(num)) == 6 then
            word = word .. " " .. num2word(tonumber(tostring(num):pyslice(1,3))) ..
                        " " .. lens[#(tostring(num))-2]
        end
        -- How many hundred(s)?
        thousand_pt = #(tostring(num)) - 3
        word = word .. " " .. ones[tonumber(tostring(num):sub(thousand_pt+1, thousand_pt+1))] ..
                        " " .. lens[#(tostring(num))-thousand_pt]
        -- Last 2 digits.
        last2 = num2word(tonumber(tostring(num):pyslice(-2)))
        if last2 ~= "zero" then
            word = word .. " and " .. last2
        end
        word = word:gsub(" zero hundred",""):gsub(" zero thousand"," thousand")
        return word:match("^%s*(.-)%s*$")
    end

    local left = ''
    local right = ''
    -- Less than 1 million.
    if num < 100000000 then
        left = num2word(tonumber(tostring(num):pyslice(nil,-6))) .. " " .. lens[#(tostring(num))]
        right = num2word(tonumber(tostring(num):pyslice(-6)))
    end
    -- From 1 million to 1 billion.
    if num > 100000000 and num < 1000000000 then
        left = num2word(tonumber(tostring(num):pyslice(nil,3))) ..    " " .. lens[#(tostring(num))]
        right = num2word(tonumber(tostring(num):pyslice(-6)))
    end
    if tonumber(tostring(num):pyslice(-6)) < 100 then
        word = left .. " and " .. right
    else
        word = left .. " " .. right
    end
    word = word:gsub(" zero hundred",""):gsub(" zero thousand"," thousand")
    return word:match("^%s*(.-)%s*$")
end

return num2word
