FROM php:8.3-fpm

# Arguments
ARG user=usuario
ARG uid=1000
WORKDIR /var/www

# ENV TZ=America/Porto_Velho
# RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && apt-get install -y \
    locales \
    libicu-dev \
    && docker-php-ext-install intl \
    && apt-get clean

RUN echo "pt_BR.UTF-8 UTF-8" >> /etc/locale.gen && \
    locale-gen pt_BR.UTF-8 && \
    update-locale LANG=pt_BR.UTF-8

ENV LANG pt_BR.UTF-8
ENV LANGUAGE pt_BR:pt
ENV LC_ALL pt_BR.UTF-8

RUN docker-php-ext-install mysqli pdo_mysql

# Install packages
RUN apt-get update && apt-get install -y \
        libpng-dev \
        zlib1g-dev \
        libxml2-dev \
        libzip-dev \
        libonig-dev \
        zip \
        curl \
        unzip \
    && docker-php-ext-configure gd \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install mysqli \
    && docker-php-ext-install zip \
    && docker-php-source delete


### INSTALANDO ORACLE
RUN apt-get install -y libaio1
RUN mkdir /opt/oracle
# Install Oracle Instantclient
ADD https://download.oracle.com/otn_software/linux/instantclient/216000/instantclient-basic-linux.x64-21.6.0.0.0dbru.zip /tmp/
ADD https://download.oracle.com/otn_software/linux/instantclient/216000/instantclient-sdk-linux.x64-21.6.0.0.0dbru.zip /tmp/
ADD https://download.oracle.com/otn_software/linux/instantclient/216000/instantclient-sqlplus-linux.x64-21.6.0.0.0dbru.zip /tmp/

RUN unzip /tmp/instantclient-basic-linux.x64-21.6.0.0.0dbru.zip -d /opt/oracle \
&& unzip /tmp/instantclient-sdk-linux.x64-21.6.0.0.0dbru.zip -d /opt/oracle \
&& unzip /tmp/instantclient-sqlplus-linux.x64-21.6.0.0.0dbru.zip -d /opt/oracle \
&& rm -rf *.zip \
&& mv /opt/oracle/instantclient_21_6 /opt/oracle/instantclient

#add oracle instantclient path to environment
ENV LD_LIBRARY_PATH /opt/oracle/instantclient/
RUN ldconfig

# Install Oracle extensions
RUN docker-php-ext-configure pdo_oci --with-pdo-oci=instantclient,/opt/oracle/instantclient,21.1 \
&& echo 'instantclient,/opt/oracle/instantclient/' | pecl install oci8-3.4.0 \
&& docker-php-ext-install \
        pdo_oci \
&& docker-php-ext-enable \
        oci8

### somente para versões superior a 19
RUN echo "DISABLE_OOB=ON" > /opt/oracle/instantclient/network/admin/sqlnet.ora
### FIM INSTALANDO ORACLE

# ## NPM
RUN apt  update -y
RUN apt install sudo -y
RUN apt-get install -y \
    software-properties-common \
    npm

COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

RUN useradd -G www-data,root -u $uid -d /home/$user $user
RUN mkdir -p /home/$user/.composer && \
    chown -R $user:$user /home/$user

USER ${user}
EXPOSE 9000