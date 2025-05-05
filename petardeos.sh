mkdir -p ~/.config/wireplumber/main.lua.d

cat << 'EOF' > ~/.config/wireplumber/main.lua.d/99-disable-idle-suspend.lua
-- Desactiva la suspensión automática de los dispositivos de audio
rule = {
    matches = {
        {
            { "node.name", "matches", "alsa_output.*" },
        },
    },
    apply_properties = {
        ["session.suspend-timeout-seconds"] = 0,
    },
}

table.insert(alsa_monitor.rules, rule)
EOF

systemctl --user restart wireplumber
