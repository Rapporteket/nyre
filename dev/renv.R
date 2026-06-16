Sys.setenv(FALK_EXTENDED_USER_RIGHTS = "[
{\"A\":80,\"R\":\"SC\",\"U\":111},
{\"A\":80,\"R\":\"LU\",\"U\":111},
{\"A\":81,\"R\":\"LC\",\"U\":111},
{\"A\":80,\"R\":\"SC\",\"U\":222},
{\"A\":80,\"R\":\"LC\",\"U\":222},
{\"A\":81,\"R\":\"LC\",\"U\":222},
{\"A\":80,\"R\":\"SC\",\"U\":333},
{\"A\":80,\"R\":\"LC\",\"U\":333},
{\"A\":81,\"R\":\"LC\",\"U\":333}
]")
Sys.setenv(FALK_APP_ID = "80")

Sys.setenv(MYSQL_DB_LOG = "raplog")
Sys.setenv(MYSQL_DB_AUTOREPORT = "autoreport")
Sys.setenv(MYSQL_DB_DATA = "nyre")
Sys.setenv(MYSQL_HOST = "db")
Sys.setenv(MYSQL_USER = "root")
Sys.setenv(MYSQL_PASSWORD = "root")

Sys.setenv(SHINYPROXY_USERNAME = "rapporteket")
Sys.setenv(SHINYPROXY_APPID = "nyre")
Sys.setenv(FALK_USER_FULLNAME = "Rapp O. R. Teket")
Sys.setenv(FALK_USER_EMAIL = "rapporteket@skde.no")
Sys.setenv(FALK_USER_PHONE = "+4747474747")
