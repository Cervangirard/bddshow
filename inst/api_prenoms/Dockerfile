FROM rocker/r-ver:4.0.3
RUN apt-get update && apt-get install -y  git-core libcurl4-openssl-dev libgit2-dev libicu-dev libpq-dev libsodium-dev libssl-dev libxml2-dev make pandoc pandoc-citeproc && rm -rf /var/lib/apt/lists/*
RUN echo "options(repos = c(CRAN = 'https://cran.rstudio.com/'), download.file.method = 'libcurl', Ncpus = 4)" >> /usr/local/lib/R/etc/Rprofile.site
RUN R -e 'install.packages("remotes")'
RUN Rscript -e 'remotes::install_version("magrittr",upgrade="never", version = "2.0.1")'
RUN Rscript -e 'remotes::install_version("tibble",upgrade="never", version = "3.1.2")'
RUN Rscript -e 'remotes::install_version("htmltools",upgrade="never", version = "0.5.1.1")'
RUN Rscript -e 'remotes::install_version("promises",upgrade="never", version = "1.2.0.1")'
RUN Rscript -e 'remotes::install_version("httr",upgrade="never", version = "1.4.2")'
RUN Rscript -e 'remotes::install_version("purrr",upgrade="never", version = "0.3.4")'
RUN Rscript -e 'remotes::install_version("stringr",upgrade="never", version = "1.4.0")'
RUN Rscript -e 'remotes::install_version("ggplot2",upgrade="never", version = "3.3.3")'
RUN Rscript -e 'remotes::install_version("lubridate",upgrade="never", version = "1.7.9.2")'
RUN Rscript -e 'remotes::install_version("DBI",upgrade="never", version = "1.1.1")'
RUN Rscript -e 'remotes::install_version("shiny",upgrade="never", version = "1.6.0")'
RUN Rscript -e 'remotes::install_version("config",upgrade="never", version = "0.3.1")'
RUN Rscript -e 'remotes::install_version("thematic",upgrade="never", version = "0.1.2.1")'
RUN Rscript -e 'remotes::install_version("RPostgres",upgrade="never", version = "1.3.1")'
RUN Rscript -e 'remotes::install_version("plumber",upgrade="never", version = "1.0.0")'
RUN Rscript -e 'remotes::install_version("golem",upgrade="never", version = "0.3.1")'
RUN Rscript -e 'remotes::install_version("future",upgrade="never", version = "1.21.0")'
RUN Rscript -e 'remotes::install_version("DT",upgrade="never", version = "0.18")'
RUN Rscript -e 'remotes::install_version("dplyr",upgrade="never", version = "1.0.6")'
RUN Rscript -e 'remotes::install_github("Cervangirard/journuit@cabfeca1b14a275e290375e462323e423b08fa56")'
RUN Rscript -e 'remotes::install_github("hadley/emo@3f03b11491ce3d6fc5601e210927eff73bf8e350")'
RUN mkdir /build_zone
ADD . /build_zone
WORKDIR /build_zone
RUN R -e 'remotes::install_local(upgrade="never")'
RUN rm -rf /build_zone
EXPOSE 9223
CMD R -e "bddshow::run_api()"
