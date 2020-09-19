#!/usr/bin/env python3

from os import getenv
from deluge.config import Config
from deluge.core.preferencesmanager import DEFAULT_PREFS

conf = Config('core.conf', DEFAULT_PREFS, getenv('DELUGE_CONFIG_DIR'))

# Folders
data_dir = getenv('DELUGE_DATA_DIR')
if not data_dir:
    print("Deluge data directory couldn't find.")

path_map = {
    'autoadd_location': 'autoadd',
    'download_location': 'download',
    'move_completed_path': 'completed',
    'torrentfiles_location': 'torrentfiles'
}
for key, val in path_map.items():
    conf.set_item(key, "/".join([data_dir, val]))

# Listening Ports
l_port_begin = getenv('DELUGE_PORT_BEGIN')
if l_port_begin:
    l_port_end = getenv('DELUGE_PORT_END')
    conf.set_item('listen_ports', [l_port_begin, l_port_end or l_port_begin])
    conf.set_item('random_port', False)

# Allow Remote
conf.set_item('allow_remote', True)

conf.save()
