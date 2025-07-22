{ ... }: {
  networking.wg-quick.interfaces.spl = {
    address = [
      "10.0.0.1/32"
    ];
    autostart = false;
    dns = [
      "192.168.0.100"
      "192.168.0.3"
    ];
    peers = [
      {
        allowedIPs = [
          "192.168.0.0/16"
          "10.0.0.0/24"
        ];
        endpoint = "speely.net:51820";
        persistentKeepalive = 25;
        publicKey = "wei6JspjityhJLQ2j1MRO4mPUEEYypDAI4tcL2mIjEY=";
      }
    ];
    privateKeyFile = "/etc/wireguard/spl.key";
  };
}
