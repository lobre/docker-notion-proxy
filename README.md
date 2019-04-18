# docker-notion-proxy

Docker image for a Nginx based reverse proxy for Notion so.

Notion.so does not allow custom domain names so far (maybe soon?).
The idea of this project is to provide a Docker image to easily create a reverse proxy to Notion.

Your DNS entry can point toward this reverse proxy and it will proxy pass to Notion.

## How to use

    docker run -d --name notion-proxy \
        -p 80:80 \
        -e HOST=example.com \
        -e PROTO=http \ 
        -e REDIRECT=What-s-New-157765353f2c4705bd45474e5ba8b46c \
        lobre/notion-proxy

You domain name `example.com` should resolve to the server where this container is started.

Then try to browser `http://example.com`.

You can as well have a look to the `docker-compose.yml` file for an alternative usage.

## Caution

### This will only work for public Notion pages.

### This does not work with custom ports

You cannot bind a non http port to the Docker container. If doing so, the Notion Javascript code will detect a mismatch when checking the base URL and the page won't show up.

So it is important to have a `-p 80:80` or `-p 443:443` on the container.

### We cannot hide/rewrite the URL for a clean root domain.

For the What's New public page for instance, we cannot have it directly under `http://example.com`.
We need the appended URI: `http://example.com/What-s-New-157765353f2c4705bd45474e5ba8b46c`.

The reason is that Notion relies a lot on Javascript. The routing to a public page seems to be done dynamically using Javascript with `window.location.href` (actual browser URL) to parse which page should be displayed. So when pointing to `http://example.com`, it will understand that it should display `http://www.notion.so` even if we proxy_pass to a custom page.

In order to still have a special page attached to the root domain, you can add the `REDIRECT` environment variable to set up a redirection on the root domain.
So with our example after having set `REDIRECT=What-s-New-157765353f2c4705bd45474e5ba8b46c`, hitting `http://example.com` will 302 redirect to `http://example.com/What-s-New-157765353f2c4705bd45474e5ba8b46c`.
