local redis_connect = require "resty.redis.connector"

local _M = {}

function _M.init(redis_url,args)
    _M.connect(redis_url)
    
    local KEYS={}
    local ARGV={}
    
    if not arg then 
        return redis,KEYS,ARGV
    end

    local keynum=tonumber(arg[1])

    for i,v in ipairs(arg) do
        if i>1 and i<=keynum+1 then 
            KEYS[i-1]=v
        elseif i>keynum+1 then 
            ARGV[i-keynum-1]=v
        end   
    end
    return KEYS,ARGV
end

function _M.connect(redis_url)

    local rc = redis_connect.new({
        connect_timeout = 50,
        read_timeout = 5000,
        keepalive_timeout = 30000,
        -- ssl=config.redis_ssl,
        -- ssl_verify=false,
    })

    local red, err = rc:connect({
        url = redis_url 
    })

    if err then 
        error(err)
    end

    _M.redis=red

end

function _M.close()

    _M.redis:close()

end

function _M.call(cmd, ... )

    local red=_M.redis

    local status,result= pcall(red[cmd],red,...)

    if status then 
        return result
    else
        error(result)
    end 
end

function _M.pcall(cmd, ... )

    return _M.pall(cmd,...)

end

return _M