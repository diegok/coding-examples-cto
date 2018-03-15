FROM    perl:5.26.1
LABEL   authors="Diego Kuperman <diego@soysuper.com>"
RUN     cpanm -n Carton
WORKDIR /opt/worker
COPY    ./cpanfile cpanfile
COPY    ./shared   shared
COPY    ./worker   worker
RUN     carton install

RUN groupadd -r xman -g 1001 \
 && useradd -u 1001 -r -g xman -d /opt/worker/ -s /sbin/nologin -c "Docker image user" xman \
 && chown -R xman:xman /opt/worker/

USER   1001
ENTRYPOINT carton exec ./worker
