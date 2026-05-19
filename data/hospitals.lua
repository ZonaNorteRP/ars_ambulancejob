return {
    ["pillbox"] = {
        paramedic = {
            model = "s_m_m_scientist_01",
            pos = {
                vector4(1145.68, -1540.48, 34.38, 1.04),
                -- vec4(-439.79, -324.24, 33.91, 157.32), -- adicione mais caso queira
            },
        },
        bossmenu = {
            pos = vec3(305.21, -597.59, 43.29),
            min_grade = 2,
        },
        zone = {
            pos = vector3(1141.39, -1539.42, 35.38),
            size = vec3(200.0, 200.0, 200.0),
        },
        blip = {
            enable = false,
            name = "Pillbox Hospital",
            type = 61,
            scale = 1.0,
            color = 2,
            pos = vector3(1141.39, -1539.42, 35.38),
        },
        respawn = {
            {
                bedPoint = vector4(1148.89, -1562.97, 36.29, 357.72),
                spawnPoint = vector4(1147.57, -1562.83, 35.38, 93.81),
                isDeadRespawn = true, -- local pra spawnar quando morre
            },
            {
                bedPoint = vector4(1148.86, -1565.6, 36.29, 181.68),
                spawnPoint = vector4(1147.57, -1562.83, 35.38, 93.81),
            },
        },
        pharmacy = {
            ["ems_shop_1"] = {
                job = true,
                label = "Farmácia",
                grade = 0, -- works only if job true
                pos = vector3(315.5516, -598.6013, 43.2918),
                blip = {
                    enable = false,
                    name = "Farmácia",
                    type = 61,
                    scale = 0.7,
                    color = 2,
                    pos = vector3(315.5516, -598.6013, 43.2918),
                },
                items = {
                    { name = "medicalbag",    label = "Bolsa Médica",     icon = "fas fa-briefcase-medical", price = 10 },
                    { name = "bandage",       label = "Bandagem",         icon = "fas fa-bandage",           price = 10 },
                    { name = "defibrillator", label = "Desfibrilador",    icon = "fas fa-heartbeat",         price = 10 },
                    { name = "tweezers",      label = "Pinça",            icon = "fas fa-tools",             price = 10 },
                    { name = "burncream",     label = "Aloe Vera",        icon = "fas fa-fire-extinguisher", price = 10 },
                    { name = "suturekit",     label = "Kit de Suturação", icon = "fas fa-scissors",          price = 10 },
                    { name = "icepack",       label = "Pacote de Gelo",   icon = "fas fa-snowflake",         price = 10 },
                    { name = "Dipiroka",       label = "Di pi ro ka",   icon = "fas fa-snowflake",         price = 500 },
                    { name = "kit_sobrevivencia",       label = "Kit de sobrevivencia",   icon = "fas fa-snowflake",         price = 1500 },
                    { name = "kit_medico",       label = "kit  medico",   icon = "fas fa-snowflake",         price = 500 },
                },
            },

            ["ems_shop_2"] = {
                job = false,
                label = "Farmácia",
                grade = 0, -- >>>> farmacia em outro lugar
                pos = vector3(-3157.84, 1095.08, 20.86),
                blip = {
                    enable = true,
                    name = "Farmácia",
                    type = 61,
                    scale = 0.7,
                    color = 3,
                    pos = vector3(-3157.84, 1095.08, 20.86),
                },
                items = {
                    { name = "medicalbag", label = "Bolsa Médica", icon = "fas fa-briefcase-medical", price = 1000 },
                    { name = "bandage",    label = "Bandagem",     icon = "fas fa-bandage",           price = 500 },
                    { name = "Dipiroka",    label = "Dipiroka",     icon = "fas fa-bandage",           price = 1500 },
                },
            },

            ["ems_shop_3"] = {
                job = false,
                label = "Farmácia",
                grade = 0, -- >>>> farmacia em outro lugar
                pos = vector3(1836.11, 3668.18, 33.68),
                blip = {
                    enable = true,
                    name = "Farmácia",
                    type = 61,
                    scale = 0.7,
                    color = 3,
                    pos = vector3(1836.11, 3668.18, 33.68),
                },
                items = {
                    { name = "medicalbag", label = "Bolsa Médica", icon = "fas fa-briefcase-medical", price = 10 },
                    { name = "bandage",    label = "Bandagem",     icon = "fas fa-bandage",           price = 10 },
                },
            },

            ["ems_shop_ilha"] = {
                job = false,
                label = "Farmácia",
                grade = 0, -- >>>> farmacia em outro lugar <<< ilha preço mais barato
                pos = vector3(-3566.56, 6368.09, 24.78),
                blip = {
                    enable = true,
                    name = "Farmácia",
                    type = 61,
                    scale = 0.7,
                    color = 3,
                    pos = vector3(-3566.56, 6368.09, 24.78),
                },
                items = {
                    { name = "medicalbag", label = "Bolsa Médica", icon = "fas fa-briefcase-medical", price = 10 },
                    { name = "bandage",    label = "Bandagem",     icon = "fas fa-bandage",           price = 10 },
                },
            },


            ["ems_shop_4"] = {
                job = false,
                label = "Farmácia",
                grade = 0, -- works only if job true >>>>>>> esse que muda
                pos = vector3(1141.61, -1543.35, 35.38),
                blip = {
                    enable = false,
                    name = "Farmácia",
                    type = 61,
                    scale = 0.7,
                    color = 2,
                    pos = vector3(1135.6, -1535.38, 35.38),
                },
                items = {
                    { name = "bandage",    label = "Bandagem",   icon = "fas fa-bandage", price = 10 },
                    { name = "adrenaline", label = "Adrenalina", icon = "fas fa-syringe", price = 10 },
                },
            },
        },
        garage = {},
        clothes = { enable = false },
    },
    ["viceroy"] = {
        paramedic = {
            model = "s_m_m_scientist_01",
            pos = {
                vector4(-794.67, -1185.5, 5.93, 226.27),
            },
        },
        zone = {
            pos = vector3(-791.0, -1178.0, 6.93),
            size = vec3(50.0, 50.0, 50.0),
        },
        blip = {
            enable = false,
            name = "Viceroy Clinic",
            type = 61,
            scale = 1.0,
            color = 2,
            pos = vector3(-791.0, -1189.0, 6.93),
        },
        respawn = {
            {
                bedPoint = vector4(-793.23, -1190.84, 21.95, 114.32),
                spawnPoint = vector4(-791.68, -1191.35, 21.95, 114.32),
                isDeadRespawn = true,
            },
        },
        pharmacy = {
            ["ems_shop_5"] = {
                job = false,
                label = "Farmácia",
                grade = 0,
                pos = vector3(-784.65, -1188.07, 6.93),
                blip = {
                    enable = true,
                    name = "Farmácia",
                    type = 61,
                    scale = 0.7,
                    color = 3,
                    pos = vector3(-784.65, -1188.07, 6.93),
                },
                items = {
                    { name = "medicalbag", label = "Bolsa Médica", icon = "fas fa-briefcase-medical", price = 10 },
                    { name = "bandage",    label = "Bandagem",     icon = "fas fa-bandage",           price = 10 },
                },
            },
        },
        garage = {},
        bossmenu = {},
        clothes = { enable = false },
    },
}
