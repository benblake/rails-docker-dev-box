FROM ruby:latest

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    sqlite3 \
    libsqlite3-dev \
    default-mysql-server \
    default-libmysqlclient-dev \
    postgresql \
    postgresql-client \
    postgresql-contrib \
    libpq-dev \
    redis-server \
    memcached \
    imagemagick \
    ffmpeg \
    mupdf \
    mupdf-tools \
    libxml2-dev \
    yarn

WORKDIR /usr/src/rails

RUN gem install bundler

COPY Gemfile* rails.gemspec RAILS_VERSION package.json yarn.lock ./
COPY actioncable/actioncable.gemspec actioncable/package.json ./actioncable/
COPY actionmailbox/actionmailbox.gemspec ./actionmailbox/
COPY actionmailer/actionmailer.gemspec ./actionmailer/
COPY actionpack/actionpack.gemspec ./actionpack/
COPY actiontext/actiontext.gemspec actiontext/package.json ./actiontext/
COPY actionview/actionview.gemspec actionview/package.json ./actionview/
COPY activejob/activejob.gemspec ./activejob/
COPY activemodel/activemodel.gemspec ./activemodel/
COPY activerecord/activerecord.gemspec ./activerecord/
COPY activestorage/activestorage.gemspec activestorage/package.json ./activestorage/
COPY activesupport/activesupport.gemspec ./activesupport/
COPY railties/railties.gemspec ./railties/

RUN bundle install \
 && yarn install

COPY . ./

ENTRYPOINT ["tail", "-f", "/dev/null"]
