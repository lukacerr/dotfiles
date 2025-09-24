EWW_SCRIPTS_DIR=$HOME/.config/eww/scripts
cd $EWW_SCRIPTS_DIR

# SH BASED
# To use: scripts/{NAME}.sh
for x in $EWW_SCRIPTS_DIR/*.sh; do chmod +x $x; done

# RUST BASED
# Requires cargo installed to build
# To use: scripts/{NAME}/target/release/{NAME}
# RUST_DIRS=("active_window" "active_workspaces")

# for x in ${RUST_DIRS[@]}; do 
#   cd $EWW_SCRIPTS_DIR/$x
#   cargo build -r
# done

# cd $EWW_SCRIPTS_DIR
