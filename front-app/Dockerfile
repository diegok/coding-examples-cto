FROM    perl:5.26.1
LABEL   authors="Diego Kuperman <diego@soysuper.com>"
RUN     cpanm -n Carton
WORKDIR /opt/front-app
COPY    ./cpanfile cpanfile
COPY    ./front    front
COPY    ./shared   shared
RUN     carton install

RUN groupadd -r xman -g 1001 \
 && useradd -u 1001 -r -g xman -d /opt/front-app/ -s /sbin/nologin -c "Docker image user" xman \
 && chown -R xman:xman /opt/front-app/

USER   1001
EXPOSE 8080
ENTRYPOINT ["carton", "exec", "morbo", "front"]
