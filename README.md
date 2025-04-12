# PHP 8.3-FPM Docker Image com Suporte a MySQL e Oracle

Imagem customizada baseada em `php:8.3-fpm`, preparada para aplicações PHP que utilizam MySQL e Oracle, com suporte a localização brasileira (pt_BR.UTF-8).

## ✅ Recursos incluídos

- PHP 8.3 com FPM
- Extensões PHP instaladas:
  - `intl`
  - `mysqli`
  - `pdo_mysql`
  - `gd`
  - `zip`
  - `pdo_oci`
  - `oci8` (Oracle)
- Oracle Instant Client 21.6
- Composer (última versão)
- NPM
- Suporte a locale `pt_BR.UTF-8`

## 🧱 Build da imagem

Para construir a imagem, execute:

```bash
docker build -t minha-imagem-php83 .
```

## 🐋 Imagem disponível do dockerHub
```bash
docker push luizzandrade/php8.3-oracle216000:latest
```