xbindkeys
# Set up 2x2 grid for workspace (not configurable by obconf; choices
# are either the custom lxde_set_layout.c script or installing a
# pager).
lxde_set_layout 0 2 2 0
# Start emacs daemon.
emacs --daemon
exec startlxde
