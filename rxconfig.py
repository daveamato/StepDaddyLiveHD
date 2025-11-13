import reflex as rx
import os
import socket
import encodings.idna


ipaddr = socket.gethostbyname(socket.gethostname())
proxy_content = os.environ.get("PROXY_CONTENT", "TRUE").upper() == "TRUE"
socks5 = os.environ.get("SOCKS5", "")
port = os.environ.get("PORT", "3000")

print(f"PROXY_CONTENT: {proxy_content}\nSOCKS5: {socks5}")

config = rx.Config(
    api_url=f"http://{ipaddr}:{port}",
    app_name="StepDaddyLiveHD",
    proxy_content=proxy_content,
    socks5=socks5,
    show_built_with_reflex=False,
    plugins=[
        rx.plugins.SitemapPlugin(),
        rx.plugins.TailwindV4Plugin(),
    ],
)
