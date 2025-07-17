Config = {}

Config.SaveFile = "vehicles.json" -- not used with SQL, but keep for backward compat

-- Order parts must be installed in:
Config.InstallOrder = { "engine", "battery", "tank", "wheels" }

-- Required inventory items for each part:
Config.RequiredParts = {
    engine = "car_engine_part",
    battery = "car_battery_part",
    tank = "car_tank_part",
    wheels = "car_wheel_part"
}
