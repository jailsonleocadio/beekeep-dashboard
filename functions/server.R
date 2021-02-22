server = function(input, output, session) {
  rv = reactiveValues(data = data)
  
  observeEvent(c(input$species, input$temperature, input$weather, input$area, input$date1, input$date2), {
    rv$data = data
    
    if (input$species != "Todas") {
      rv$data = rv$data[rv$data$species == input$species,]
    }
    
    rv$data = rv$data[rv$data$temperature >= input$temperature[1] & rv$data$temperature <= input$temperature[2],]
    
    if (input$weather != "Todas") {
      rv$data = rv$data[rv$data$weather == input$weather,]
    }
    
    if (input$area != "Todas") {
      rv$data = rv$data[rv$data$area==input$area,]
    }
    
    rv$data = rv$data[as.Date(rv$data$date.observation) >= as.Date(input$date1) & as.Date(rv$data$date.observation) <= as.Date(input$date2),]
  })
  
  output$activity.hour <- renderApexchart({
    apex(data = rv$data, type = "scatter", mapping = aes(x = hour.observation, y = activity),
         auto_update = TRUE)
  })
  
  output$activity.temperature <- renderApexchart({
    apex(data = rv$data, type = "scatter", mapping = aes(x = temperature, y = activity),
         auto_update = TRUE)
  })
  
  output$activity.weather <- renderApexchart({
    agg = aggregate(rv$data$activity, by=list(rv$data$weather), mean)
    df = data.frame(agg$Group.1, agg$x)
    df$agg.Group.1 = factor(df$agg.Group.1, levels = df[["agg.Group.1"]])
    
    apex(data = df, type = "column", mapping = aes(x = agg.Group.1, y = as.integer(agg.x)),
         auto_update = TRUE)
  })
  
  output$pollen.entrance <- renderApexchart({
    agg1 = aggregate(rv$data[rv$data$invalid.pollen==FALSE, c('entrance')], by=list(rv$data[rv$data$invalid.pollen==FALSE, c('hour.observation')]), mean)
    agg2 = aggregate(rv$data[rv$data$invalid.pollen==FALSE, c('pollen')], by=list(rv$data[rv$data$invalid.pollen==FALSE, c('hour.observation')]), mean)
    
    agg1$type = 'Entrada'
    agg2$type = 'Pólen'
    
    dt = rbind(agg1, agg2)
    
    apex(data = dt, type = "column", mapping = aes(x = Group.1, y = as.integer(x), fill = type),
         auto_update = TRUE)
  })
  
  output$map = renderLeaflet({
    palette = colorFactor(
      palette = c("#66C2A5", "#FC8D62", "#8DA0CB"),
      domain = rv$data$area
    )
    
    leaflet(rv$data) %>%
      setView(lng = -55, lat = -12, zoom = 3) %>%
      addTiles() %>%
      addCircles(data = rv$data,
                 lat = ~ random.latitude,
                 lng = ~ random.longitude,
                 radius = 10000,
                 weight = 10,
                 color =  ~palette(area),
                 popup = paste("<b> Espécie:</b> ", rv$data$species, "<br/>",
                               "<b> Saídas:</b> ", rv$data$exit, "<br/>",
                               "<b> Entradas:</b> ", rv$data$entrance, "<br/>",
                               "<b> Temperatura:</b> ", rv$data$temperature, "ºC <br/>",
                               "<b> Condição do céu:</b> ", rv$data$weather, "<br/>",
                               "<b> Área:</b> ", rv$data$area, "<br/>")) %>%
      addLegend("topright", pal = palette, values = ~area,
                title = "Área",
                opacity = 1
      )
  })
  
  output$number.observations = renderText({paste("Número de contribuições: ", nrow(rv$data))})
  output$number.cc = renderText({paste("Número de cientistas cidadãos: ", length(unique(rv$data$email)))})
  output$number.activities = renderText({paste("Número de atividades: ", sum(rv$data$entrance, rv$data$exit))})
  output$mean.activity = renderText({paste("Média de atividade: ", mean(rv$data$entrance + rv$data$exit))})
  output$number.pollen = renderText({paste("Número de pólens: ", sum(rv$data$pollen))})
  output$rate.pollen = renderText({paste("Taxa de pólen: ", sum(rv$data$pollen)/sum(rv$data$pollen, rv$data$entrance))})

  observeEvent(input$test, {
    print(input$menu1)
    updateF7Tabs(session = session, id = 'tabs', selected = 'Sobre')
  })
  
}
