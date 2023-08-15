# OpenSIPS Docker

Edit variables:

```makefile
NAME ?= sbc
OPENSIPS_VERSION ?= 3.2
OPENSIPS_BUILD ?= releases
OPENSIPS_DOCKER_TAG ?= minhbv3.2
OPENSIPS_CLI ?= true
OPENSIPS_EXTRA_MODULES ?= opensips-*
DOCKER_ARGS ?=
```

Edit network, port, volume…

```bash
start:
	docker run -it -d --restart always --name $(NAME) -p 5060:5060/udp opensips/opensips:$(OPENSIPS_DOCKER_TAG)
```

Buid image **opensips/opensips:minhbv3.2:**

```bash
sudo make build
```

Start container:

```bash
sudo make start
```

Buid image + start container:

```bash
sudo make all
```

Restart container:

```bash
sudo docker restart sbc
```

Log container:

```bash
sudo docker logs -f sbc
```

Remove container:

```bash
sudo docker rm -f sbc
```

Remove image:

```bash
sudo docker image rm opensips/opensips:minhbv3.2
```
