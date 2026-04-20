path+=("$HOME/.local/share/radare2/prefix/bin")

function r2 {
        if [ -x "./executable" ]
        then
                local CMD=("radare2")
                if [ -f "./r2" ]
                then
                        CMD+=("-i" "./r2")
                fi
                if [ -f "./profile.rr2" ]
                then
                        CMD+=("-r" "./profile.rr2")
                fi
                ${CMD[@]} $@ ./executable
        else
                command r2 $@
        fi
}
function r2new {
        if [ -z "$1" ]
        then
                echo "usage: $0 <name>" >&2
                return 1
        fi
        local NEWDIR="$(pwd)/$1"
        if [ -d "$NEWDIR" ]
        then
                echo "directory '$NEWDIR' already exists, not clobbering" >&2
                return 1
        elif [ -x "$NEWDIR" ]
        then
                local TMP="$(mktemp)"
                mv "$NEWDIR" "$TMP"
                mkdir "$NEWDIR"
                mv "$TMP" "$NEWDIR/executable"
        else
                echo "WARN: no executable file \`./$1\`, so it won't be moved to ./$1/executable" >&2
                mkdir "$NEWDIR"
        fi

        echo "af @ main" > "$NEWDIR/functions"
        echo "fs *" > "$NEWDIR/flags"
        cat > "$NEWDIR/comments" <<EOF
CC-*

#"CC " @ main+
EOF
        echo "db-*" > "$NEWDIR/breakpoints"
        cat > "$NEWDIR/r2" <<EOF
. functions
. flags
. comments
. breakpoints

s main
pdf
EOF
        cat > "$NEWDIR/profile.rr2" <<EOF
#!/usr/bin/rarun2

stdin=./txt
EOF
        touch "$NEWDIR/txt"
}
