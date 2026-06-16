<!-- badges: start -->
[![Version](https://img.shields.io/github/v/release/rapporteket/rapRegTemplate?sort=semver)](https://github.com/rapporteket/rapRegTemplate/releases)
[![R build status](https://github.com/rapporteket/rapRegTemplate/workflows/R-CMD-check/badge.svg)](https://github.com/rapporteket/rapRegTemplate/actions)
[![Codecov test coverage](https://codecov.io/gh/Rapporteket/rapRegTemplate/branch/main/graph/badge.svg)](https://codecov.io/gh/Rapporteket/rapRegTemplate?branch=main)
[![Lifecycle: maturing](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://www.tidyverse.org/lifecycle/#maturing)
[![GitHub open issues](https://img.shields.io/github/issues/rapporteket/rapRegTemplate.svg)](https://github.com/rapporteket/rapRegTemplate/issues)
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![Doc](https://img.shields.io/badge/Doc--grey.svg)](https://rapporteket.github.io/rapRegTemplate/)
<!-- badges: end -->
  
# Lag et register i Rapporteket <img src="man/figures/logo.svg" align="right" height="150" />

Beskrivelsen under er ikke nødvendigvis utfyllende og forutsetter kjennskap til R og bruk av git og GitHub.
Som en ekstra støtte anbefales [R pacakges](http://r-pkgs.had.co.nz/) av Hadley Wickham og spesielt [beskrivelsen av git og GitHub](http://r-pkgs.had.co.nz/git.html#git-rstudio).

## Prøv templatet

1. Hent ned prosjektet [rapRegTemplate](https://github.com/Rapporteket/rapRegTemplate) (`git clone https://github.com/Rapporteket/rapRegTemplate.git` i en terminal).
1. Åpne prosjektet i RStudio (åpne fila `rapRegTemplate.Rproj`)
1. Installér pakken (`devtools::install()`)
1. Definer noen miljøvariabler (`source("dev/renv.R")`)
1. Start Shiny-applikasjonen (`run_app(browser = TRUE)`)
1. Navigér i applikasjonen for å se på struktur og farger (innhold mangler)

## Lag ditt eget prosjekt basert på templatet

Denne delen kan være relevant om det er ønskelig å benytte templatetet som utgangspunkt for etablering av nye registre på Rapporteket.

1. Hent ned prosjektet [rapRegTemplate](https://github.com/Rapporteket/rapRegTemplate)
2. Slett mappen `.git`
3. Initiér nytt git-repositor 
```bash
  git init .
  git add .
  git commit -m "init commit"
  ```
4. Erstatt `rapRegTemplate` med valgfritt pakkenavn i koden og rydd i prosjektet (f.eks. ved bruk av *vscode*).
5. Bygg, installér og last pakken i R
6. Test gjerne at innebygget Shiny-applikasjon fungerer på samme vis som i prosjektet "rapRegTemplate"

## Sjekk inn endringer i git
Git er et verktøy for versjonskontroll som gir mulighet for å spore endringer og samarbeide om kode. Basale funksjoner i git er svært nyttinge, men kan virke forvirrende i starten. Sørg for at egen kode (bestandig) versjonshåndteres (i git) og at koden finnes sentralisert og tilgjengelig for deg selv og andre (på GitHub).

1. Sett opp git lokalt og etabler et sentralt repository for din R-pakke gjennom å følge [Hadley Wickhams veiledning](http://r-pkgs.had.co.nz/git.html#git-rstudio)
1. Om du ikke har det fra før, etabler et ssh-nøkkelpar for sikker kommunikasjon med GitHub


## Dytt (push) R-pakken til GitHub
1. Om du ikke allerede har gjort det, lag din egen bruker på GitHub (se over)
1. Om du ikke allerede har gjort det, [legg ut den offentlige delen av ditt ssh-nøkkelpar på din github-konto](https://help.github.com/en/articles/adding-a-new-ssh-key-to-your-github-account) 
1. Om du ikke allerede har gjort det, bli medlem av organisasjonen Rapporteket på GitHub
1. Under din egen side på GitHub, opprett et Repository med navn tilsvarende din egen pakke (_e.g._ "testRegister")
1. I RStudio, push pakken til ditt nye Repository på GitHub

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
