# by Jailson Leocadio
# jailsonleocadio@gmail.com
# Beekeep team (http://beekeep.life)

library(shiny)
library(shinyMobile)
library(apexcharter)
library(leaflet)

source("database/database.R")
source("ui/ui.R")
source("functions/server.R")

shinyApp(ui = ui, server = server)
