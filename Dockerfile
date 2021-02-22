FROM openanalytics/r-base

RUN apt-get update && apt-get install -y \
  build-essential \
  libcurl4-gnutls-dev \
  libxml2-dev \
  libssl-dev

RUN R -e "install.packages(c('shiny', 'shinyMobile', 'apexcharter', 'stringr', 'dplyr'), repos='https://cloud.r-project.org/')"

RUN mkdir /root/app

COPY . /root/app

COPY Rprofile.site /usr/lib/R/etc/

EXPOSE 3838

CMD ["R", "-e", "shiny::runApp('/root/app')"]
