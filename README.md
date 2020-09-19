# Deluge + WireGuard

## Environment Variables

- `DELUGE_CONFIG_DIR` : `/config`
- `DELUGE_DATA_DIR` : `/data`
- `WG_I_NAME` : `wg0`
- `DELUGE_UMASK` : `022`
- `DELUGE_WEB_UMASK` : `027`

## Kill Switch

Add these lines to the `[Interface]` section of your .conf file.

_You may need to replace `192.168.1.0/24` with your host's network._

```
PostUp = iptables -I OUTPUT ! -o %i -m mark ! --mark $(wg show %i fwmark) -m addrtype ! --dst-type LOCAL -j REJECT
PreDown = iptables -D OUTPUT ! -o %i -m mark ! --mark $(wg show %i fwmark) -m addrtype ! --dst-type LOCAL -j REJECT
PostUp = iptables -I OUTPUT -d 192.168.1.0/24 -j ACCEPT
PostDown = iptables -D OUTPUT -d 192.168.1.0/24 -j ACCEPT
```

## Examples

### Docker

### Docker Compose

```yaml
version: "3"
services:
  deluge_wg:
    image: ecabuk/deluge-wireguard
    restart: unless-stopped
    privileged: true
    volumes:
      - ./my-wg.conf:/etc/wireguard/wg0.conf
    environment:
      PUID: 1000
      PGID: 1000
    ports:
      - 8112:8112
      - 58846:58846
```

## References
- [wg-quick.8](https://git.zx2c4.com/wireguard-tools/about/src/man/wg-quick.8)
- [deluge umask](https://deluge.readthedocs.io/en/latest/how-to/systemd-service.html#umask-for-deluged-downloaded-files)