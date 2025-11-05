-- HONO_DETECTOR.lua
--[[
AUTHOR: Par ChatGPT
DATE: 05-11-2025
VERSION: 4.2
--]]

script_name = "Détecteur d'honorifiques"
script_description = "Détecte et marque les honorifiques japonais dans le champ 'Effect' avec sauvegarde et restauration"
script_author = "Par ChatGPT"
script_version = "4.2"

-----------------------------------
-- 🔸 Configuration : dossier Aegisub
-----------------------------------

-- Essaie de déterminer le bon dossier selon le système
local function get_aegisub_config_path()
    local home = os.getenv("APPDATA") or os.getenv("HOME") or "."
    local path
    if home:match("AppData") then
        -- Windows
        path = home .. "\\Aegisub\\honorifiques_config.txt"
    else
        -- Linux / macOS
        path = home .. "/.aegisub/honorifiques_config.txt"
    end
    return path
end

local config_file = get_aegisub_config_path()

-- 🔹 Liste par défaut
local default_terms = [["san", "kun", "chan", "sama", "senpai", "sempai", "sensei", "dono",
"tan", "shi", "hime", "ou", "bei", "pai", "sen", "nyan", "chi",
"samā", "senpāi", "ō", "hīmē", "shī", "dōno"]]

-----------------------------------
-- 🔸 Fonctions utilitaires
-----------------------------------
local function utf8lower(str)
    return str:lower()
end

-- Lecture de la config sauvegardée
local function load_config()
    local file = io.open(config_file, "r")
    if file then
        local content = file:read("*a")
        file:close()
        if content and content:match("%S") then
            return content
        end
    end
    return default_terms
end

-- Sauvegarde de la config modifiée
local function save_config(content)
    local file = io.open(config_file, "w+")
    if file then
        file:write(content)
        file:close()
    end
end

-----------------------------------
-- 🔸 Fonction principale
-----------------------------------
local function detect_honorifiques(subs, sel, config)
    local allow_hyphen = config.allow_hyphen or false
    local terms = config.hono_terms or ""
    if terms == "" then return end

    -- Sauvegarde la config si modifiée
    save_config(terms)

    -- Transformation en table
    local honorifiques = {}
    for term in terms:gmatch("[^,%s]+") do
        term = term:gsub('"', '')
        table.insert(honorifiques, utf8lower(term))
    end

    -- Détection ligne par ligne
    for i = 1, #subs do
        local line = subs[i]
        if line.class == "dialogue" then
            local text = line.text
            local plain_text = text:gsub("{.-}", "")
            local lowered_text = utf8lower(plain_text)

            for _, hono in ipairs(honorifiques) do
                local found = false

                -- Cas particulier : éviter le faux positif de "ou"
                if hono == "ou" then
                    for word in lowered_text:gmatch("%S+") do
                        if (word:match("[%-%a]" .. hono .. "[%p%s]?$") or word:match("%-" .. hono))
                            and not word:match("[%a]" .. hono .. "[%a]") then
                            found = true
                            break
                        end
                    end
                else
                    if allow_hyphen then
                        local pattern1 = "%f[%a]" .. hono .. "%f[^%a]"
                        local pattern2 = "%-" .. hono
                        if lowered_text:find(pattern1) or lowered_text:find(pattern2) then
                            found = true
                        end
                    else
                        local pattern = "%f[%a]" .. hono .. "%f[^%a]"
                        if lowered_text:find(pattern) then
                            found = true
                        end
                    end
                end

                if found then
                    line.effect = "Honorifique détecté : " .. hono
                    subs[i] = line
                    break
                end
            end
        end
    end

    aegisub.set_undo_point(script_name)
end

-----------------------------------
-- 🔸 Boîte de dialogue utilisateur
-----------------------------------
local function configuration_dialog(subs, sel)
    local saved_terms = load_config()

    local config = {
        {
            class = "label",
            x = 0, y = 0, width = 4, height = 1,
            label = "Entrez les honorifiques à détecter (séparés par des virgules) :"
        },
        {
            class = "textbox",
            name = "hono_terms",
            x = 0, y = 1, width = 4, height = 3,
            value = saved_terms
        },
        {
            class = "checkbox",
            name = "allow_hyphen",
            x = 0, y = 4, width = 4, height = 1,
            label = "Autoriser les honorifiques liés par un tiret (ex : Mitsuru-sempai)",
            value = false
        }
    }

    local btn, result = aegisub.dialog.display(config, {"OK", "Restaurer valeurs par défaut", "Annuler"})

    if btn == "OK" then
        detect_honorifiques(subs, sel, result)

    elseif btn == "Restaurer valeurs par défaut" then
        save_config(default_terms)
        aegisub.debug.out("✅ Liste d'honorifiques restaurée aux valeurs par défaut.\n")
    end
end

-----------------------------------
-- 🔸 Enregistrement du script
-----------------------------------
aegisub.register_macro(script_name, script_description, configuration_dialog)
