minetest.register_chatcommand("send_waypoint", {
    params = "<radius> <x> <y> <z>",
    description = "Send a waypoint to players within a radius",
    privs = {shout = true},
    func = function(name, param)
        -- Parse parameters
        local radius, x, y, z = param:match("^(%d+)%s+([-%d%.]+)%s+([-%d%.]+)%s+([-%d%.]+)$")
        radius = tonumber(radius)
        x, y, z = tonumber(x), tonumber(y), tonumber(z)

        if not radius or not x or not y or not z then
            return false, "Invalid parameters. Usage: /send_waypoint <radius> <x> <y> <z>"
        end

        -- Get sender position
        local sender = minetest.get_player_by_name(name)
        if not sender then
            return false, "Player not found."
        end
        local sender_pos = sender:get_pos()

        -- Find players within the radius
        for _, player in ipairs(minetest.get_connected_players()) do
            local player_pos = player:get_pos()
            local distance = vector.distance(sender_pos, player_pos)

            if distance <= radius then
                -- Send a waypoint particle effect
                minetest.add_particle({
                    pos = {x=x, y=y, z=z},
                    velocity = {x=0, y=0, z=0},
                    acceleration = {x=0, y=0, z=0},
                    expirationtime = 5,
                    size = 6,
                    collisiondetection = false,
                    vertical = false,
                    texture = "waypoint.png", -- Use any available texture
                    playername = player:get_player_name()
                })

                minetest.chat_send_player(player:get_player_name(), "A waypoint has been set at ("..x..", "..y..", "..z..")")
            end
        end
        return true, "Waypoint sent to players within a radius of " .. radius .. " blocks."
    end
})
