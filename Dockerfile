FROM python:3-slim

ARG DEBIAN_FRONTEND=noninteractive

WORKDIR /usr/src

RUN useradd -u 5678 py

RUN chown -R py:py /usr/src
RUN chown -R py:py /usr/local

RUN apt-get update && apt-get install -y git

USER py

RUN git clone https://github.com/Bemmu/PyNamecheap.git

RUN python -m pip install --upgrade pip --no-cache-dir

WORKDIR /usr/src/PyNamecheap

RUN pip3 install -r requirements.txt --no-cache-dir
RUN python3 setup.py install

WORKDIR /usr/src

RUN printf '#!/bin/bash\n\n'"printf '"'#!/usr/bin/env python\\n\\n'"'\"api_key = '\${API_KEY}'"'\\n'"username = '\${USERNAME}'"'\\n'"ip_address = '\${IP_ADDRESS}'\" > PyNamecheap/credentials.py\npython3 PyNamecheap/namecheap-api-cli \$*" > start.sh
RUN chmod +x start.sh

ENTRYPOINT ["./start.sh"]
