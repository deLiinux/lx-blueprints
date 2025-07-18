# lx-blueprints (WIP)

This resource is a script where players can place down a vehicle blueprint and proceed to build it with material.

To add:
Persist placed blueprints across restarts?
...

* Items used in ox_inventory
```
['dominator4_blueprint'] = {
        label = 'Dominator Blueprint',
        weight = 100,
        stack = false,
        close = true,
        description = 'A blueprint to build a Dominator',
        image = 'vehicle_blueprint.png',
        client = {
            event = 'lx-vehicleblueprint:dominator4Blueprint'
        },
    },

    ['zr380_blueprint'] = {
        label = 'ZR380 Blueprint',
        weight = 100,
        stack = false,
        close = true,
        description = 'A blueprint to build a ZR380',
        image = 'vehicle_blueprint.png',
        client = {
            event = 'lx-vehicleblueprint:zr380Blueprint'
        },
    },

    ['ratloader_blueprint'] = {
        label = 'Ratloader Blueprint',
        weight = 100,
        stack = false,
        close = true,
        description = 'A blueprint to build a Ratloader',
        image = 'vehicle_blueprint.png',
        client = {
            event = 'lx-vehicleblueprint:ratloaderBlueprint'
        },
    },

    ['slamvan3_blueprint'] = {
        label = 'Slamvan Blueprint',
        weight = 100,
        stack = false,
        close = true,
        description = 'A blueprint to build a Slamvan',
        image = 'vehicle_blueprint.png',
        client = {
            event = 'lx-vehicleblueprint:slamvan3Blueprint'
        },
    },

    ['ruston_blueprint'] = {
        label = 'Ruston Blueprint',
        weight = 100,
        stack = false,
        close = true,
        description = 'A blueprint to build a Ruston',
        image = 'vehicle_blueprint.png',
        client = {
            event = 'lx-vehicleblueprint:rustonBlueprint'
        },
    },

    ['dukes_blueprint'] = {
        label = 'Dukes Blueprint',
        weight = 100,
        stack = false,
        close = true,
        description = 'A blueprint to build a Dukes',
        image = 'vehicle_blueprint.png',
        client = {
            event = 'lx-vehicleblueprint:dukesBlueprint'
        },
    },

    ['ruiner_blueprint'] = {
        label = 'Ruiner Blueprint',
        weight = 100,
        stack = false,
        close = true,
        description = 'A blueprint to build a Ruiner',
        image = 'vehicle_blueprint.png',
        client = {
            event = 'lx-vehicleblueprint:ruinerBlueprint'
        },
    },

    ['blista2_blueprint'] = {
        label = 'Blista Compact Blueprint',
        weight = 100,
        stack = false,
        close = true,
        description = 'A blueprint to build a Blista Compact',
        image = 'vehicle_blueprint.png',
        client = {
            event = 'lx-vehicleblueprint:blista2Blueprint'
        },
    },

    ['phoenix_blueprint'] = {
        label = 'Phoenix Blueprint',
        weight = 100,
        stack = false,
        close = true,
        description = 'A blueprint to build a Phoenix',
        image = 'vehicle_blueprint.png',
        client = {
            event = 'lx-vehicleblueprint:phoenixBlueprint'
        },
    },

    ['gauntlet_blueprint'] = {
        label = 'Gauntlet Blueprint',
        weight = 100,
        stack = false,
        close = true,
        description = 'A blueprint to build a Gauntlet',
        image = 'vehicle_blueprint.png',
        client = {
            event = 'lx-vehicleblueprint:gauntletBlueprint'
        },
    },

    ['buccaneer_blueprint'] = {
        label = 'Buccaneer Blueprint',
        weight = 100,
        stack = false,
        close = true,
        description = 'A blueprint to build a Buccaneer',
        image = 'vehicle_blueprint.png',
        client = {
            event = 'lx-vehicleblueprint:buccaneerBlueprint'
        },
    },

    ['wastelander_blueprint'] = {
        label = 'Wastelander Blueprint',
        weight = 100,
        stack = false,
        close = true,
        description = 'A blueprint to place build a Wastelander',
        image = 'vehicle_blueprint.png',
        client = {
            event = 'lx-vehicleblueprint:wastelanderBlueprint'
        },
    },
    
    ['dune_blueprint'] = {
        label = 'Dune Blueprint',
        weight = 100,
        stack = false,
        close = true,
        description = 'A blueprint to place build a Dune',
        image = 'vehicle_blueprint.png',
        client = {
            event = 'lx-vehicleblueprint:duneBlueprint'
        },
    },
    
    ['dune3_blueprint'] = {
        label = 'Dune 3 Blueprint',
        weight = 100,
        stack = false,
        close = true,
        description = 'A blueprint to place build a Dune 3',
        image = 'vehicle_blueprint.png',
        client = {
            event = 'lx-vehicleblueprint:dune3Blueprint'
        },
    },
    
    ['dune4_blueprint'] = {
        label = 'Dune 4 Blueprint',
        weight = 100,
        stack = false,
        close = true,
        description = 'A blueprint to place build a Dune 4',
        image = 'vehicle_blueprint.png',
        client = {
            event = 'lx-vehicleblueprint:dune4Blueprint'
        },
    },
    
    ['brickade_blueprint'] = {
        label = 'Brickade Blueprint',
        weight = 100,
        stack = false,
        close = true,
        description = 'A blueprint to place build a Brickade',
        image = 'vehicle_blueprint.png',
        client = {
            event = 'lx-vehicleblueprint:brickadeBlueprint'
        },
    },
    
    ['brickade2_blueprint'] = {
        label = 'Brickade 2 Blueprint',
        weight = 100,
        stack = false,
        close = true,
        description = 'A blueprint to place build a Brickade 2',
        image = 'vehicle_blueprint.png',
        client = {
            event = 'lx-vehicleblueprint:brickade2Blueprint'
        },
    },
    
    ['manchez3_blueprint'] = {
        label = 'Manchez 3 Blueprint',
        weight = 100,
        stack = false,
        close = true,
        description = 'A blueprint to place build a Manchez 3',
        image = 'vehicle_blueprint.png',
        client = {
            event = 'lx-vehicleblueprint:manchez3Blueprint'
        },
    },
    
    ['ratbike_blueprint'] = {
        label = 'Ratbike Blueprint',
        weight = 100,
        stack = false,
        close = true,
        description = 'A blueprint to place build a Ratbike',
        image = 'vehicle_blueprint.png',
        client = {
            event = 'lx-vehicleblueprint:ratbikeBlueprint'
        },
    },
    
    ['technical_blueprint'] = {
        label = 'Technical Blueprint',
        weight = 100,
        stack = false,
        close = true,
        description = 'A blueprint to place build a Technical',
        image = 'blueprint.png',
        client = {
            event = 'lx-vehicleblueprint:technicalBlueprint'
        },
    },
    
    ['boxville5_blueprint'] = {
        label = 'Boxville Blueprint',
        weight = 100,
        stack = false,
        close = true,
        description = 'A blueprint to place build a Boxville 5',
        image = 'boxville5_blueprint.png', 
        client = {
            event = 'lx-vehicleblueprint:boxville5Blueprint'
        },
    },
```

## License

[![GPLv3 License](https://img.shields.io/badge/License-GPL%20v3-yellow.svg)](https://opensource.org/licenses/)

## Contributors

- [deLiinux](https://y.yarn.co/19206366-29fa-4525-8ac1-aab52cdd5c6d_text.gif)
