FROM ubuntu:14.04.2
MAINTAINER Rémi Emonet <remi.emonet@reverse--com.heeere>

RUN apt-get update && apt-get install -y wget xvfb pdfjam pdftk

# to get the system dependencies (and firefox itself so we can get the "light" version of slimerjs)
RUN apt-get install -y firefox unzip zip

RUN wget --quiet https://github.com/laurentj/slimerjs/archive/master.zip -O master.zip && unzip -q master.zip && rm master.zip

RUN wget --quiet https://github.com/twitwi/decktape/archive/master.zip -O master.zip && unzip -q master.zip && rm master.zip

# to avoid cups problems with slimerjs (.render() that freezes), we install a cups server locally
RUN apt-get install -y cups-daemon 
RUN /etc/init.d/cups start 

COPY ./entrypoint.sh /decktape-master/decktape.sh

WORKDIR decktape-master
ENTRYPOINT ["/decktape-master/decktape.sh"]
