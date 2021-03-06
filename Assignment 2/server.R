#
# This is the server logic of a Shiny web application.
#


server <- function(input, output, session) {
  
  ## general data
  
  team_season <- reactive({
    get_games_by_season(as.numeric(input$seasonInput2))
  })
  
  
  player_season_avg <- reactive({
    get_players_by_season_pergame(as.numeric(input$seasonInput4))
  })
  
  
  ## team comparison data
  
  team_season1 <- reactive({
    get_games_by_season(as.numeric(input$seasonInput5))
  })
  
  team_vs_team <- eventReactive(input$teamCompareBtnInput, {
    t1_all <- get_team_seasons(get_teamID_from_name(input$team1Input, team_season1()))
    t2_all <- get_team_seasons(get_teamID_from_name(input$team2Input, team_season1()))
    t1 <- get_team_single_season(as.numeric(input$seasonInput5), t1_all)
    t2 <- get_team_single_season(as.numeric(input$seasonInput5), t2_all)
    
    rbind(t1, t2)
  })
  
  team_img1 <- eventReactive(input$teamCompareBtnInput, {
    get_team_logo(get_team_abbr_from_name(input$team1Input, team_season1()))
  })
  
  
  team_img2 <- eventReactive(input$teamCompareBtnInput, {
    get_team_logo(get_team_abbr_from_name(input$team2Input, team_season1()))
  })
  
  team_info1 <- eventReactive(input$teamCompareBtnInput, {
    tvst <- team_vs_team()
    team_name <- paste(tvst[1, 2], tvst[1, 3], sep = " ")
    
    team_name
  })
  
  team_info2 <- eventReactive(input$teamCompareBtnInput, {
    tvst <- team_vs_team()
    team_name <- paste(tvst[2, 2], tvst[2, 3], sep = " ")
    
    team_name
  })
  
  
  ## player comparison data 
  
  player_totals <- reactive({
    get_players_by_season_total(as.numeric(input$seasonInput1))
  })
  
  player_vs_player <- eventReactive(input$playerCompareBtnInput, {
    p1 <- get_player_table(input$player1Input, player_totals())
    p2 <- get_player_table(input$player2Input, player_totals())
    
    rbind(p1, p2)
  })
  
  
  player_img1 <- eventReactive(input$playerCompareBtnInput, {
    get_pic_link(input$player1Input)
  })
  
  player_img2 <- eventReactive(input$playerCompareBtnInput, {
    get_pic_link(input$player2Input)
    
  })
  
  player_info1 <- eventReactive(input$playerCompareBtnInput, {
    pvsp <- player_vs_player()
    age1 <- get_player_age(pvsp[1, ])
    team1 <- get_player_team(pvsp[1, ])
    
    cbind(team1, age1, row.names = NULL)
  })
  
  player_info2 <- eventReactive(input$playerCompareBtnInput, {
    pvsp <- player_vs_player()
    age2 <- get_player_age(pvsp[2, ])
    team2 <- get_player_team(pvsp[2, ])
    
    cbind(team2, age2, row.names = NULL)
  })
  
  
  ## team analysis data
  
  one_team_data <- eventReactive(input$teamInput1, {
    get_team_games_data(team_season(), input$teamInput1)
    
  })
  
  
  ## player analysis data
  
  player_totals1 <- reactive({
    get_players_by_season_total(as.numeric(input$seasonInput4))
  })
  
  player_shots <- eventReactive(input$playerInput3, {
    shots_data <- get_player_shots(get_playerID_from_name(input$playerInput3, player_totals1()),
                                   as.numeric(input$seasonInput4))
  })

  
  player_name <- eventReactive(input$playerInput3, {
    input$playerInput3
  })
  
  player_img3 <- eventReactive(input$playerInput3, {
    get_pic_link(input$playerInput3)
  })
  
  player_info <- eventReactive(input$playerInput3, {
    player <- get_player_table(input$playerInput3, player_totals1())
    
    age <- get_player_age(player)
    team <- get_player_team(player)
    
    cbind(team, age, row.names = NULL)
  })
  
  court_image <- reactive({
    courtImg.URL <- "https://thedatagame.files.wordpress.com/2016/03/nba_court.jpg"
    court <- rasterGrob(readJPEG(getURLContent(courtImg.URL)),
                        width=unit(1,"npc"), height=unit(1,"npc"))
    court
  })
  
  shotChart1 <- reactive({
    
    shotDataf <- player_shots()
    
    p <- ggplot(shotDataf, aes(x = LOC_X, y = LOC_Y)) + 
      annotation_custom(court_image(), -250, 250, -50, 420) +
      geom_point(aes(colour = SHOT_ZONE_BASIC, shape = EVENT_TYPE)) +
      scale_shape_manual(values = c(21, 4)) +
      xlim(-250, 250) +
      ylim(-50, 420) +
      geom_rug(alpha = 0.2) +
      coord_fixed() +
      ggtitle('Shot Types') +
      theme(line = element_blank(),
            axis.title.x = element_blank(),
            axis.title.y = element_blank(),
            axis.text.x = element_blank(),
            axis.text.y = element_blank(),
            legend.title = element_blank(),
            plot.title = element_text(size = 15, lineheight = 0.9, face = "bold"),
            panel.background = element_rect(fill = "transparent"),
            plot.background = element_rect(fill = "transparent"))
    
    p
  })
  
  shotChart2 <- reactive({
    
    shotDataf <- player_shots()
    
    p <- ggplot(shotDataf, aes(x = LOC_X, y = LOC_Y)) + 
      annotation_custom(court_image(), -250, 250, -52, 418) +
      geom_point(aes(colour = EVENT_TYPE, alpha = 0.8), size = 3) +
      scale_color_manual(values = c("#008000", "#FF6347")) +
      guides(alpha = FALSE, size = FALSE) +
      xlim(250, -250) +
      ylim(-52, 418) +
      geom_rug(alpha = 0.2) +
      coord_fixed() +
      ggtitle("Hit and Miss") +
      theme(line = element_blank(),
            axis.title.x = element_blank(),
            axis.title.y = element_blank(),
            axis.text.x = element_blank(),
            axis.text.y = element_blank(),
            legend.title = element_blank(),
            plot.title = element_text(size = 17, lineheight = 1.2, face = "bold"),
            panel.background = element_rect(fill = "transparent"),
            plot.background = element_rect(fill = "transparent"))
    
    p
  })
  
  shotChart3 <- reactive({
    
    shotDataf <- player_shots()
    
    p <- ggplot(shotDataf, aes(x = LOC_X, y = LOC_Y)) + 
      annotation_custom(court_image(), -250, 250, -52, 418) +
      stat_binhex(bins = 25, colour = "gray", alpha = 0.7) +
      scale_fill_gradientn(colours = c("yellow","orange","red")) +
      guides(alpha = FALSE, size = FALSE) +
      xlim(250, -250) +
      ylim(-52, 418) +
      geom_rug(alpha = 0.2) +
      coord_fixed() +
      ggtitle("Shot Density") +
      theme(line = element_blank(),
            axis.title.x = element_blank(),
            axis.title.y = element_blank(),
            axis.text.x = element_blank(),
            axis.text.y = element_blank(),
            legend.title = element_blank(),
            plot.title = element_text(size = 17, lineheight = 1.2, face = "bold"),
            panel.background = element_rect(fill = "transparent"),
            plot.background = element_rect(fill = "transparent"))
    
    p
  })
  
  shotChart4 <- reactive({
    
    shotDataf <- player_shots()
    
    shotDataS <- shotDataf[which(!shotDataf$SHOT_ZONE_BASIC=='Backcourt'), ]
    shotS <- plyr::ddply(shotDataS, .(SHOT_ZONE_BASIC), summarize, 
                         SHOTS_ATTEMPTED = length(SHOT_MADE_FLAG),
                         SHOTS_MADE = sum(as.numeric(as.character(SHOT_MADE_FLAG))),
                         MLOC_X = mean(LOC_X),
                         MLOC_Y = mean(LOC_Y))
    
    shotS$SHOT_ACCURACY <- (shotS$SHOTS_MADE / shotS$SHOTS_ATTEMPTED)
    shotS$SHOT_ACCURACY_LAB <- paste(as.character(round(100 * shotS$SHOT_ACCURACY, 1)), "%", sep="")
    
    p <- ggplot(shotS, aes(x = MLOC_X, y = MLOC_Y)) + 
      annotation_custom(court_image(), -250, 250, -52, 418) +
      geom_point(aes(colour = SHOT_ZONE_BASIC, size = SHOT_ACCURACY, alpha = 0.8), size = 8) +
      geom_text(aes(colour = SHOT_ZONE_BASIC, label = SHOT_ACCURACY_LAB), vjust = -1.2, size = 5) +
      guides(alpha = FALSE, size = FALSE) +
      xlim(250, -250) +
      ylim(-52, 418) +
      coord_fixed() +
      ggtitle("Shot Accuracy") +
      theme(line = element_blank(),
            axis.title.x = element_blank(),
            axis.title.y = element_blank(),
            axis.text.x = element_blank(),
            axis.text.y = element_blank(),
            legend.title = element_blank(),
            legend.text = element_text(size = 12),
            plot.title = element_text(size = 17, lineheight = 1.2, face = "bold"),
            panel.background = element_rect(fill = "transparent"),
            plot.background = element_rect(fill = "transparent"))
    
    p
  })
  
  # Return the requested graph
  graphInput <- reactive({
    switch(input$chartTypeInput1,
           "Shot Types" = shotChart1(),
           "Hit and Miss" = shotChart2(),
           "Shot Density" = shotChart3(),
           "Shot Accuracy" = shotChart4()
    )
  })
  
  ### Outputs ###
  
  ## general tab
  
  output$win_percentage <- renderPlotly({
    team_season <- team_season()
    team_win <- as.data.frame(table(team_season$team_abbr))
      
    team_win$win <- team_season %>%
      group_by(team_abbr) %>%
      filter(win == T) %>%
      select(win) %>%
      summarise(cnt = n())

    tn <- as.data.frame(table(team_season$team_name))  
    tn$win <- team_season %>%
      group_by(team_name) %>%
      filter(win == T) %>%
      select(win) %>%
      summarise(cnt = n())
    
    tn$Var1 <- reorder(tn$Var1, (tn$win$cnt / tn$Freq) * 100)
    
    team_win$perc <- (team_win$win$cnt / team_win$Freq) * 100
    team_win$Var1 <- reorder(team_win$Var1, team_win$perc)
    team_win$team_name <- tn$Var1
    
    p <- ggplot(team_win, aes(x = Var1, y = perc, 
                              text = paste('Team: ', team_name,
                                           '<br>Win %:', round(perc, digits = 2)))) +
      geom_bar(stat = "identity", aes(fill = Var1)) +
      theme(axis.line = element_blank(),
            axis.text.x = element_blank(),
            axis.ticks = element_blank(),
            legend.position = "none",
            panel.grid.major = element_blank(),
            panel.grid.minor = element_blank(),
            panel.border = element_blank(),
            panel.background = element_rect(fill = "transparent"),
            plot.background = element_rect(fill = "transparent")) +
      scale_fill_viridis_d(direction = -1) +
      xlab("Teams") +
      ylab("Win Percentage") +
      coord_flip() +
      geom_text(size = 3, aes(x = Var1, y = perc + 4 , label = round(perc , 1)))
    
   ggplotly(p, tooltip="text") %>%
     plotly::config(displaylogo = FALSE, 
                    modeBarButtonsToRemove = c("lasso2d", "autoScale2d", "hoverCompareCartesian"))
  })
  
  output$player_distribution <- renderPlotly({
    player_avg <- player_season_avg() %>%
      filter(games > 40)
    
    p <- ggplot(player_avg, aes(x = ast, y = reb,
                                text = paste('Player: ', Player,
                                             '<br>FG%: ', round((fgm/fga * 100), digits = 2),
                                             '<br>Assists: ', round(ast, digits = 2),
                                             '<br>Rebounds: ', round(reb, digits = 2),
                                             '<br>Points: ', round(pts, digits = 2)))) +
      geom_point(size = player_avg$pts/5, color="blue", shape = 21, alpha= 0.5, 
                 aes(fill = player_avg$fgm/player_avg$fga)) +
      scale_fill_gradient(low="#000cff", high="red") +
      coord_flip() +
      theme(axis.line = element_blank(),
            axis.ticks = element_blank(),
            panel.grid.major = element_blank(),
            panel.grid.minor = element_blank(),
            panel.border = element_blank(),
            panel.background = element_rect(fill = "transparent"),
            plot.background = element_rect(fill = "transparent"),
            legend.background =  element_rect(fill = "transparent")) +
      xlab("Assists Per Game") +
      ylab("Rebounds Per Game") +
      labs(fill = "FG%")
      
    
    ggplotly(p, tooltip="text") %>%
      plotly::config(displaylogo = FALSE, 
                     modeBarButtonsToRemove = c("lasso2d", "autoScale2d", "hoverCompareCartesian"))
    
  })
  
  ## team comparison tab
  
  output$teamOutput1 <- renderUI({
    selectInput(inputId = "team1Input",
                "Select team 1:",
                choices = get_team_list(team_season1()))
  })
  
  output$teamOutput2 <- renderUI({
    selectInput(inputId = "team2Input",
                "Select team 2:",
                choices = get_team_list(team_season1()))
  })
  
  output$team1ImgOutput <- renderText({
    c('<center>',
      '<img height="180" width="120" src="',
      team_img1(),
      '">',
      '</center>')
  })
  
  output$team2ImgOutput <- renderText({
    c('<center>',
      '<img height="180" width="120" src="',
      team_img2(),
      '">',
      '</center>')
  })
  
  output$team_info1 <- renderText({
    team_info1()
  })
  
  output$team_info2 <- renderText({
    team_info2()
  })
  
  output$teamCompareBtn <- renderUI({
    HTML(
      '<center><button id="teamCompareBtnInput" class="btn btn-default action-button">Compare</button></center>'
    )
  })
  
  output$teamComparePlot1 <- renderPlotly({
    team_vs_team <- team_vs_team()
    
    teams <- team_vs_team[, c(3, 24, 27:33)]
    teams$FT_PCT <- as.numeric(teams$FT_PCT) * 100
    
    for (i in 2:9) {
      teams[, i] <- as.numeric(teams[, i])
    }
    
    teams[, 1] <- as.factor(unlist(teams[, 1])) 
    
    teams.long <- melt(teams, id.vars = "TEAM_NAME")
    
    p <- ggplot(data = teams.long, aes(x = variable, y = value, fill = TEAM_NAME,
                                       text = paste('Team: ', TEAM_NAME,
                                                    '<br>', variable, 'Value:', value))) +
      geom_col( position = 'dodge') +
      theme(axis.title = element_blank(),
            panel.grid.major = element_blank(),
            panel.grid.minor = element_blank(),
            panel.border = element_blank(),
            panel.background = element_rect(fill = "transparent"),
            plot.background = element_rect(fill = "transparent"),
            legend.background =  element_rect(fill = "transparent")) + 
      labs(fill = "Teams")
    
    ggplotly(p, tooltip="text") %>%
      plotly::config(displaylogo = FALSE, 
                     modeBarButtonsToRemove = c("lasso2d", "autoScale2d", "hoverCompareCartesian"))
    
  })
  
  ## player comparison tab
  
  output$playerOutput1 <- renderUI({
    selectInput(inputId = "player1Input",
                "Select player 1:",
                choices = get_player_list(player_totals()))
  })
  
  output$playerOutput2 <- renderUI({
    selectInput(inputId = "player2Input",
                "Select player 2:",
                choices = get_player_list(player_totals()))
  })
  
  output$playerCompareBtn <- renderUI({
    HTML(
      '<center><button id="playerCompareBtnInput" class="btn btn-default action-button">Compare</button></center>'
    )
  })
  
  output$player1imgOutput <- renderText({
    c('<center>',
      '<img height="180" width="120" src="',
      player_img1(),
      '">',
      '</center>')
  })
  
  output$player2imgOutput <- renderText({
    c('<center>',
      '<img height="180" width="120" src="',
      player_img2(),
      '">',
      '</center>')
  })
  
  output$player_info1 <- renderTable({
    player_info1()
  })
  
  output$player_info2 <- renderTable({
    player_info2()
  })
  
  
  output$playerComparePlot1 <- renderPlotly({
    
    compare_data <- player_vs_player()[c(1, 8:21)]
    
    compare_data.long <- melt(compare_data, id.vars = "Player")
    
    player_list <- c(compare_data[1, 1], compare_data[2, 1])
    
    
    p <- ggplot(data = compare_data.long, aes(x = variable, y = value, fill = Player,
                                              text = paste('Player: ', Player,
                                                           '<br>', variable, 'value:', value))) +
      geom_bar(data = subset(compare_data.long, Player == player_list[1]), 
               stat = "identity",
               mapping = aes(y = -value),
               position = "identity") + 
      geom_bar(data = subset(compare_data.long, Player == player_list[2]), 
               stat = "identity") +
      scale_y_continuous(breaks=seq(-1500, 1500, 100), labels=abs(seq(-1500, 1500, 100))) +
      coord_flip() +
      theme(axis.line = element_blank(),
            axis.ticks = element_blank(),
            legend.title = element_blank(),
            panel.grid.major = element_blank(),
            panel.grid.minor = element_blank(),
            panel.border = element_blank(),
            panel.background = element_rect(fill = "transparent"),
            plot.background = element_rect(fill = "transparent"),
            legend.background =  element_rect(fill = "transparent")) +
      xlab("Player Stats") + ylab(NULL)
    
    ggplotly(p, tooltip="text") %>%
      plotly::config(displaylogo = FALSE, 
                     modeBarButtonsToRemove = c("lasso2d", "autoScale2d", "hoverCompareCartesian"))
  })
  
  
  ## team tab
  
  output$teamOutput3 <- renderUI({
    selectInput(inputId = "teamInput1",
                "Select  a team:",
                choices = get_team_list(team_season()))
  })
  
  
  output$general_teamPlot <- renderPlotly({
    one_team_data <- one_team_data()
    one_team_data$win <- ifelse(one_team_data$win, "Win", "Lose")
    
    p <- ggplot(one_team_data, aes(x = game_date, y = pts)) +
      geom_line(colour = 'rgba(54, 162, 235, 0.5)') + 
      geom_point(aes(fill = one_team_data$win, color = one_team_data$win,
                     text = paste('Date: ', game_date,
                                  '<br>Points:', pts,
                                  '<br>Outcome: ', win))) +
      theme(axis.line = element_blank(),
            axis.ticks = element_blank(),
            legend.title = element_blank(),
            panel.grid.major = element_blank(),
            panel.grid.minor = element_blank(),
            panel.border = element_blank(),
            panel.background = element_rect(fill = "transparent"),
            plot.background = element_rect(fill = "transparent"),
            legend.background =  element_rect(fill = "transparent")) +
      ylab("Points") +
      xlab("Game date")
    
    ggplotly(p ,tooltip="text") %>%
      plotly::config(displaylogo = FALSE, 
                     modeBarButtonsToRemove = c("lasso2d", "autoScale2d", "hoverCompareCartesian"))
  })
  
  
  ## player tab
  
  output$playerOutput3 <- renderUI({
    selectInput(inputId = "playerInput3",
                "Select a player:",
                choices = get_player_list(player_totals1())
                )
  })
  
  
  output$playerName <- renderText({
    c('<center>',
      '<h4 style = "font-weight: bold;">',
      player_name(),
      '</h4>',
      '</center>')
  })
  
  output$player3Img <- renderText({
    c('<center>',
      '<img height="180" width="120" src="',
      player_img3(),
      '">',
      '</center>')
  })
  
  output$playerInfo <- renderTable({
    player_info()
  })
  
  output$shortCharts <- renderPlot({
    graphInput()
  })
}
