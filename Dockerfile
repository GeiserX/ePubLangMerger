FROM --platform=linux/amd64 rocker/shiny:4.5

RUN apt-get update && apt-get install -y --no-install-recommends \
    libxml2-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

RUN R -e "install.packages(c('XML', 'stringr', 'readr', 'devtools'))" \
    && R -e "devtools::install_github('omegahat/Rcompression')"

# Remove default Shiny examples
RUN rm -rf /srv/shiny-server/*

COPY server.R ui.R utils.R /srv/shiny-server/
COPY www/ /srv/shiny-server/www/

RUN chown -R shiny:shiny /srv/shiny-server

EXPOSE 3838

CMD ["/usr/bin/shiny-server"]
