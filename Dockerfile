FROM ubuntu:14.04
MAINTAINER Graham Gilbert "graham@grahamgilbert.com"

RUN apt-get -y install wget
RUN wget https://apt.puppetlabs.com/puppetlabs-release-pc1-trusty.deb
RUN dpkg -i puppetlabs-release-pc1-trusty.deb
RUN apt-get update
RUN apt-get -y install puppet ruby ruby-dev build-essential git
RUN echo "gem: --no-ri --no-rdoc" > ~/.gemrc
RUN gem install --no-rdoc --no-ri librarian-puppet

ADD Puppetfile /
RUN librarian-puppet install
ADD puppetdb.pp /
RUN puppet apply --modulepath=/modules puppetdb.pp

EXPOSE 8080 8081 8082

CMD /usr/lib/jvm/java-7-openjdk-amd64/bin/java -cp /usr/share/puppetdb/puppetdb.jar clojure.main -m com.puppetlabs.puppetdb.core services -c /etc/puppetdb/conf.d
