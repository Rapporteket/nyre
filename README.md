<!-- badges: start -->
[![Version](https://img.shields.io/github/v/release/rapporteket/nyre?sort=semver)](https://github.com/rapporteket/nyre/releases)
[![R build status](https://github.com/rapporteket/nyre/workflows/R-CMD-check/badge.svg)](https://github.com/rapporteket/nyre/actions)
[![Codecov test coverage](https://codecov.io/gh/Rapporteket/nyre/branch/main/graph/badge.svg)](https://codecov.io/gh/Rapporteket/nyre?branch=main)
[![Lifecycle: maturing](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://www.tidyverse.org/lifecycle/#maturing)
[![GitHub open issues](https://img.shields.io/github/issues/rapporteket/nyre.svg)](https://github.com/rapporteket/nyre/issues)
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
<!-- badges: end -->
  
# Nyre <img src="man/figures/logo.svg" align="right" height="150" />


## Bygg docker image lokalt

For å bygge og kjøre docker image lokalt kan man gjøre følgende:

1. Bygg pakken til en `tar.gz`-fil
```sh
R CMD build .
```
2. Lag Github Personal Access Token. Dette kan enten gjøres direkte på github (https://github.com/settings/tokens) eller gjennom R (`usethis::create_github_token()`). Det tryggeste er å *ikke* gi den noe særlig med rettigheter (kun lese). Vi lager og bruker en token for å ikke få feil fordi man har for mange api-kall til github.
3. Putt den i miljøvariablen `GITHUB_PAT`.
```sh
export GITHUB_PAT=ghp_ETT_ELLER_ANNET # token du nettop lagde
```
4. Bygg image med navn `some_image_name`. Bruker `--progress plain` for å få ut alt av `stdout`, og mater inn token som en hemmelighet
```sh
docker build -t some_image_name --progress plain --secret id=GITHUB_PAT .
```
5. Kjør image
```sh
# enten
docker run -p 3838:3838 some_image_name
# eller
docker compose up
```
6. Åpne siden http://localhost:3838/ og se resultatet

## Docker compose

Ved å bruke vedlagt `docker-compose.yml`-fil kan man få opp et miljø med databaser (både mysql og mssql), RStudio og Adminer. I tillegg kjøres det i gang en container basert på applikasjonens docker-image som er dyttet opp til docker-hub. Dette miljøet vil ligne på produksjonsmiljøet.

For å kjøre opp dette miljøet kan man gjøre følgende i en terminal
```bash
docker compose up
```
<kbd>Ctrl</kbd> + <kbd>c</kbd> for å slå av igjen. Data du eventuelt har lagt inn i databasen og pakker du har installert i RStudio vil som regel fremdeles være der neste gang du snurrer opp miljøet, så lenge du ikke har kjørt en `docker compose down` (slette containere) eller `docker compose pull` (oppdatere image).

RStudio vil kunne nås på http://localhost:8787/, app-imaget vil nås på http://localhost:3838/ og Adminer vil nås på http://localhost:8888/.

### mssql

For å logge inn på mssql-server i Adminer (http://localhost:8888/) brukes brukernavn `sa`, server `mssql` og passord `Your_password123`. De to sistnevnte er definert i `docker-compose.yml`-fila. Databasenavn kan stå tomt. System må settes til `MS SQL`.

### mysql

For å logge inn på mysql-server i Adminer (http://localhost:8888/) brukes server `db`, brukernavn `root` og passord `root`. Disse er definert i `docker-compose.yml`-fila. Databasenavn kan stå tomt. System må settes til `MySQL/MariaDB`.
