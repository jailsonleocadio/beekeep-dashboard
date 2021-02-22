ui = f7Page(
  title = "Beekeep Dashboard", 
  preloader = FALSE, 
  loading_duration = 3,
  allowPWA = FALSE,

  options = list(
    theme = c("auto"),
    dark = FALSE,
    filled = FALSE,
    color = "#007aff",
    touch = list(
      tapHold = TRUE,
      tapHoldDelay = 750,
      iosTouchRipple = FALSE
    ),
  
    iosTranslucentBars = FALSE,
    navbar = list(
      iosCenterTitle = TRUE,
      hideNavOnPageScroll = TRUE
    ),
  
    toolbar = list(hideNavOnPageScroll = FALSE),
    pullToRefresh = FALSE
  ),

  f7TabLayout(
    navbar = f7Navbar(
      subNavbar = NULL,
      title = NULL,
      subtitle = NULL,
      hairline = TRUE,
      shadow = TRUE,
      bigger = FALSE,
      transparent = FALSE,
      leftPanel = TRUE,
      rightPanel = FALSE
    ),
    
    panels = tagList(
      f7Panel(
        side = "left",
        id = "leftpanel",
        theme = c("light"),
        effect = "cover",
        resizable = TRUE,
      
        f7BlockTitle(title = "Filtro de dados", size = 'medium'),
        
        f7Card(
          f7Select(inputId = "species",
                   label="Espécie:",
                   choices = c("Todas", unique(as.character(data$species)))
          ),
          
          f7Slider(
            inputId = "temperature",
            label = "Temperatura:",
            max = as.integer(max(data$temperature)) - 1,
            min = as.integer(min(data$temperature)) + 1,
            value = c(8, 35),
            step = 0.5,
            scale = TRUE,
            scaleSteps = 2
          ),
          
          f7Select(inputId = "weather",
                   label = "Condição do céu:",
                   choices = c("Todas", unique(as.character(data$weather)))
          ),
          
          f7Select(inputId = "area",
                   label = "Área:",
                   choices = c("Todas", unique(as.character(data$area)))
          ),
          
          f7DatePicker(
            inputId = "date1",
            label = "De:",
            value = as.Date("2020-07-23")+1,
            multiple = FALSE
          ),
          
          f7DatePicker(
            inputId = "date2",
            label = "Até:",
            value = Sys.Date()+1,
            multiple = FALSE
          )
        )
      ),
    ),
    
    f7Tabs(animated=TRUE, id="tabs", style = c("toolbar"),
      f7Tab(
        tabName = "Gráficos",
        icon = f7Icon("chart_pie"),
        active = TRUE,

        f7BlockTitle(title = "Gráficos de atividade", size = 'medium'),
        
        f7Accordion(
          multiCollapse = TRUE,
          f7AccordionItem(
            title = "Atividade por horário",
            f7Card(
              apexchartOutput("activity.hour")
            )
          ),
          
          f7AccordionItem(
            title = "Atividade por temperatura",
            f7Card(
              apexchartOutput("activity.temperature")
            )
          ),
          
          f7AccordionItem(
            title = "Atividade por condição do céu",
            f7Card(
              apexchartOutput("activity.weather")
            )
          )
          
          #f7AccordionItem(
          #  title = "Pólen por entrada",
          #  f7Card(
          #    apexchartOutput("pollen.entrance")
          #  )
          #)
        )
      ),
      
      f7Tab(
        tabName = "Mapa",
        icon = f7Icon("map"),

        tags$style(type = "text/css", "#map {height: calc(85vh) !important;}"),
        leafletOutput(outputId = "map")
      ),
      
      f7Tab(
        tabName = "Info",
        icon = f7Icon("info_circle"),

        f7BlockTitle(title = "Informações", size = 'medium'),
        
        f7Card(
          textOutput("number.observations"),
          textOutput("number.cc"),
          textOutput("number.activities"),
          textOutput("mean.activity"),
          textOutput("number.pollen"),
          textOutput("rate.pollen")
        )
      ),
      
      f7Tab(
        tabName = "Perfil",
        icon = f7Icon("person_alt"),
        
        f7BlockTitle(title = "Perfil", size = 'large'),
        f7BlockTitle(title = "Informações pessoais", size = 'medium'),
        f7BlockTitle(title = "Questionário", size = 'medium'),
        f7BlockTitle(title = "Sobre", size = 'medium')
        
      )
    )
  )
)
