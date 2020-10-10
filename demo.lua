local redis_mock=require "redis_mock"

local function main(redis,KEYS,ARGV)
    
-- start function body
    local input  = redis.call("get",KEYS[1])

    local target = ARGV[1]
    local minlength = tonumber(ARGV[2])

    local  matchs={}
    local previous=0

    for i = 1,input:len() do 
        local current=0
        if input:sub(i,i)==target then 
            current=previous+1
        else
            current=0
            if previous >= minlength then 
                local match={}
                match["start"]=i-previous
                match["count"]=previous
                table.insert(matchs,match)
            end
        end
        previous=current
    end

    return matchs
-- end script segment

end 

local k,a=redis_mock.init("redis://redis:6379/1",arg)

local result=main(redis_mock,k,a)

if type(result)=="table" then 
    for i,v in pairs(result) do
        ngx.say("start:",v["start"]," count:",v["count"])
    end
else
    ngx.say(result)
end

redis_mock.close()
