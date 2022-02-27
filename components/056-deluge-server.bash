  #!/usr/bin/env bash

  set -ex

  yay -S deluge --noconfirm --removemake --needed
  sudo systemctl enable --now deluged
  sudo sh -c 'while [ ! -f /srv/deluge/.config/deluge/deluged.pid ]; do sleep 1; done'

  sudo mkdir -p /home/deluge
  sudo mkdir -p /home/deluge/ongoing /home/deluge/done /home/deluge/torrents
  sudo chown -R deluge:deluge /home/deluge
  sudo chmod 750 /home/deluge
  sudo chmod -R 770 /home/deluge/ongoing /home/deluge/done /home/deluge/torrents

  readarray -d : -t auth < <(sudo cat /srv/deluge/.config/deluge/auth)


  deluge-console -U ${auth[0]} -P ${auth[1]} config --set allow_remote true
  deluge-console -U ${auth[0]} -P ${auth[1]} config --set copy_torrent_file true
  deluge-console -U ${auth[0]} -P ${auth[1]} config --set dont_count_slow_torrents true
  deluge-console -U ${auth[0]} -P ${auth[1]} config --set download_location '/home/deluge/ongoing'
  deluge-console -U ${auth[0]} -P ${auth[1]} config --set listen_ports '[56881,56889]'
  deluge-console -U ${auth[0]} -P ${auth[1]} config --set max_active_limit 15
  deluge-console -U ${auth[0]} -P ${auth[1]} config --set max_active_seeding 3
  deluge-console -U ${auth[0]} -P ${auth[1]} config --set max_connections_global 300
  deluge-console -U ${auth[0]} -P ${auth[1]} config --set max_upload_speed 1024.0
  deluge-console -U ${auth[0]} -P ${auth[1]} config --set move_completed true
  deluge-console -U ${auth[0]} -P ${auth[1]} config --set move_completed_path /home/deluge/done
  deluge-console -U ${auth[0]} -P ${auth[1]} config --set new_release_check false
  deluge-console -U ${auth[0]} -P ${auth[1]} config --set outgoing_ports '[56881,56889]'
  deluge-console -U ${auth[0]} -P ${auth[1]} config --set pre_allocate_storage true
  deluge-console -U ${auth[0]} -P ${auth[1]} config --set prioritize_first_last_pieces true
  deluge-console -U ${auth[0]} -P ${auth[1]} config --set random_port false
  deluge-console -U ${auth[0]} -P ${auth[1]} config --set torrentfiles_location /home/deluge/torrents
