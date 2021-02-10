# To build image
# docker build --no-cache -t web:latest -f web/Dockerfile .
# To remove images
# docker rmi -f $(docker images -a -q)

FROM brettt89/silverstripe-web:7.4-apache

RUN install-php-extensions mysqli xdebug

RUN set -eux; \
        apt-get update && apt-get install -qqy default-mysql-client iputils-ping wget locales

# Set encoding for SASS
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
    && locale-gen \
    && update-locale

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8

RUN set -eux; \
        wget https://github.com/mailhog/mhsendmail/releases/download/v0.2.0/mhsendmail_linux_amd64 && \
        chmod +x mhsendmail_linux_amd64 && \
        mv mhsendmail_linux_amd64 /usr/local/bin/mhsendmail

# Custom PHP Configurations
RUN echo "sendmail_path = \"/usr/local/bin/mhsendmail --smtp-addr=mail:1025\"" > /usr/local/etc/php/conf.d/sendmail.ini; \
    echo "memory_limit = 512M" > /usr/local/etc/php/conf.d/memory.ini && \
    echo "upload_max_filesize = 100M" >> /usr/local/etc/php/conf.d/memory.ini && \
    echo "post_max_size = 100M" >> /usr/local/etc/php/conf.d/memory.ini && \
    echo "max_execution_time = 300" >> /usr/local/etc/php/conf.d/memory.ini; \
    echo "error_reporting = E_ALL" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
    echo "display_startup_errors = On" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
    echo "display_errors = On" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
    echo "xdebug.mode = debug" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
    echo "xdebug.start_with_request = yes" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
    echo "xdebug.client_host = host.docker.internal" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
    composer self-update --1

RUN curl -sS https://silverstripe.github.io/sspak/install | php -- /usr/local/bin

RUN apt-get autoremove -y && rm -r /var/lib/apt/lists/*
