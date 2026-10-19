# Load .env file
if test -f ~/.env
    for line in (cat ~/.env)
        if not string match -qr '^#' -- "$line"
            if string match -qr '=' -- "$line"
                set -l parts (string split -m 1 '=' -- "$line")
                set -gx $parts[1] (string trim -c '"' -- $parts[2])
            end
        end
    end
end
