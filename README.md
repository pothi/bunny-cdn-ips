# bunny-cdn-ips

**🐰 Daily updated Bunny CDN edge server IP lists (IPv4 + IPv6)**

Ready for `set_real_ip_from` in Nginx, trusted proxies in Caddy, firewalls, and more.

## 📊 Current Stats
- **IPv4**: ~480 addresses
- **IPv6**: ~280 addresses
- **Total**: ~760 addresses

**Last updated**: Automatically every day via GitHub Actions.

## 📁 Files

| File                  | Description                                   | Format              |
|-----------------------|-----------------------------------------------|---------------------|
| `bunny-ipv4.txt`      | All Bunny CDN IPv4 addresses                  | One IP per line     |
| `bunny-ipv6.txt`      | All Bunny CDN IPv6 addresses                  | One IP per line     |
| `bunny-all.txt`       | Combined IPv4 + IPv6                          | One IP per line     |
| `bunny-real-ip.conf`  | Ready-to-use for Nginx `set_real_ip_from`     | Nginx config        |

## 🚀 Quick Download (Raw)

- [bunny-ipv4.txt](https://raw.githubusercontent.com/pothi/bunny-cdn-ips/main/bunny-ipv4.txt)
- [bunny-ipv6.txt](https://raw.githubusercontent.com/pothi/bunny-cdn-ips/main/bunny-ipv6.txt)
- [bunny-all.txt](https://raw.githubusercontent.com/pothi/bunny-cdn-ips/main/bunny-all.txt)
- [bunny-real-ip.conf](https://raw.githubusercontent.com/pothi/bunny-cdn-ips/main/bunny-real-ip.conf)

## 🛠 Usage Examples

### Nginx — Real Client IP (`set_real_ip_from`)
```nginx
http {
    # Bunny CDN Real IP (auto-updated)
    include /etc/nginx/bunny-real-ip.conf;

    # Optional: Trust your internal networks too
    set_real_ip_from 10.0.0.0/8;
    set_real_ip_from 172.16.0.0/12;
    set_real_ip_from 192.168.0.0/16;

    server {
        # $remote_addr will now be the real visitor IP
        access_log /var/log/nginx/access.log main;
    }
}
```

### Caddy v2
```caddy
{
    servers {
        trusted_proxies static {
            include /path/to/bunny-ipv4.txt
            include /path/to/bunny-ipv6.txt
        }
    }
}
```

## 🔄 Automatic Updates

This repository uses GitHub Actions to fetch the latest lists from Bunny CDN every day at 03:00 UTC and creates a new release when changes are detected.

### Credits

Built with help from Grok by xAI.

#### 📜 License

Public domain / MIT — feel free to use however you want.

**Made with ❤️ for the self-hosting & open-source community**
