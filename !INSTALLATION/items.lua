["adrenaline"] = {
    label = "Adrenalina",
    weight = 100,
    stack = false,
    close = true,
    description = "Acorda até defunto.",
    client = {
        export = "ars_ambulancejob.useAdrenaline"
    }
},
["medicalbag"] = {
    label = "Bolsa de Primeiros Socorros",
    weight = 220,
    stack = true,
    description = "Um kit médico abrangente para tratar ferimentos e doenças.",
},
["bandage"] = {
    label = "Bandagem",
    weight = 100,
    consume = 1,
    stack = true,
    description = "Uma simples bandagem usada para cobrir e proteger ferimentos.",
    client = {
        export = "ars_ambulancejob.bandage",
    },
},
["analgesic"] = {
    label = "Analgésico",
    weight = 10,
    stack = true,
    description = "Um analgésico usado para aliviar a dor.",
    client = {
        export = "ars_ambulancejob.analgesic",
    },
},
["defibrillator"] = {
    label = "Desfibrilador",
    weight = 100,
    stack = true,
    description = "Usado para reviver pacientes.",
},
["tweezers"] = {
    label = "Pinças",
    weight = 100,
    stack = true,
    description = "Pinças de precisão para remover objetos estranhos, como balas, de ferimentos com segurança.",
},
["burncream"] = {
    label = "Creme para Queimaduras",
    weight = 100,
    stack = true,
    description = "Creme especializado para tratar e aliviar queimaduras leves e irritações na pele.",
},
["suturekit"] = {
    label = "Kit de Sutura",
    weight = 100,
    stack = true,
    description = "Um kit contendo ferramentas cirúrgicas e materiais para suturar e fechar ferimentos.",
},
["icepack"] = {
    label = "Pacote de Gelo",
    weight = 200,
    stack = true,
    description = "Um pacote de gelo usado para reduzir o inchaço e fornecer alívio da dor e inflamação.",
},
["stretcher"] = {
    label = "Maca",
    weight = 200,
    stack = true,
    description = "Um maca usada para mover pacientes que precisam de cuidados médicos.",
},
["emstablet"] = {
    label = "Tablet de EMS",
    weight = 200,
    stack = true,
    client = {
        export = "ars_ambulancejob.openDistressCalls",
    },
},
