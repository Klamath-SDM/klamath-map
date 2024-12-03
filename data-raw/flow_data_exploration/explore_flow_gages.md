## Define Geographic Extent

## Pull Gage Data

## Compare Gage Sources

## Main stream Klamath

-   11509500 - Klamath River at Keno Or
-   11510700 - Klamath River Below John C Boyle Powerplant
-   11516530 - Klamath River Below Iorngate Dam
-   11520500 - Klamath River Nr Seiad Valley CA
-   11523000 - Klamath River A Orleans
-   11530500 - Klamath River Near Klamath (Furthest Downstream)

<!-- -->

    kr_at_keno_or <- dataRetrieval::readNWISdv(11509500, "00060", startDate = "1950-01-01") |> 
      select(date = Date, value =  X_00060_00003) |>  # rename to value
      as_tibble() |> 
      mutate(stream = "klamath river", # add additional columns for stream, gage info, and parameter 
             # order = 1,
             gage_agency = "USGS",
             gage_number = "11509500",
             parameter = "flow",
             statistic = "mean", # if query returns instantaneous data then report a min, mean, and max
             latitude = dataRetrieval::readNWISsite("11509500")$dec_lat_va, # directly add lat
             longitude = dataRetrieval::readNWISsite("11509500")$dec_long_va # directly add lon
             )
    kr_blw_powerplant <- dataRetrieval::readNWISdv(11510700, "00060", startDate = "1995-01-01") |> 
      select(date = Date, value =  X_00060_00003) |>  # rename to value
      as_tibble() |> 
      mutate(stream = "klamath river", # add additional columns for stream, gage info, and parameter 
             # order = 2,
             gage_agency = "USGS",
             gage_number = "11510700",
             parameter = "flow",
             statistic = "mean", # if query returns instantaneous data then report a min, mean, and max
                      latitude = dataRetrieval::readNWISsite("11510700")$dec_lat_va, # directly add lat
             longitude = dataRetrieval::readNWISsite("11510700")$dec_long_va # directly add lon
             ) 
    kr_blw_iorngage <- dataRetrieval::readNWISdv(11516530, "00060", startDate = "1950-01-01") |> 
      select(date = Date, value =  X_00060_00003) |>  # rename to value
      as_tibble() |> 
      mutate(stream = "klamath river", # add additional columns for stream, gage info, and parameter 
             # order = 3,
             gage_agency = "USGS",
             gage_number = "11516530",
             parameter = "flow",
             statistic = "mean", # if query returns instantaneous data then report a min, mean, and max
             latitude = dataRetrieval::readNWISsite("11516530")$dec_lat_va, # directly add lat
             longitude = dataRetrieval::readNWISsite("11516530")$dec_long_va # directly add lon
             ) 
    kr_nr_seiad_valley <- dataRetrieval::readNWISdv(11520500, "00060", startDate = "1950-01-01") |> 
      select(date = Date, value =  X_00060_00003) |>  # rename to value
      as_tibble() |> 
      mutate(stream = "klamath river", # add additional columns for stream, gage info, and parameter 
             # order = 4,
             gage_agency = "USGS",
             gage_number = "11520500",
             parameter = "flow",
             statistic = "mean", # if query returns instantaneous data then report a min, mean, and max
             latitude = dataRetrieval::readNWISsite("11520500")$dec_lat_va, # directly add lat
             longitude = dataRetrieval::readNWISsite("11520500")$dec_long_va # directly add lon
             ) 
    kr_at_orleans <- dataRetrieval::readNWISdv(11523000, "00060", startDate = "1950-01-01") |> 
      select(date = Date, value =  X_00060_00003) |>  # rename to value
      as_tibble() |> 
      mutate(stream = "klamath river", # add additional columns for stream, gage info, and parameter 
             # order = 5,
             gage_agency = "USGS",
             gage_number = "11523000",
             parameter = "flow",
             statistic = "mean", # if query returns instantaneous data then report a min, mean, and max
             latitude = dataRetrieval::readNWISsite("11523000")$dec_lat_va, # directly add lat
             longitude = dataRetrieval::readNWISsite("11523000")$dec_long_va # directly add lon
             ) 
    kr_nr_klamath <- dataRetrieval::readNWISdv(11530500, "00060", startDate = "1950-01-01") |> 
      select(date = Date, value =  X_00060_00003) |>  # rename to value
      as_tibble() |> 
      mutate(stream = "klamath river", # add additional columns for stream, gage info, and parameter 
             # order = 6,
             gage_agency = "USGS",
             gage_number = "11530500",
             parameter = "flow",
             statistic = "mean", # if query returns instantaneous data then report a min, mean, and max
             latitude = dataRetrieval::readNWISsite("11530500")$dec_lat_va, # directly add lat
             longitude = dataRetrieval::readNWISsite("11530500")$dec_long_va # directly add lon
             )

    all_kalamth_usgs_gages <- bind_rows(kr_at_keno_or, kr_blw_powerplant, kr_blw_iorngage, kr_nr_seiad_valley, 
                                        kr_at_orleans, kr_nr_klamath) |> 
      glimpse()

    ## Rows: 142,207
    ## Columns: 9
    ## $ date        <date> 1950-01-01, 1950-01-02, 1950-01-03, 1950-01-04, 1950-01-0…
    ## $ value       <dbl> 1580, 1470, 1500, 1500, 1430, 1270, 1090, 1170, 1350, 1510…
    ## $ stream      <chr> "klamath river", "klamath river", "klamath river", "klamat…
    ## $ gage_agency <chr> "USGS", "USGS", "USGS", "USGS", "USGS", "USGS", "USGS", "U…
    ## $ gage_number <chr> "11509500", "11509500", "11509500", "11509500", "11509500"…
    ## $ parameter   <chr> "flow", "flow", "flow", "flow", "flow", "flow", "flow", "f…
    ## $ statistic   <chr> "mean", "mean", "mean", "mean", "mean", "mean", "mean", "m…
    ## $ latitude    <dbl> 42.1332, 42.1332, 42.1332, 42.1332, 42.1332, 42.1332, 42.1…
    ## $ longitude   <dbl> -121.9622, -121.9622, -121.9622, -121.9622, -121.9622, -12…

### Map Plot Klamath USGS Gages

    # Filter to keep only one unique gage per location
    klmath_gage_dates <- all_kalamth_usgs_gages |> 
      group_by(gage_number) |> 
      summarise(min_date = min(date), max_date = max(date))

    unique_gage_data_kl <- all_kalamth_usgs_gages |> 
      distinct(gage_number, latitude, longitude, .keep_all = TRUE) |> 
      left_join(klmath_gage_dates, by = "gage_number")

    unique_gage_sf <- unique_gage_data_kl |> 
      st_as_sf(coords = c("longitude", "latitude"), crs = 4326)

    leaflet(unique_gage_sf) |> 
      addTiles() |> 
      addCircleMarkers(popup = ~paste0("Stream name: ", stream, "<br>Gage Number: ", gage_number, "<br>Max Date: ", max_date, "<br>Min Date: ", min_date))

<div class="leaflet html-widget html-fill-item-overflow-hidden html-fill-item" id="htmlwidget-8ac3497bbfcd1b757336" style="width:672px;height:480px;"></div>
<script type="application/json" data-for="htmlwidget-8ac3497bbfcd1b757336">{"x":{"options":{"crs":{"crsClass":"L.CRS.EPSG3857","code":null,"proj4def":null,"projectedBounds":null,"options":{}}},"calls":[{"method":"addTiles","args":["https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",null,null,{"minZoom":0,"maxZoom":18,"tileSize":256,"subdomains":"abc","errorTileUrl":"","tms":false,"noWrap":false,"zoomOffset":0,"zoomReverse":false,"opacity":1,"zIndex":1,"detectRetina":false,"attribution":"&copy; <a href=\"https://openstreetmap.org/copyright/\">OpenStreetMap<\/a>,  <a href=\"https://opendatacommons.org/licenses/odbl/\">ODbL<\/a>"}]},{"method":"addCircleMarkers","args":[[42.13319946,42.0845877,41.92791865,41.8537379,41.3034599,41.5109543],[-121.9622313,-122.0733453,-122.4441882,-123.2322733,-123.5345036,-123.9795164],10,null,null,{"interactive":true,"className":"","stroke":true,"color":"#03F","weight":5,"opacity":0.5,"fill":true,"fillColor":"#03F","fillOpacity":0.2},null,null,["Stream name: klamath river<br>Gage Number: 11509500<br>Max Date: 2024-12-02<br>Min Date: 1950-01-01","Stream name: klamath river<br>Gage Number: 11510700<br>Max Date: 2024-12-02<br>Min Date: 1995-01-01","Stream name: klamath river<br>Gage Number: 11516530<br>Max Date: 2024-12-02<br>Min Date: 1960-10-01","Stream name: klamath river<br>Gage Number: 11520500<br>Max Date: 2024-12-02<br>Min Date: 1951-10-01","Stream name: klamath river<br>Gage Number: 11523000<br>Max Date: 2024-12-02<br>Min Date: 1950-01-01","Stream name: klamath river<br>Gage Number: 11530500<br>Max Date: 2024-12-02<br>Min Date: 1950-10-01"],null,null,{"interactive":false,"permanent":false,"direction":"auto","opacity":1,"offset":[0,0],"textsize":"10px","textOnly":false,"className":"","sticky":true},null]}],"limits":{"lat":[41.3034599,42.13319946],"lng":[-123.9795164,-121.9622313]}},"evals":[],"jsHooks":[]}</script>

### Date coverage

    all_kalamth_usgs_gages |> ggplot(aes(x = date, y = value, color = as.character(gage_number))) + 
      geom_line() + 
      scale_color_manual(values = colors_full) +
      facet_wrap(~gage_number) +
      theme_minimal()

![](explore_flow_gages_files/figure-markdown_strict/unnamed-chunk-4-1.png)

    all_kalamth_usgs_gages |> 
      ggplot(aes(x = date, y = value, color = gage_number)) + 
      geom_line() + 
      scale_color_manual(values = colors_full) +
      theme_minimal()

![](explore_flow_gages_files/figure-markdown_strict/unnamed-chunk-4-2.png)
\### Date range summary

    ## Rows: 6
    ## Columns: 4
    ## $ gage_number  <chr> "11509500", "11510700", "11516530", "11520500", "11523000…
    ## $ min_date     <date> 1950-01-01, 1995-01-01, 1960-10-01, 1951-10-01, 1950-01-…
    ## $ max_date     <date> 2024-12-02, 2024-12-02, 2024-12-02, 2024-12-02, 2024-12-…
    ## $ record_count <int> 27365, 10928, 23439, 26727, 27365, 26383

## Trinity

Potential gages

-   11528700 SF TRINITY R BL HYAMPOM CA - South fork
-   11530000 TRINITY R A HOOPA CA
-   11523200 TRINITY R AB COFFEE C NR TRINITY CENTER CA
-   11525500 TRINITY R A LEWISTON CA
-   11525655 TRINITY R BL LIMEKILN GULCH NR DOUGLAS CITY CA
-   11525854 TRINITY R A DOUGLAS CITY CA
-   11526250 TRINITY R A JUNCTION CITY CA
-   11526400 TRINITY R AB NF TRINITY R NR HELENA CA
-   11527000 TRINITY R NR BURNT RANCH CA

### Map Plot Trinity USGS Gages

    # Filter to keep only one unique gage per location

    gage_dates <- all_trinity_usgs_gages |> 
      group_by(gage_number) |> 
      summarise(min_date = min(date), max_date = max(date))

    # Add the date information to the unique gages
    unique_gage_trinity <- all_trinity_usgs_gages |> 
      distinct(gage_number, latitude, longitude, .keep_all = TRUE) |> 
      left_join(gage_dates, by = "gage_number")

    unique_gage_tr <- unique_gage_trinity |> 
      st_as_sf(coords = c("longitude", "latitude"), crs = 4326)

    leaflet(unique_gage_tr) |> 
      addTiles() |> 
        addCircleMarkers(
        popup = ~paste0("Stream name: ", stream, "<br>Gage Number: ", gage_number, "<br>Max Date: ", max_date, "<br>Min Date: ", min_date)
      )

<div class="leaflet html-widget html-fill-item-overflow-hidden html-fill-item" id="htmlwidget-8e598a1414c4f9c076fe" style="width:672px;height:480px;"></div>
<script type="application/json" data-for="htmlwidget-8e598a1414c4f9c076fe">{"x":{"options":{"crs":{"crsClass":"L.CRS.EPSG3857","code":null,"proj4def":null,"projectedBounds":null,"options":{}}},"calls":[{"method":"addTiles","args":["https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",null,null,{"minZoom":0,"maxZoom":18,"tileSize":256,"subdomains":"abc","errorTileUrl":"","tms":false,"noWrap":false,"zoomOffset":0,"zoomReverse":false,"opacity":1,"zIndex":1,"detectRetina":false,"attribution":"&copy; <a href=\"https://openstreetmap.org/copyright/\">OpenStreetMap<\/a>,  <a href=\"https://opendatacommons.org/licenses/odbl/\">ODbL<\/a>"}]},{"method":"addCircleMarkers","args":[[40.6498627,41.049852,41.1112571,40.7247222,40.6726453,40.64527778,40.7284768,40.76653148,40.7887498],[-123.4942046,-123.673668,-122.7055788,-122.801111,-122.9205805,-122.9566667,-123.0619736,-123.1144757,-123.4400401],10,null,null,{"interactive":true,"className":"","stroke":true,"color":"#03F","weight":5,"opacity":0.5,"fill":true,"fillColor":"#03F","fillOpacity":0.2},null,null,["Stream name: trinity river - south fork<br>Gage Number: 11528700<br>Max Date: 2024-12-02<br>Min Date: 1965-10-01","Stream name: trinity river<br>Gage Number: 11530000<br>Max Date: 2024-12-02<br>Min Date: 1911-10-01","Stream name: trinity river<br>Gage Number: 11523200<br>Max Date: 2024-12-02<br>Min Date: 1957-10-01","Stream name: trinity river<br>Gage Number: 11525500<br>Max Date: 2024-12-02<br>Min Date: 1911-10-01","Stream name: trinity river<br>Gage Number: 11525655<br>Max Date: 2024-12-02<br>Min Date: 1981-04-28","Stream name: trinity river<br>Gage Number: 11525854<br>Max Date: 2024-12-02<br>Min Date: 2002-10-01","Stream name: trinity river<br>Gage Number: 11526250<br>Max Date: 2024-12-02<br>Min Date: 2002-10-01","Stream name: trinity river<br>Gage Number: 11526400<br>Max Date: 2024-12-02<br>Min Date: 2005-03-29","Stream name: trinity river<br>Gage Number: 11527000<br>Max Date: 2024-12-02<br>Min Date: 1931-10-01"],null,null,{"interactive":false,"permanent":false,"direction":"auto","opacity":1,"offset":[0,0],"textsize":"10px","textOnly":false,"className":"","sticky":true},null]}],"limits":{"lat":[40.64527778,41.1112571],"lng":[-123.673668,-122.7055788]}},"evals":[],"jsHooks":[]}</script>

### Date coverage per gage

    all_trinity_usgs_gages |> ggplot(aes(x = year(date), y = value, color = gage_number)) + 
      geom_line() + 
      scale_color_manual(values = colors_full) +
      facet_wrap(~gage_number) +
      theme_minimal()

![](explore_flow_gages_files/figure-markdown_strict/unnamed-chunk-9-1.png)

### Date range summary

    ## Rows: 9
    ## Columns: 4
    ## $ gage_number  <chr> "11523200", "11525500", "11525655", "11525854", "11526250…
    ## $ min_date     <date> 1957-10-01, 1911-10-01, 1981-04-28, 2002-10-01, 2002-10-…
    ## $ max_date     <date> 2024-12-02, 2024-12-02, 2024-12-02, 2024-12-02, 2024-12-…
    ## $ record_count <int> 24531, 41337, 11906, 8098, 8099, 7189, 28187, 21613, 35491

## Scott

-   11519500 SCOTT R NR FORT JONES CA

<!-- -->

    scott <- dataRetrieval::readNWISdv(11519500, "00060") |> 
      select(date = Date, value =  X_00060_00003) |>  # rename to value
      as_tibble() |> 
      mutate(stream = "scott river",
             gage_agency = "USGS",
             gage_number = "11519500",
             parameter = "flow",
             statistic = "mean", # if query returns instantaneous data then report a min, mean, and max
             latitude = dataRetrieval::readNWISsite("11519500")$dec_lat_va, # directly add lat
             longitude = dataRetrieval::readNWISsite("11519500")$dec_long_va # directly add lon
             ) 

### Map Plot Scott USGS

    scott_usgs_dates <- scott |> 
      group_by(gage_number) |> 
      summarise(min_date = min(date), max_date = max(date))

    # Add the date information to the unique gages
    unique_gage_scott<- scott |> 
      distinct(gage_number, latitude, longitude, .keep_all = TRUE) |> 
      left_join(scott_usgs_dates, by = "gage_number")

    unique_gage_scott_sf <- unique_gage_scott |> 
      st_as_sf(coords = c("longitude", "latitude"), crs = 4326)

    leaflet(unique_gage_scott_sf) |> 
      addTiles() |> 
        addCircleMarkers(
        popup = ~paste0("Stream name: ", stream, "<br>Gage Number: ", gage_number, "<br>Max Date: ", max_date, "<br>Min Date: ", min_date)
      )

<div class="leaflet html-widget html-fill-item-overflow-hidden html-fill-item" id="htmlwidget-082f01bb6ac834f32fd4" style="width:672px;height:480px;"></div>
<script type="application/json" data-for="htmlwidget-082f01bb6ac834f32fd4">{"x":{"options":{"crs":{"crsClass":"L.CRS.EPSG3857","code":null,"proj4def":null,"projectedBounds":null,"options":{}}},"calls":[{"method":"addTiles","args":["https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",null,null,{"minZoom":0,"maxZoom":18,"tileSize":256,"subdomains":"abc","errorTileUrl":"","tms":false,"noWrap":false,"zoomOffset":0,"zoomReverse":false,"opacity":1,"zIndex":1,"detectRetina":false,"attribution":"&copy; <a href=\"https://openstreetmap.org/copyright/\">OpenStreetMap<\/a>,  <a href=\"https://opendatacommons.org/licenses/odbl/\">ODbL<\/a>"}]},{"method":"addCircleMarkers","args":[41.64069017,-123.015037,10,null,null,{"interactive":true,"className":"","stroke":true,"color":"#03F","weight":5,"opacity":0.5,"fill":true,"fillColor":"#03F","fillOpacity":0.2},null,null,"Stream name: scott river<br>Gage Number: 11519500<br>Max Date: 2024-12-02<br>Min Date: 1941-10-01",null,null,{"interactive":false,"permanent":false,"direction":"auto","opacity":1,"offset":[0,0],"textsize":"10px","textOnly":false,"className":"","sticky":true},null]}],"limits":{"lat":[41.64069017,41.64069017],"lng":[-123.015037,-123.015037]}},"evals":[],"jsHooks":[]}</script>

## Shasta

-   Shasta R NR Montague CA - 11517000
-   Shasta R NR Yreka CA - 11517500

<!-- -->

    shasta_mont <- dataRetrieval::readNWISdv(11517000, "00060") |> 
      select(date = Date, value =  X_00060_00003) |>  # rename to value
      as_tibble() |> 
      mutate(stream = "shasta river",
             gage_agency = "USGS",
             gage_number = "11517000",
             parameter = "flow",
             statistic = "mean", # if query returns instantaneous data then report a min, mean, and max
             latitude = dataRetrieval::readNWISsite("11517000")$dec_lat_va, # directly add lat
             longitude = dataRetrieval::readNWISsite("11517000")$dec_long_va # directly add lon
             ) 

    shasta_yreka <- dataRetrieval::readNWISdv(11517500, "00060") |> 
      select(date = Date, value =  X_00060_00003) |>  # rename to value
      as_tibble() |> 
      mutate(stream = "shasta river",
             gage_agency = "USGS",
             gage_number = "11517500",
             parameter = "flow",
             statistic = "mean", # if query returns instantaneous data then report a min, mean, and max
             latitude = dataRetrieval::readNWISsite("11517500")$dec_lat_va, # directly add lat
             longitude = dataRetrieval::readNWISsite("11517500")$dec_long_va # directly add lon
             ) 

    all_usgs_shasta <- bind_rows(shasta_mont, shasta_yreka) |> 
      glimpse()

    ## Rows: 46,894
    ## Columns: 9
    ## $ date        <date> 1911-10-01, 1911-10-02, 1911-10-03, 1911-10-04, 1911-10-0…
    ## $ value       <dbl> 96, 112, 112, 112, 112, 112, 112, 112, 147, 167, 147, 147,…
    ## $ stream      <chr> "shasta river", "shasta river", "shasta river", "shasta ri…
    ## $ gage_agency <chr> "USGS", "USGS", "USGS", "USGS", "USGS", "USGS", "USGS", "U…
    ## $ gage_number <chr> "11517000", "11517000", "11517000", "11517000", "11517000"…
    ## $ parameter   <chr> "flow", "flow", "flow", "flow", "flow", "flow", "flow", "f…
    ## $ statistic   <chr> "mean", "mean", "mean", "mean", "mean", "mean", "mean", "m…
    ## $ latitude    <dbl> 41.70903, 41.70903, 41.70903, 41.70903, 41.70903, 41.70903…
    ## $ longitude   <dbl> -122.5381, -122.5381, -122.5381, -122.5381, -122.5381, -12…

### Map Plot Shasta USGS

    shasta_usgs_dates <- all_usgs_shasta |> 
      group_by(gage_number) |> 
      summarise(min_date = min(date), max_date = max(date))

    # Add the date information to the unique gages
    unique_gage_shasta<- all_usgs_shasta |> 
      distinct(gage_number, latitude, longitude, .keep_all = TRUE) |> 
      left_join(shasta_usgs_dates, by = "gage_number")

    unique_gage_shas_sf <- unique_gage_shasta |> 
      st_as_sf(coords = c("longitude", "latitude"), crs = 4326)

    leaflet(unique_gage_shas_sf) |> 
      addTiles() |> 
        addCircleMarkers(
        popup = ~paste0("Stream name: ", stream, "<br>Gage Number: ", gage_number, "<br>Max Date: ", max_date, "<br>Min Date: ", min_date)
      )

<div class="leaflet html-widget html-fill-item-overflow-hidden html-fill-item" id="htmlwidget-c297eb432d20eee5a344" style="width:672px;height:480px;"></div>
<script type="application/json" data-for="htmlwidget-c297eb432d20eee5a344">{"x":{"options":{"crs":{"crsClass":"L.CRS.EPSG3857","code":null,"proj4def":null,"projectedBounds":null,"options":{}}},"calls":[{"method":"addTiles","args":["https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",null,null,{"minZoom":0,"maxZoom":18,"tileSize":256,"subdomains":"abc","errorTileUrl":"","tms":false,"noWrap":false,"zoomOffset":0,"zoomReverse":false,"opacity":1,"zIndex":1,"detectRetina":false,"attribution":"&copy; <a href=\"https://openstreetmap.org/copyright/\">OpenStreetMap<\/a>,  <a href=\"https://opendatacommons.org/licenses/odbl/\">ODbL<\/a>"}]},{"method":"addCircleMarkers","args":[[41.70903196,41.8229179],[-122.5380787,-122.5955813],10,null,null,{"interactive":true,"className":"","stroke":true,"color":"#03F","weight":5,"opacity":0.5,"fill":true,"fillColor":"#03F","fillOpacity":0.2},null,null,["Stream name: shasta river<br>Gage Number: 11517000<br>Max Date: 2024-12-02<br>Min Date: 1911-10-01","Stream name: shasta river<br>Gage Number: 11517500<br>Max Date: 2024-12-02<br>Min Date: 1933-10-01"],null,null,{"interactive":false,"permanent":false,"direction":"auto","opacity":1,"offset":[0,0],"textsize":"10px","textOnly":false,"className":"","sticky":true},null]}],"limits":{"lat":[41.70903196,41.8229179],"lng":[-122.5955813,-122.5380787]}},"evals":[],"jsHooks":[]}</script>

### Date coverage plot

    all_usgs_shasta |> ggplot(aes(x = year(date), y = value, color = gage_number)) + 
      geom_line() + 
      scale_color_manual(values = colors_full) +
      facet_wrap(~gage_number) +
      theme_minimal()

![](explore_flow_gages_files/figure-markdown_strict/unnamed-chunk-15-1.png)

### Date range summary

    ## Rows: 2
    ## Columns: 4
    ## $ gage_number  <chr> "11517000", "11517500"
    ## $ min_date     <date> 1911-10-01, 1933-10-01
    ## $ max_date     <date> 2024-12-02, 2024-12-02
    ## $ record_count <int> 14671, 32223

## Salmon

-   11522500 SALMON R A SOMES BAR CA

<!-- -->

    salmon_usgs_gage <- dataRetrieval::readNWISdv(11522500, "00060") |> 
      select(date = Date, value =  X_00060_00003) |>  # rename to value
      as_tibble() |> 
      mutate(stream = "shasta river",
             gage_agency = "USGS",
             gage_number = "11522500",
             parameter = "flow",
             statistic = "mean", # if query returns instantaneous data then report a min, mean, and max
             latitude = dataRetrieval::readNWISsite("11522500")$dec_lat_va, # directly add lat
             longitude = dataRetrieval::readNWISsite("11522500")$dec_long_va # directly add lon
             )

### Map Plot Salmon USGS

    salmon_gage_dates <- salmon_usgs_gage |> 
      group_by(gage_number) |> 
      summarise(min_date = min(date), max_date = max(date))

    unique_gage_data_salmon <- salmon_usgs_gage |> 
      distinct(gage_number, latitude, longitude, .keep_all = TRUE) |> 
      left_join(salmon_gage_dates, by = "gage_number")

    unique_gage_data_salmon_sf <- unique_gage_data_salmon |> 
      st_as_sf(coords = c("longitude", "latitude"), crs = 4326)

    leaflet(unique_gage_data_salmon_sf) |> 
      addTiles() |> 
      addCircleMarkers(popup = ~paste0("Stream name: ", stream, "<br>Gage Number: ", gage_number, "<br>Max Date: ", max_date, "<br>Min Date: ", min_date))

<div class="leaflet html-widget html-fill-item-overflow-hidden html-fill-item" id="htmlwidget-d3d305293aeb75edfa6e" style="width:672px;height:480px;"></div>
<script type="application/json" data-for="htmlwidget-d3d305293aeb75edfa6e">{"x":{"options":{"crs":{"crsClass":"L.CRS.EPSG3857","code":null,"proj4def":null,"projectedBounds":null,"options":{}}},"calls":[{"method":"addTiles","args":["https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",null,null,{"minZoom":0,"maxZoom":18,"tileSize":256,"subdomains":"abc","errorTileUrl":"","tms":false,"noWrap":false,"zoomOffset":0,"zoomReverse":false,"opacity":1,"zIndex":1,"detectRetina":false,"attribution":"&copy; <a href=\"https://openstreetmap.org/copyright/\">OpenStreetMap<\/a>,  <a href=\"https://opendatacommons.org/licenses/odbl/\">ODbL<\/a>"}]},{"method":"addCircleMarkers","args":[41.3765154,-123.4770026,10,null,null,{"interactive":true,"className":"","stroke":true,"color":"#03F","weight":5,"opacity":0.5,"fill":true,"fillColor":"#03F","fillOpacity":0.2},null,null,"Stream name: shasta river<br>Gage Number: 11522500<br>Max Date: 2024-12-02<br>Min Date: 1911-10-01",null,null,{"interactive":false,"permanent":false,"direction":"auto","opacity":1,"offset":[0,0],"textsize":"10px","textOnly":false,"className":"","sticky":true},null]}],"limits":{"lat":[41.3765154,41.3765154],"lng":[-123.4770026,-123.4770026]}},"evals":[],"jsHooks":[]}</script>

### Date coverage plot

    salmon_usgs_gage |> ggplot(aes(x = year(date), y = value)) + 
      geom_line() + 
      scale_color_manual(values = colors_full) 

![](explore_flow_gages_files/figure-markdown_strict/unnamed-chunk-19-1.png)

      theme_minimal()

    ## List of 97
    ##  $ line                      :List of 6
    ##   ..$ colour       : chr "black"
    ##   ..$ linewidth    : num 0.5
    ##   ..$ linetype     : num 1
    ##   ..$ lineend      : chr "butt"
    ##   ..$ arrow        : logi FALSE
    ##   ..$ inherit.blank: logi TRUE
    ##   ..- attr(*, "class")= chr [1:2] "element_line" "element"
    ##  $ rect                      :List of 5
    ##   ..$ fill         : chr "white"
    ##   ..$ colour       : chr "black"
    ##   ..$ linewidth    : num 0.5
    ##   ..$ linetype     : num 1
    ##   ..$ inherit.blank: logi TRUE
    ##   ..- attr(*, "class")= chr [1:2] "element_rect" "element"
    ##  $ text                      :List of 11
    ##   ..$ family       : chr ""
    ##   ..$ face         : chr "plain"
    ##   ..$ colour       : chr "black"
    ##   ..$ size         : num 11
    ##   ..$ hjust        : num 0.5
    ##   ..$ vjust        : num 0.5
    ##   ..$ angle        : num 0
    ##   ..$ lineheight   : num 0.9
    ##   ..$ margin       : 'margin' num [1:4] 0points 0points 0points 0points
    ##   .. ..- attr(*, "unit")= int 8
    ##   ..$ debug        : logi FALSE
    ##   ..$ inherit.blank: logi TRUE
    ##   ..- attr(*, "class")= chr [1:2] "element_text" "element"
    ##  $ title                     : NULL
    ##  $ aspect.ratio              : NULL
    ##  $ axis.title                : NULL
    ##  $ axis.title.x              :List of 11
    ##   ..$ family       : NULL
    ##   ..$ face         : NULL
    ##   ..$ colour       : NULL
    ##   ..$ size         : NULL
    ##   ..$ hjust        : NULL
    ##   ..$ vjust        : num 1
    ##   ..$ angle        : NULL
    ##   ..$ lineheight   : NULL
    ##   ..$ margin       : 'margin' num [1:4] 2.75points 0points 0points 0points
    ##   .. ..- attr(*, "unit")= int 8
    ##   ..$ debug        : NULL
    ##   ..$ inherit.blank: logi TRUE
    ##   ..- attr(*, "class")= chr [1:2] "element_text" "element"
    ##  $ axis.title.x.top          :List of 11
    ##   ..$ family       : NULL
    ##   ..$ face         : NULL
    ##   ..$ colour       : NULL
    ##   ..$ size         : NULL
    ##   ..$ hjust        : NULL
    ##   ..$ vjust        : num 0
    ##   ..$ angle        : NULL
    ##   ..$ lineheight   : NULL
    ##   ..$ margin       : 'margin' num [1:4] 0points 0points 2.75points 0points
    ##   .. ..- attr(*, "unit")= int 8
    ##   ..$ debug        : NULL
    ##   ..$ inherit.blank: logi TRUE
    ##   ..- attr(*, "class")= chr [1:2] "element_text" "element"
    ##  $ axis.title.x.bottom       : NULL
    ##  $ axis.title.y              :List of 11
    ##   ..$ family       : NULL
    ##   ..$ face         : NULL
    ##   ..$ colour       : NULL
    ##   ..$ size         : NULL
    ##   ..$ hjust        : NULL
    ##   ..$ vjust        : num 1
    ##   ..$ angle        : num 90
    ##   ..$ lineheight   : NULL
    ##   ..$ margin       : 'margin' num [1:4] 0points 2.75points 0points 0points
    ##   .. ..- attr(*, "unit")= int 8
    ##   ..$ debug        : NULL
    ##   ..$ inherit.blank: logi TRUE
    ##   ..- attr(*, "class")= chr [1:2] "element_text" "element"
    ##  $ axis.title.y.left         : NULL
    ##  $ axis.title.y.right        :List of 11
    ##   ..$ family       : NULL
    ##   ..$ face         : NULL
    ##   ..$ colour       : NULL
    ##   ..$ size         : NULL
    ##   ..$ hjust        : NULL
    ##   ..$ vjust        : num 0
    ##   ..$ angle        : num -90
    ##   ..$ lineheight   : NULL
    ##   ..$ margin       : 'margin' num [1:4] 0points 0points 0points 2.75points
    ##   .. ..- attr(*, "unit")= int 8
    ##   ..$ debug        : NULL
    ##   ..$ inherit.blank: logi TRUE
    ##   ..- attr(*, "class")= chr [1:2] "element_text" "element"
    ##  $ axis.text                 :List of 11
    ##   ..$ family       : NULL
    ##   ..$ face         : NULL
    ##   ..$ colour       : chr "grey30"
    ##   ..$ size         : 'rel' num 0.8
    ##   ..$ hjust        : NULL
    ##   ..$ vjust        : NULL
    ##   ..$ angle        : NULL
    ##   ..$ lineheight   : NULL
    ##   ..$ margin       : NULL
    ##   ..$ debug        : NULL
    ##   ..$ inherit.blank: logi TRUE
    ##   ..- attr(*, "class")= chr [1:2] "element_text" "element"
    ##  $ axis.text.x               :List of 11
    ##   ..$ family       : NULL
    ##   ..$ face         : NULL
    ##   ..$ colour       : NULL
    ##   ..$ size         : NULL
    ##   ..$ hjust        : NULL
    ##   ..$ vjust        : num 1
    ##   ..$ angle        : NULL
    ##   ..$ lineheight   : NULL
    ##   ..$ margin       : 'margin' num [1:4] 2.2points 0points 0points 0points
    ##   .. ..- attr(*, "unit")= int 8
    ##   ..$ debug        : NULL
    ##   ..$ inherit.blank: logi TRUE
    ##   ..- attr(*, "class")= chr [1:2] "element_text" "element"
    ##  $ axis.text.x.top           :List of 11
    ##   ..$ family       : NULL
    ##   ..$ face         : NULL
    ##   ..$ colour       : NULL
    ##   ..$ size         : NULL
    ##   ..$ hjust        : NULL
    ##   ..$ vjust        : num 0
    ##   ..$ angle        : NULL
    ##   ..$ lineheight   : NULL
    ##   ..$ margin       : 'margin' num [1:4] 0points 0points 2.2points 0points
    ##   .. ..- attr(*, "unit")= int 8
    ##   ..$ debug        : NULL
    ##   ..$ inherit.blank: logi TRUE
    ##   ..- attr(*, "class")= chr [1:2] "element_text" "element"
    ##  $ axis.text.x.bottom        : NULL
    ##  $ axis.text.y               :List of 11
    ##   ..$ family       : NULL
    ##   ..$ face         : NULL
    ##   ..$ colour       : NULL
    ##   ..$ size         : NULL
    ##   ..$ hjust        : num 1
    ##   ..$ vjust        : NULL
    ##   ..$ angle        : NULL
    ##   ..$ lineheight   : NULL
    ##   ..$ margin       : 'margin' num [1:4] 0points 2.2points 0points 0points
    ##   .. ..- attr(*, "unit")= int 8
    ##   ..$ debug        : NULL
    ##   ..$ inherit.blank: logi TRUE
    ##   ..- attr(*, "class")= chr [1:2] "element_text" "element"
    ##  $ axis.text.y.left          : NULL
    ##  $ axis.text.y.right         :List of 11
    ##   ..$ family       : NULL
    ##   ..$ face         : NULL
    ##   ..$ colour       : NULL
    ##   ..$ size         : NULL
    ##   ..$ hjust        : num 0
    ##   ..$ vjust        : NULL
    ##   ..$ angle        : NULL
    ##   ..$ lineheight   : NULL
    ##   ..$ margin       : 'margin' num [1:4] 0points 0points 0points 2.2points
    ##   .. ..- attr(*, "unit")= int 8
    ##   ..$ debug        : NULL
    ##   ..$ inherit.blank: logi TRUE
    ##   ..- attr(*, "class")= chr [1:2] "element_text" "element"
    ##  $ axis.ticks                : list()
    ##   ..- attr(*, "class")= chr [1:2] "element_blank" "element"
    ##  $ axis.ticks.x              : NULL
    ##  $ axis.ticks.x.top          : NULL
    ##  $ axis.ticks.x.bottom       : NULL
    ##  $ axis.ticks.y              : NULL
    ##  $ axis.ticks.y.left         : NULL
    ##  $ axis.ticks.y.right        : NULL
    ##  $ axis.ticks.length         : 'simpleUnit' num 2.75points
    ##   ..- attr(*, "unit")= int 8
    ##  $ axis.ticks.length.x       : NULL
    ##  $ axis.ticks.length.x.top   : NULL
    ##  $ axis.ticks.length.x.bottom: NULL
    ##  $ axis.ticks.length.y       : NULL
    ##  $ axis.ticks.length.y.left  : NULL
    ##  $ axis.ticks.length.y.right : NULL
    ##  $ axis.line                 : list()
    ##   ..- attr(*, "class")= chr [1:2] "element_blank" "element"
    ##  $ axis.line.x               : NULL
    ##  $ axis.line.x.top           : NULL
    ##  $ axis.line.x.bottom        : NULL
    ##  $ axis.line.y               : NULL
    ##  $ axis.line.y.left          : NULL
    ##  $ axis.line.y.right         : NULL
    ##  $ legend.background         : list()
    ##   ..- attr(*, "class")= chr [1:2] "element_blank" "element"
    ##  $ legend.margin             : 'margin' num [1:4] 5.5points 5.5points 5.5points 5.5points
    ##   ..- attr(*, "unit")= int 8
    ##  $ legend.spacing            : 'simpleUnit' num 11points
    ##   ..- attr(*, "unit")= int 8
    ##  $ legend.spacing.x          : NULL
    ##  $ legend.spacing.y          : NULL
    ##  $ legend.key                : list()
    ##   ..- attr(*, "class")= chr [1:2] "element_blank" "element"
    ##  $ legend.key.size           : 'simpleUnit' num 1.2lines
    ##   ..- attr(*, "unit")= int 3
    ##  $ legend.key.height         : NULL
    ##  $ legend.key.width          : NULL
    ##  $ legend.text               :List of 11
    ##   ..$ family       : NULL
    ##   ..$ face         : NULL
    ##   ..$ colour       : NULL
    ##   ..$ size         : 'rel' num 0.8
    ##   ..$ hjust        : NULL
    ##   ..$ vjust        : NULL
    ##   ..$ angle        : NULL
    ##   ..$ lineheight   : NULL
    ##   ..$ margin       : NULL
    ##   ..$ debug        : NULL
    ##   ..$ inherit.blank: logi TRUE
    ##   ..- attr(*, "class")= chr [1:2] "element_text" "element"
    ##  $ legend.text.align         : NULL
    ##  $ legend.title              :List of 11
    ##   ..$ family       : NULL
    ##   ..$ face         : NULL
    ##   ..$ colour       : NULL
    ##   ..$ size         : NULL
    ##   ..$ hjust        : num 0
    ##   ..$ vjust        : NULL
    ##   ..$ angle        : NULL
    ##   ..$ lineheight   : NULL
    ##   ..$ margin       : NULL
    ##   ..$ debug        : NULL
    ##   ..$ inherit.blank: logi TRUE
    ##   ..- attr(*, "class")= chr [1:2] "element_text" "element"
    ##  $ legend.title.align        : NULL
    ##  $ legend.position           : chr "right"
    ##  $ legend.direction          : NULL
    ##  $ legend.justification      : chr "center"
    ##  $ legend.box                : NULL
    ##  $ legend.box.just           : NULL
    ##  $ legend.box.margin         : 'margin' num [1:4] 0cm 0cm 0cm 0cm
    ##   ..- attr(*, "unit")= int 1
    ##  $ legend.box.background     : list()
    ##   ..- attr(*, "class")= chr [1:2] "element_blank" "element"
    ##  $ legend.box.spacing        : 'simpleUnit' num 11points
    ##   ..- attr(*, "unit")= int 8
    ##  $ panel.background          : list()
    ##   ..- attr(*, "class")= chr [1:2] "element_blank" "element"
    ##  $ panel.border              : list()
    ##   ..- attr(*, "class")= chr [1:2] "element_blank" "element"
    ##  $ panel.spacing             : 'simpleUnit' num 5.5points
    ##   ..- attr(*, "unit")= int 8
    ##  $ panel.spacing.x           : NULL
    ##  $ panel.spacing.y           : NULL
    ##  $ panel.grid                :List of 6
    ##   ..$ colour       : chr "grey92"
    ##   ..$ linewidth    : NULL
    ##   ..$ linetype     : NULL
    ##   ..$ lineend      : NULL
    ##   ..$ arrow        : logi FALSE
    ##   ..$ inherit.blank: logi TRUE
    ##   ..- attr(*, "class")= chr [1:2] "element_line" "element"
    ##  $ panel.grid.major          : NULL
    ##  $ panel.grid.minor          :List of 6
    ##   ..$ colour       : NULL
    ##   ..$ linewidth    : 'rel' num 0.5
    ##   ..$ linetype     : NULL
    ##   ..$ lineend      : NULL
    ##   ..$ arrow        : logi FALSE
    ##   ..$ inherit.blank: logi TRUE
    ##   ..- attr(*, "class")= chr [1:2] "element_line" "element"
    ##  $ panel.grid.major.x        : NULL
    ##  $ panel.grid.major.y        : NULL
    ##  $ panel.grid.minor.x        : NULL
    ##  $ panel.grid.minor.y        : NULL
    ##  $ panel.ontop               : logi FALSE
    ##  $ plot.background           : list()
    ##   ..- attr(*, "class")= chr [1:2] "element_blank" "element"
    ##  $ plot.title                :List of 11
    ##   ..$ family       : NULL
    ##   ..$ face         : NULL
    ##   ..$ colour       : NULL
    ##   ..$ size         : 'rel' num 1.2
    ##   ..$ hjust        : num 0
    ##   ..$ vjust        : num 1
    ##   ..$ angle        : NULL
    ##   ..$ lineheight   : NULL
    ##   ..$ margin       : 'margin' num [1:4] 0points 0points 5.5points 0points
    ##   .. ..- attr(*, "unit")= int 8
    ##   ..$ debug        : NULL
    ##   ..$ inherit.blank: logi TRUE
    ##   ..- attr(*, "class")= chr [1:2] "element_text" "element"
    ##  $ plot.title.position       : chr "panel"
    ##  $ plot.subtitle             :List of 11
    ##   ..$ family       : NULL
    ##   ..$ face         : NULL
    ##   ..$ colour       : NULL
    ##   ..$ size         : NULL
    ##   ..$ hjust        : num 0
    ##   ..$ vjust        : num 1
    ##   ..$ angle        : NULL
    ##   ..$ lineheight   : NULL
    ##   ..$ margin       : 'margin' num [1:4] 0points 0points 5.5points 0points
    ##   .. ..- attr(*, "unit")= int 8
    ##   ..$ debug        : NULL
    ##   ..$ inherit.blank: logi TRUE
    ##   ..- attr(*, "class")= chr [1:2] "element_text" "element"
    ##  $ plot.caption              :List of 11
    ##   ..$ family       : NULL
    ##   ..$ face         : NULL
    ##   ..$ colour       : NULL
    ##   ..$ size         : 'rel' num 0.8
    ##   ..$ hjust        : num 1
    ##   ..$ vjust        : num 1
    ##   ..$ angle        : NULL
    ##   ..$ lineheight   : NULL
    ##   ..$ margin       : 'margin' num [1:4] 5.5points 0points 0points 0points
    ##   .. ..- attr(*, "unit")= int 8
    ##   ..$ debug        : NULL
    ##   ..$ inherit.blank: logi TRUE
    ##   ..- attr(*, "class")= chr [1:2] "element_text" "element"
    ##  $ plot.caption.position     : chr "panel"
    ##  $ plot.tag                  :List of 11
    ##   ..$ family       : NULL
    ##   ..$ face         : NULL
    ##   ..$ colour       : NULL
    ##   ..$ size         : 'rel' num 1.2
    ##   ..$ hjust        : num 0.5
    ##   ..$ vjust        : num 0.5
    ##   ..$ angle        : NULL
    ##   ..$ lineheight   : NULL
    ##   ..$ margin       : NULL
    ##   ..$ debug        : NULL
    ##   ..$ inherit.blank: logi TRUE
    ##   ..- attr(*, "class")= chr [1:2] "element_text" "element"
    ##  $ plot.tag.position         : chr "topleft"
    ##  $ plot.margin               : 'margin' num [1:4] 5.5points 5.5points 5.5points 5.5points
    ##   ..- attr(*, "unit")= int 8
    ##  $ strip.background          : list()
    ##   ..- attr(*, "class")= chr [1:2] "element_blank" "element"
    ##  $ strip.background.x        : NULL
    ##  $ strip.background.y        : NULL
    ##  $ strip.clip                : chr "inherit"
    ##  $ strip.placement           : chr "inside"
    ##  $ strip.text                :List of 11
    ##   ..$ family       : NULL
    ##   ..$ face         : NULL
    ##   ..$ colour       : chr "grey10"
    ##   ..$ size         : 'rel' num 0.8
    ##   ..$ hjust        : NULL
    ##   ..$ vjust        : NULL
    ##   ..$ angle        : NULL
    ##   ..$ lineheight   : NULL
    ##   ..$ margin       : 'margin' num [1:4] 4.4points 4.4points 4.4points 4.4points
    ##   .. ..- attr(*, "unit")= int 8
    ##   ..$ debug        : NULL
    ##   ..$ inherit.blank: logi TRUE
    ##   ..- attr(*, "class")= chr [1:2] "element_text" "element"
    ##  $ strip.text.x              : NULL
    ##  $ strip.text.x.bottom       : NULL
    ##  $ strip.text.x.top          : NULL
    ##  $ strip.text.y              :List of 11
    ##   ..$ family       : NULL
    ##   ..$ face         : NULL
    ##   ..$ colour       : NULL
    ##   ..$ size         : NULL
    ##   ..$ hjust        : NULL
    ##   ..$ vjust        : NULL
    ##   ..$ angle        : num -90
    ##   ..$ lineheight   : NULL
    ##   ..$ margin       : NULL
    ##   ..$ debug        : NULL
    ##   ..$ inherit.blank: logi TRUE
    ##   ..- attr(*, "class")= chr [1:2] "element_text" "element"
    ##  $ strip.text.y.left         :List of 11
    ##   ..$ family       : NULL
    ##   ..$ face         : NULL
    ##   ..$ colour       : NULL
    ##   ..$ size         : NULL
    ##   ..$ hjust        : NULL
    ##   ..$ vjust        : NULL
    ##   ..$ angle        : num 90
    ##   ..$ lineheight   : NULL
    ##   ..$ margin       : NULL
    ##   ..$ debug        : NULL
    ##   ..$ inherit.blank: logi TRUE
    ##   ..- attr(*, "class")= chr [1:2] "element_text" "element"
    ##  $ strip.text.y.right        : NULL
    ##  $ strip.switch.pad.grid     : 'simpleUnit' num 2.75points
    ##   ..- attr(*, "unit")= int 8
    ##  $ strip.switch.pad.wrap     : 'simpleUnit' num 2.75points
    ##   ..- attr(*, "unit")= int 8
    ##  - attr(*, "class")= chr [1:2] "theme" "gg"
    ##  - attr(*, "complete")= logi TRUE
    ##  - attr(*, "validate")= logi TRUE

### Date range summary

    ## Rows: 1
    ## Columns: 4
    ## $ gage_number  <chr> "11522500"
    ## $ min_date     <date> 1911-10-01
    ## $ max_date     <date> 2024-12-02
    ## $ record_count <int> 36953

## Sprague

Sprague River Near Chiloquin, OR - 11501000

    sprague_usgs_gage <- dataRetrieval::readNWISdv(11501000, "00060") |> 
      select(date = Date, value =  X_00060_00003) |>  # rename to value
      as_tibble() |> 
      mutate(stream = "sprague river",
             gage_agency = "USGS",
             gage_number = "11501000",
             parameter = "flow",
             statistic = "mean", # if query returns instantaneous data then report a min, mean, and max
             latitude = dataRetrieval::readNWISsite("11501000")$dec_lat_va, # directly add lat
             longitude = dataRetrieval::readNWISsite("11501000")$dec_long_va # directly add lon
             )

### Map plot Sprague

    sprague_gage_dates <- sprague_usgs_gage |> 
      group_by(gage_number) |> 
      summarise(min_date = min(date), max_date = max(date))

    unique_gage_data_sprague <- sprague_usgs_gage |> 
      distinct(gage_number, latitude, longitude, .keep_all = TRUE) |> 
      left_join(sprague_gage_dates, by = "gage_number")

    unique_gage_data_sprague_sf <- unique_gage_data_sprague |> 
      st_as_sf(coords = c("longitude", "latitude"), crs = 4326)

    leaflet(unique_gage_data_sprague_sf) |> 
      addTiles() |> 
      addCircleMarkers(popup = ~paste0("Stream name: ", stream, "<br>Gage Number: ", gage_number, "<br>Max Date: ", max_date, "<br>Min Date: ", min_date))

<div class="leaflet html-widget html-fill-item-overflow-hidden html-fill-item" id="htmlwidget-efc3a7d623ba98c70902" style="width:672px;height:480px;"></div>
<script type="application/json" data-for="htmlwidget-efc3a7d623ba98c70902">{"x":{"options":{"crs":{"crsClass":"L.CRS.EPSG3857","code":null,"proj4def":null,"projectedBounds":null,"options":{}}},"calls":[{"method":"addTiles","args":["https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",null,null,{"minZoom":0,"maxZoom":18,"tileSize":256,"subdomains":"abc","errorTileUrl":"","tms":false,"noWrap":false,"zoomOffset":0,"zoomReverse":false,"opacity":1,"zIndex":1,"detectRetina":false,"attribution":"&copy; <a href=\"https://openstreetmap.org/copyright/\">OpenStreetMap<\/a>,  <a href=\"https://opendatacommons.org/licenses/odbl/\">ODbL<\/a>"}]},{"method":"addCircleMarkers","args":[42.58430556,-121.8483333,10,null,null,{"interactive":true,"className":"","stroke":true,"color":"#03F","weight":5,"opacity":0.5,"fill":true,"fillColor":"#03F","fillOpacity":0.2},null,null,"Stream name: sprague river<br>Gage Number: 11501000<br>Max Date: 2024-12-02<br>Min Date: 1921-03-01",null,null,{"interactive":false,"permanent":false,"direction":"auto","opacity":1,"offset":[0,0],"textsize":"10px","textOnly":false,"className":"","sticky":true},null]}],"limits":{"lat":[42.58430556,42.58430556],"lng":[-121.8483333,-121.8483333]}},"evals":[],"jsHooks":[]}</script>

### Date coverage plot

    sprague_usgs_gage |> ggplot(aes(x = year(date), y = value)) + 
      geom_line() + 
      scale_color_manual(values = colors_full) 

![](explore_flow_gages_files/figure-markdown_strict/unnamed-chunk-23-1.png)

      theme_minimal()

    ## List of 97
    ##  $ line                      :List of 6
    ##   ..$ colour       : chr "black"
    ##   ..$ linewidth    : num 0.5
    ##   ..$ linetype     : num 1
    ##   ..$ lineend      : chr "butt"
    ##   ..$ arrow        : logi FALSE
    ##   ..$ inherit.blank: logi TRUE
    ##   ..- attr(*, "class")= chr [1:2] "element_line" "element"
    ##  $ rect                      :List of 5
    ##   ..$ fill         : chr "white"
    ##   ..$ colour       : chr "black"
    ##   ..$ linewidth    : num 0.5
    ##   ..$ linetype     : num 1
    ##   ..$ inherit.blank: logi TRUE
    ##   ..- attr(*, "class")= chr [1:2] "element_rect" "element"
    ##  $ text                      :List of 11
    ##   ..$ family       : chr ""
    ##   ..$ face         : chr "plain"
    ##   ..$ colour       : chr "black"
    ##   ..$ size         : num 11
    ##   ..$ hjust        : num 0.5
    ##   ..$ vjust        : num 0.5
    ##   ..$ angle        : num 0
    ##   ..$ lineheight   : num 0.9
    ##   ..$ margin       : 'margin' num [1:4] 0points 0points 0points 0points
    ##   .. ..- attr(*, "unit")= int 8
    ##   ..$ debug        : logi FALSE
    ##   ..$ inherit.blank: logi TRUE
    ##   ..- attr(*, "class")= chr [1:2] "element_text" "element"
    ##  $ title                     : NULL
    ##  $ aspect.ratio              : NULL
    ##  $ axis.title                : NULL
    ##  $ axis.title.x              :List of 11
    ##   ..$ family       : NULL
    ##   ..$ face         : NULL
    ##   ..$ colour       : NULL
    ##   ..$ size         : NULL
    ##   ..$ hjust        : NULL
    ##   ..$ vjust        : num 1
    ##   ..$ angle        : NULL
    ##   ..$ lineheight   : NULL
    ##   ..$ margin       : 'margin' num [1:4] 2.75points 0points 0points 0points
    ##   .. ..- attr(*, "unit")= int 8
    ##   ..$ debug        : NULL
    ##   ..$ inherit.blank: logi TRUE
    ##   ..- attr(*, "class")= chr [1:2] "element_text" "element"
    ##  $ axis.title.x.top          :List of 11
    ##   ..$ family       : NULL
    ##   ..$ face         : NULL
    ##   ..$ colour       : NULL
    ##   ..$ size         : NULL
    ##   ..$ hjust        : NULL
    ##   ..$ vjust        : num 0
    ##   ..$ angle        : NULL
    ##   ..$ lineheight   : NULL
    ##   ..$ margin       : 'margin' num [1:4] 0points 0points 2.75points 0points
    ##   .. ..- attr(*, "unit")= int 8
    ##   ..$ debug        : NULL
    ##   ..$ inherit.blank: logi TRUE
    ##   ..- attr(*, "class")= chr [1:2] "element_text" "element"
    ##  $ axis.title.x.bottom       : NULL
    ##  $ axis.title.y              :List of 11
    ##   ..$ family       : NULL
    ##   ..$ face         : NULL
    ##   ..$ colour       : NULL
    ##   ..$ size         : NULL
    ##   ..$ hjust        : NULL
    ##   ..$ vjust        : num 1
    ##   ..$ angle        : num 90
    ##   ..$ lineheight   : NULL
    ##   ..$ margin       : 'margin' num [1:4] 0points 2.75points 0points 0points
    ##   .. ..- attr(*, "unit")= int 8
    ##   ..$ debug        : NULL
    ##   ..$ inherit.blank: logi TRUE
    ##   ..- attr(*, "class")= chr [1:2] "element_text" "element"
    ##  $ axis.title.y.left         : NULL
    ##  $ axis.title.y.right        :List of 11
    ##   ..$ family       : NULL
    ##   ..$ face         : NULL
    ##   ..$ colour       : NULL
    ##   ..$ size         : NULL
    ##   ..$ hjust        : NULL
    ##   ..$ vjust        : num 0
    ##   ..$ angle        : num -90
    ##   ..$ lineheight   : NULL
    ##   ..$ margin       : 'margin' num [1:4] 0points 0points 0points 2.75points
    ##   .. ..- attr(*, "unit")= int 8
    ##   ..$ debug        : NULL
    ##   ..$ inherit.blank: logi TRUE
    ##   ..- attr(*, "class")= chr [1:2] "element_text" "element"
    ##  $ axis.text                 :List of 11
    ##   ..$ family       : NULL
    ##   ..$ face         : NULL
    ##   ..$ colour       : chr "grey30"
    ##   ..$ size         : 'rel' num 0.8
    ##   ..$ hjust        : NULL
    ##   ..$ vjust        : NULL
    ##   ..$ angle        : NULL
    ##   ..$ lineheight   : NULL
    ##   ..$ margin       : NULL
    ##   ..$ debug        : NULL
    ##   ..$ inherit.blank: logi TRUE
    ##   ..- attr(*, "class")= chr [1:2] "element_text" "element"
    ##  $ axis.text.x               :List of 11
    ##   ..$ family       : NULL
    ##   ..$ face         : NULL
    ##   ..$ colour       : NULL
    ##   ..$ size         : NULL
    ##   ..$ hjust        : NULL
    ##   ..$ vjust        : num 1
    ##   ..$ angle        : NULL
    ##   ..$ lineheight   : NULL
    ##   ..$ margin       : 'margin' num [1:4] 2.2points 0points 0points 0points
    ##   .. ..- attr(*, "unit")= int 8
    ##   ..$ debug        : NULL
    ##   ..$ inherit.blank: logi TRUE
    ##   ..- attr(*, "class")= chr [1:2] "element_text" "element"
    ##  $ axis.text.x.top           :List of 11
    ##   ..$ family       : NULL
    ##   ..$ face         : NULL
    ##   ..$ colour       : NULL
    ##   ..$ size         : NULL
    ##   ..$ hjust        : NULL
    ##   ..$ vjust        : num 0
    ##   ..$ angle        : NULL
    ##   ..$ lineheight   : NULL
    ##   ..$ margin       : 'margin' num [1:4] 0points 0points 2.2points 0points
    ##   .. ..- attr(*, "unit")= int 8
    ##   ..$ debug        : NULL
    ##   ..$ inherit.blank: logi TRUE
    ##   ..- attr(*, "class")= chr [1:2] "element_text" "element"
    ##  $ axis.text.x.bottom        : NULL
    ##  $ axis.text.y               :List of 11
    ##   ..$ family       : NULL
    ##   ..$ face         : NULL
    ##   ..$ colour       : NULL
    ##   ..$ size         : NULL
    ##   ..$ hjust        : num 1
    ##   ..$ vjust        : NULL
    ##   ..$ angle        : NULL
    ##   ..$ lineheight   : NULL
    ##   ..$ margin       : 'margin' num [1:4] 0points 2.2points 0points 0points
    ##   .. ..- attr(*, "unit")= int 8
    ##   ..$ debug        : NULL
    ##   ..$ inherit.blank: logi TRUE
    ##   ..- attr(*, "class")= chr [1:2] "element_text" "element"
    ##  $ axis.text.y.left          : NULL
    ##  $ axis.text.y.right         :List of 11
    ##   ..$ family       : NULL
    ##   ..$ face         : NULL
    ##   ..$ colour       : NULL
    ##   ..$ size         : NULL
    ##   ..$ hjust        : num 0
    ##   ..$ vjust        : NULL
    ##   ..$ angle        : NULL
    ##   ..$ lineheight   : NULL
    ##   ..$ margin       : 'margin' num [1:4] 0points 0points 0points 2.2points
    ##   .. ..- attr(*, "unit")= int 8
    ##   ..$ debug        : NULL
    ##   ..$ inherit.blank: logi TRUE
    ##   ..- attr(*, "class")= chr [1:2] "element_text" "element"
    ##  $ axis.ticks                : list()
    ##   ..- attr(*, "class")= chr [1:2] "element_blank" "element"
    ##  $ axis.ticks.x              : NULL
    ##  $ axis.ticks.x.top          : NULL
    ##  $ axis.ticks.x.bottom       : NULL
    ##  $ axis.ticks.y              : NULL
    ##  $ axis.ticks.y.left         : NULL
    ##  $ axis.ticks.y.right        : NULL
    ##  $ axis.ticks.length         : 'simpleUnit' num 2.75points
    ##   ..- attr(*, "unit")= int 8
    ##  $ axis.ticks.length.x       : NULL
    ##  $ axis.ticks.length.x.top   : NULL
    ##  $ axis.ticks.length.x.bottom: NULL
    ##  $ axis.ticks.length.y       : NULL
    ##  $ axis.ticks.length.y.left  : NULL
    ##  $ axis.ticks.length.y.right : NULL
    ##  $ axis.line                 : list()
    ##   ..- attr(*, "class")= chr [1:2] "element_blank" "element"
    ##  $ axis.line.x               : NULL
    ##  $ axis.line.x.top           : NULL
    ##  $ axis.line.x.bottom        : NULL
    ##  $ axis.line.y               : NULL
    ##  $ axis.line.y.left          : NULL
    ##  $ axis.line.y.right         : NULL
    ##  $ legend.background         : list()
    ##   ..- attr(*, "class")= chr [1:2] "element_blank" "element"
    ##  $ legend.margin             : 'margin' num [1:4] 5.5points 5.5points 5.5points 5.5points
    ##   ..- attr(*, "unit")= int 8
    ##  $ legend.spacing            : 'simpleUnit' num 11points
    ##   ..- attr(*, "unit")= int 8
    ##  $ legend.spacing.x          : NULL
    ##  $ legend.spacing.y          : NULL
    ##  $ legend.key                : list()
    ##   ..- attr(*, "class")= chr [1:2] "element_blank" "element"
    ##  $ legend.key.size           : 'simpleUnit' num 1.2lines
    ##   ..- attr(*, "unit")= int 3
    ##  $ legend.key.height         : NULL
    ##  $ legend.key.width          : NULL
    ##  $ legend.text               :List of 11
    ##   ..$ family       : NULL
    ##   ..$ face         : NULL
    ##   ..$ colour       : NULL
    ##   ..$ size         : 'rel' num 0.8
    ##   ..$ hjust        : NULL
    ##   ..$ vjust        : NULL
    ##   ..$ angle        : NULL
    ##   ..$ lineheight   : NULL
    ##   ..$ margin       : NULL
    ##   ..$ debug        : NULL
    ##   ..$ inherit.blank: logi TRUE
    ##   ..- attr(*, "class")= chr [1:2] "element_text" "element"
    ##  $ legend.text.align         : NULL
    ##  $ legend.title              :List of 11
    ##   ..$ family       : NULL
    ##   ..$ face         : NULL
    ##   ..$ colour       : NULL
    ##   ..$ size         : NULL
    ##   ..$ hjust        : num 0
    ##   ..$ vjust        : NULL
    ##   ..$ angle        : NULL
    ##   ..$ lineheight   : NULL
    ##   ..$ margin       : NULL
    ##   ..$ debug        : NULL
    ##   ..$ inherit.blank: logi TRUE
    ##   ..- attr(*, "class")= chr [1:2] "element_text" "element"
    ##  $ legend.title.align        : NULL
    ##  $ legend.position           : chr "right"
    ##  $ legend.direction          : NULL
    ##  $ legend.justification      : chr "center"
    ##  $ legend.box                : NULL
    ##  $ legend.box.just           : NULL
    ##  $ legend.box.margin         : 'margin' num [1:4] 0cm 0cm 0cm 0cm
    ##   ..- attr(*, "unit")= int 1
    ##  $ legend.box.background     : list()
    ##   ..- attr(*, "class")= chr [1:2] "element_blank" "element"
    ##  $ legend.box.spacing        : 'simpleUnit' num 11points
    ##   ..- attr(*, "unit")= int 8
    ##  $ panel.background          : list()
    ##   ..- attr(*, "class")= chr [1:2] "element_blank" "element"
    ##  $ panel.border              : list()
    ##   ..- attr(*, "class")= chr [1:2] "element_blank" "element"
    ##  $ panel.spacing             : 'simpleUnit' num 5.5points
    ##   ..- attr(*, "unit")= int 8
    ##  $ panel.spacing.x           : NULL
    ##  $ panel.spacing.y           : NULL
    ##  $ panel.grid                :List of 6
    ##   ..$ colour       : chr "grey92"
    ##   ..$ linewidth    : NULL
    ##   ..$ linetype     : NULL
    ##   ..$ lineend      : NULL
    ##   ..$ arrow        : logi FALSE
    ##   ..$ inherit.blank: logi TRUE
    ##   ..- attr(*, "class")= chr [1:2] "element_line" "element"
    ##  $ panel.grid.major          : NULL
    ##  $ panel.grid.minor          :List of 6
    ##   ..$ colour       : NULL
    ##   ..$ linewidth    : 'rel' num 0.5
    ##   ..$ linetype     : NULL
    ##   ..$ lineend      : NULL
    ##   ..$ arrow        : logi FALSE
    ##   ..$ inherit.blank: logi TRUE
    ##   ..- attr(*, "class")= chr [1:2] "element_line" "element"
    ##  $ panel.grid.major.x        : NULL
    ##  $ panel.grid.major.y        : NULL
    ##  $ panel.grid.minor.x        : NULL
    ##  $ panel.grid.minor.y        : NULL
    ##  $ panel.ontop               : logi FALSE
    ##  $ plot.background           : list()
    ##   ..- attr(*, "class")= chr [1:2] "element_blank" "element"
    ##  $ plot.title                :List of 11
    ##   ..$ family       : NULL
    ##   ..$ face         : NULL
    ##   ..$ colour       : NULL
    ##   ..$ size         : 'rel' num 1.2
    ##   ..$ hjust        : num 0
    ##   ..$ vjust        : num 1
    ##   ..$ angle        : NULL
    ##   ..$ lineheight   : NULL
    ##   ..$ margin       : 'margin' num [1:4] 0points 0points 5.5points 0points
    ##   .. ..- attr(*, "unit")= int 8
    ##   ..$ debug        : NULL
    ##   ..$ inherit.blank: logi TRUE
    ##   ..- attr(*, "class")= chr [1:2] "element_text" "element"
    ##  $ plot.title.position       : chr "panel"
    ##  $ plot.subtitle             :List of 11
    ##   ..$ family       : NULL
    ##   ..$ face         : NULL
    ##   ..$ colour       : NULL
    ##   ..$ size         : NULL
    ##   ..$ hjust        : num 0
    ##   ..$ vjust        : num 1
    ##   ..$ angle        : NULL
    ##   ..$ lineheight   : NULL
    ##   ..$ margin       : 'margin' num [1:4] 0points 0points 5.5points 0points
    ##   .. ..- attr(*, "unit")= int 8
    ##   ..$ debug        : NULL
    ##   ..$ inherit.blank: logi TRUE
    ##   ..- attr(*, "class")= chr [1:2] "element_text" "element"
    ##  $ plot.caption              :List of 11
    ##   ..$ family       : NULL
    ##   ..$ face         : NULL
    ##   ..$ colour       : NULL
    ##   ..$ size         : 'rel' num 0.8
    ##   ..$ hjust        : num 1
    ##   ..$ vjust        : num 1
    ##   ..$ angle        : NULL
    ##   ..$ lineheight   : NULL
    ##   ..$ margin       : 'margin' num [1:4] 5.5points 0points 0points 0points
    ##   .. ..- attr(*, "unit")= int 8
    ##   ..$ debug        : NULL
    ##   ..$ inherit.blank: logi TRUE
    ##   ..- attr(*, "class")= chr [1:2] "element_text" "element"
    ##  $ plot.caption.position     : chr "panel"
    ##  $ plot.tag                  :List of 11
    ##   ..$ family       : NULL
    ##   ..$ face         : NULL
    ##   ..$ colour       : NULL
    ##   ..$ size         : 'rel' num 1.2
    ##   ..$ hjust        : num 0.5
    ##   ..$ vjust        : num 0.5
    ##   ..$ angle        : NULL
    ##   ..$ lineheight   : NULL
    ##   ..$ margin       : NULL
    ##   ..$ debug        : NULL
    ##   ..$ inherit.blank: logi TRUE
    ##   ..- attr(*, "class")= chr [1:2] "element_text" "element"
    ##  $ plot.tag.position         : chr "topleft"
    ##  $ plot.margin               : 'margin' num [1:4] 5.5points 5.5points 5.5points 5.5points
    ##   ..- attr(*, "unit")= int 8
    ##  $ strip.background          : list()
    ##   ..- attr(*, "class")= chr [1:2] "element_blank" "element"
    ##  $ strip.background.x        : NULL
    ##  $ strip.background.y        : NULL
    ##  $ strip.clip                : chr "inherit"
    ##  $ strip.placement           : chr "inside"
    ##  $ strip.text                :List of 11
    ##   ..$ family       : NULL
    ##   ..$ face         : NULL
    ##   ..$ colour       : chr "grey10"
    ##   ..$ size         : 'rel' num 0.8
    ##   ..$ hjust        : NULL
    ##   ..$ vjust        : NULL
    ##   ..$ angle        : NULL
    ##   ..$ lineheight   : NULL
    ##   ..$ margin       : 'margin' num [1:4] 4.4points 4.4points 4.4points 4.4points
    ##   .. ..- attr(*, "unit")= int 8
    ##   ..$ debug        : NULL
    ##   ..$ inherit.blank: logi TRUE
    ##   ..- attr(*, "class")= chr [1:2] "element_text" "element"
    ##  $ strip.text.x              : NULL
    ##  $ strip.text.x.bottom       : NULL
    ##  $ strip.text.x.top          : NULL
    ##  $ strip.text.y              :List of 11
    ##   ..$ family       : NULL
    ##   ..$ face         : NULL
    ##   ..$ colour       : NULL
    ##   ..$ size         : NULL
    ##   ..$ hjust        : NULL
    ##   ..$ vjust        : NULL
    ##   ..$ angle        : num -90
    ##   ..$ lineheight   : NULL
    ##   ..$ margin       : NULL
    ##   ..$ debug        : NULL
    ##   ..$ inherit.blank: logi TRUE
    ##   ..- attr(*, "class")= chr [1:2] "element_text" "element"
    ##  $ strip.text.y.left         :List of 11
    ##   ..$ family       : NULL
    ##   ..$ face         : NULL
    ##   ..$ colour       : NULL
    ##   ..$ size         : NULL
    ##   ..$ hjust        : NULL
    ##   ..$ vjust        : NULL
    ##   ..$ angle        : num 90
    ##   ..$ lineheight   : NULL
    ##   ..$ margin       : NULL
    ##   ..$ debug        : NULL
    ##   ..$ inherit.blank: logi TRUE
    ##   ..- attr(*, "class")= chr [1:2] "element_text" "element"
    ##  $ strip.text.y.right        : NULL
    ##  $ strip.switch.pad.grid     : 'simpleUnit' num 2.75points
    ##   ..- attr(*, "unit")= int 8
    ##  $ strip.switch.pad.wrap     : 'simpleUnit' num 2.75points
    ##   ..- attr(*, "unit")= int 8
    ##  - attr(*, "class")= chr [1:2] "theme" "gg"
    ##  - attr(*, "complete")= logi TRUE
    ##  - attr(*, "validate")= logi TRUE

### Date range summary

    ## Rows: 1
    ## Columns: 4
    ## $ gage_number  <chr> "11501000"
    ## $ min_date     <date> 1921-03-01
    ## $ max_date     <date> 2024-12-02
    ## $ record_count <int> 37898

## Indian Creek

List of USGS gages in Klamath watershed:

-   Indian C NR Douglas City CA - 11525670
-   Indian C NR Happy Camp CA - 11521500

<!-- -->

    indian_usgs_doug <- dataRetrieval::readNWISdv(11525670, "00060") |> 
      select(date = Date, value =  X_00060_00003) |>  # rename to value
      as_tibble() |> 
      mutate(stream = "indian creek",
             gage_agency = "USGS",
             gage_number = "11525670",
             parameter = "flow",
             statistic = "mean", # if query returns instantaneous data then report a min, mean, and max
             latitude = dataRetrieval::readNWISsite("11525670")$dec_lat_va, # directly add lat
             longitude = dataRetrieval::readNWISsite("11525670")$dec_long_va # directly add lon
             )
    indian_usgs_happy <- dataRetrieval::readNWISdv(11521500, "00060") |> 
      select(date = Date, value =  X_00060_00003) |>  # rename to value
      as_tibble() |> 
      mutate(stream = "indian creek",
             gage_agency = "USGS",
             gage_number = "11521500",
             parameter = "flow",
             statistic = "mean", # if query returns instantaneous data then report a min, mean, and max
             latitude = dataRetrieval::readNWISsite("11521500")$dec_lat_va, # directly add lat
             longitude = dataRetrieval::readNWISsite("11521500")$dec_long_va # directly add lon
             )

    all_indian_usgs_gages <- bind_rows(indian_usgs_doug, indian_usgs_happy) |>
      glimpse()

    ## Rows: 32,008
    ## Columns: 9
    ## $ date        <date> 2004-10-01, 2004-10-02, 2004-10-03, 2004-10-04, 2004-10-0…
    ## $ value       <dbl> 2.74, 2.74, 2.82, 2.81, 2.82, 2.83, 2.88, 2.98, 3.40, 3.40…
    ## $ stream      <chr> "indian creek", "indian creek", "indian creek", "indian cr…
    ## $ gage_agency <chr> "USGS", "USGS", "USGS", "USGS", "USGS", "USGS", "USGS", "U…
    ## $ gage_number <chr> "11525670", "11525670", "11525670", "11525670", "11525670"…
    ## $ parameter   <chr> "flow", "flow", "flow", "flow", "flow", "flow", "flow", "f…
    ## $ statistic   <chr> "mean", "mean", "mean", "mean", "mean", "mean", "mean", "m…
    ## $ latitude    <dbl> 40.65181, 40.65181, 40.65181, 40.65181, 40.65181, 40.65181…
    ## $ longitude   <dbl> -122.9145, -122.9145, -122.9145, -122.9145, -122.9145, -12…

### Map Plot Klamath USGS Gages - TODO check on location of this stream

    # Filter to keep only one unique gage per location
    indian_gage_dates <- all_indian_usgs_gages |> 
      group_by(gage_number) |> 
      summarise(min_date = min(date), max_date = max(date))

    unique_gage_data_indian <- all_indian_usgs_gages |> 
      distinct(gage_number, latitude, longitude, .keep_all = TRUE) |> 
      left_join(indian_gage_dates, by = "gage_number")

    unique_gage_indian <- unique_gage_data_indian |> 
      st_as_sf(coords = c("longitude", "latitude"), crs = 4326)

    leaflet(unique_gage_indian) |> 
      addTiles() |> 
      addCircleMarkers(popup = ~paste0("Stream name: ", stream, "<br>Gage Number: ", gage_number, "<br>Max Date: ", max_date, "<br>Min Date: ", min_date))

<div class="leaflet html-widget html-fill-item-overflow-hidden html-fill-item" id="htmlwidget-8dfdf6b5a6bbef78f5de" style="width:672px;height:480px;"></div>
<script type="application/json" data-for="htmlwidget-8dfdf6b5a6bbef78f5de">{"x":{"options":{"crs":{"crsClass":"L.CRS.EPSG3857","code":null,"proj4def":null,"projectedBounds":null,"options":{}}},"calls":[{"method":"addTiles","args":["https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",null,null,{"minZoom":0,"maxZoom":18,"tileSize":256,"subdomains":"abc","errorTileUrl":"","tms":false,"noWrap":false,"zoomOffset":0,"zoomReverse":false,"opacity":1,"zIndex":1,"detectRetina":false,"attribution":"&copy; <a href=\"https://openstreetmap.org/copyright/\">OpenStreetMap<\/a>,  <a href=\"https://opendatacommons.org/licenses/odbl/\">ODbL<\/a>"}]},{"method":"addCircleMarkers","args":[[40.65181225,41.83509438],[-122.9144689,-123.383078],10,null,null,{"interactive":true,"className":"","stroke":true,"color":"#03F","weight":5,"opacity":0.5,"fill":true,"fillColor":"#03F","fillOpacity":0.2},null,null,["Stream name: indian creek<br>Gage Number: 11525670<br>Max Date: 2024-12-02<br>Min Date: 2004-10-01","Stream name: indian creek<br>Gage Number: 11521500<br>Max Date: 2024-12-02<br>Min Date: 1956-12-15"],null,null,{"interactive":false,"permanent":false,"direction":"auto","opacity":1,"offset":[0,0],"textsize":"10px","textOnly":false,"className":"","sticky":true},null]}],"limits":{"lat":[40.65181225,41.83509438],"lng":[-123.383078,-122.9144689]}},"evals":[],"jsHooks":[]}</script>

### Date coverage

    all_indian_usgs_gages |> ggplot(aes(x = date, y = value, color = gage_number)) + 
      geom_line() + 
      scale_color_manual(values = colors_full) +
      facet_wrap(~gage_number) +
      theme_minimal()

![](explore_flow_gages_files/figure-markdown_strict/unnamed-chunk-27-1.png)

## Other streams - Oregon

-   Klamath Straits Drain Near Worden, OR - 11509340
-   Ady Canal Above Lower Klamath Nwr, Near Worden, OR - 11509250
-   North Canal at Highway 97, Near Midland, OR - 11509105
-   Link River at Klamath Falls, OR - 11507500
-   Williamson River Blw Sprague River NR Chiloquin,or - 11502500
-   Crystal Creek Near Rocky Point, OR - 11504270 - NODATA
-   Fourmile Canal Near Klamath Agency, OR - 11504260
-   Sevenmile Cnl at Dike RD Br, NR Klamath Agency, OR - 11504290

### Map Plot Trinity USGS Gages

<div class="leaflet html-widget html-fill-item-overflow-hidden html-fill-item" id="htmlwidget-42ce5af48e7d74e27397" style="width:672px;height:480px;"></div>
<script type="application/json" data-for="htmlwidget-42ce5af48e7d74e27397">{"x":{"options":{"crs":{"crsClass":"L.CRS.EPSG3857","code":null,"proj4def":null,"projectedBounds":null,"options":{}}},"calls":[{"method":"addTiles","args":["https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",null,null,{"minZoom":0,"maxZoom":18,"tileSize":256,"subdomains":"abc","errorTileUrl":"","tms":false,"noWrap":false,"zoomOffset":0,"zoomReverse":false,"opacity":1,"zIndex":1,"detectRetina":false,"attribution":"&copy; <a href=\"https://openstreetmap.org/copyright/\">OpenStreetMap<\/a>,  <a href=\"https://opendatacommons.org/licenses/odbl/\">ODbL<\/a>"}]},{"method":"addCircleMarkers","args":[[42.08095278,42.00416667,42.12138889,42.22347795,42.564375,42.5745,42.58166667],[-121.8483222,-121.8258333,-121.8267528,-121.7941708,-121.8797139,-122.051361,-121.9713889],10,null,null,{"interactive":true,"className":"","stroke":true,"color":"#03F","weight":5,"opacity":0.5,"fill":true,"fillColor":"#03F","fillOpacity":0.2},null,null,["Stream name: other<br>Gage Number: 11509340<br>Max Date: 2024-12-01<br>Min Date: 2011-10-31","Stream name: other<br>Gage Number: 11509250<br>Max Date: 2024-12-02<br>Min Date: 2012-09-30","Stream name: other<br>Gage Number: 11509105<br>Max Date: 2024-12-02<br>Min Date: 2012-02-29","Stream name: other<br>Gage Number: 11507500<br>Max Date: 2024-12-02<br>Min Date: 1961-10-01","Stream name: other<br>Gage Number: 11502500<br>Max Date: 2024-12-02<br>Min Date: 1917-10-01","Stream name: other<br>Gage Number: 11504260<br>Max Date: 2024-12-02<br>Min Date: 2021-08-05","Stream name: other<br>Gage Number: 11504290<br>Max Date: 2024-12-02<br>Min Date: 2017-05-04"],null,null,{"interactive":false,"permanent":false,"direction":"auto","opacity":1,"offset":[0,0],"textsize":"10px","textOnly":false,"className":"","sticky":true},null]}],"limits":{"lat":[42.00416667,42.58166667],"lng":[-122.051361,-121.7941708]}},"evals":[],"jsHooks":[]}</script>

### Date coverage

### Date range summary

    ## Rows: 7
    ## Columns: 4
    ## $ gage_number  <chr> "11502500", "11504260", "11504290", "11507500", "11509105…
    ## $ min_date     <date> 1917-10-01, 2021-08-05, 2017-05-04, 1961-10-01, 2012-02-…
    ## $ max_date     <date> 2024-12-02, 2024-12-02, 2024-12-02, 2024-12-02, 2024-12-…
    ## $ record_count <int> 38811, 1209, 2769, 23074, 4661, 4438, 4773

## Combing all streams

<div class="leaflet html-widget html-fill-item-overflow-hidden html-fill-item" id="htmlwidget-99a99186a99174a8eddc" style="width:672px;height:480px;"></div>
<script type="application/json" data-for="htmlwidget-99a99186a99174a8eddc">{"x":{"options":{"crs":{"crsClass":"L.CRS.EPSG3857","code":null,"proj4def":null,"projectedBounds":null,"options":{}}},"calls":[{"method":"addTiles","args":["https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",null,null,{"minZoom":0,"maxZoom":18,"tileSize":256,"subdomains":"abc","errorTileUrl":"","tms":false,"noWrap":false,"zoomOffset":0,"zoomReverse":false,"opacity":1,"zIndex":1,"detectRetina":false,"attribution":"&copy; <a href=\"https://openstreetmap.org/copyright/\">OpenStreetMap<\/a>,  <a href=\"https://opendatacommons.org/licenses/odbl/\">ODbL<\/a>"}]},{"method":"addCircleMarkers","args":[[42.13319946,42.0845877,41.92791865,41.8537379,41.3034599,41.5109543,40.6498627,41.049852,41.1112571,40.7247222,40.6726453,40.64527778,40.7284768,40.76653148,40.7887498,41.64069017,41.70903196,41.8229179,41.3765154,42.58430556,40.65181225,41.83509438,42.08095278,42.00416667,42.12138889,42.22347795,42.564375,42.5745,42.58166667],[-121.9622313,-122.0733453,-122.4441882,-123.2322733,-123.5345036,-123.9795164,-123.4942046,-123.673668,-122.7055788,-122.801111,-122.9205805,-122.9566667,-123.0619736,-123.1144757,-123.4400401,-123.015037,-122.5380787,-122.5955813,-123.4770026,-121.8483333,-122.9144689,-123.383078,-121.8483222,-121.8258333,-121.8267528,-121.7941708,-121.8797139,-122.051361,-121.9713889],10,null,null,{"interactive":true,"className":"","stroke":true,"color":"#03F","weight":5,"opacity":0.5,"fill":true,"fillColor":"#03F","fillOpacity":0.2},null,null,["Stream name: klamath river<br>Gage Number: 11509500<br>Latest Date: 2024-12-02<br>Earliest Date: 1950-01-01","Stream name: klamath river<br>Gage Number: 11510700<br>Latest Date: 2024-12-02<br>Earliest Date: 1995-01-01","Stream name: klamath river<br>Gage Number: 11516530<br>Latest Date: 2024-12-02<br>Earliest Date: 1960-10-01","Stream name: klamath river<br>Gage Number: 11520500<br>Latest Date: 2024-12-02<br>Earliest Date: 1951-10-01","Stream name: klamath river<br>Gage Number: 11523000<br>Latest Date: 2024-12-02<br>Earliest Date: 1950-01-01","Stream name: klamath river<br>Gage Number: 11530500<br>Latest Date: 2024-12-02<br>Earliest Date: 1950-10-01","Stream name: trinity river - south fork<br>Gage Number: 11528700<br>Latest Date: 2024-12-02<br>Earliest Date: 1965-10-01","Stream name: trinity river<br>Gage Number: 11530000<br>Latest Date: 2024-12-02<br>Earliest Date: 1911-10-01","Stream name: trinity river<br>Gage Number: 11523200<br>Latest Date: 2024-12-02<br>Earliest Date: 1957-10-01","Stream name: trinity river<br>Gage Number: 11525500<br>Latest Date: 2024-12-02<br>Earliest Date: 1911-10-01","Stream name: trinity river<br>Gage Number: 11525655<br>Latest Date: 2024-12-02<br>Earliest Date: 1981-04-28","Stream name: trinity river<br>Gage Number: 11525854<br>Latest Date: 2024-12-02<br>Earliest Date: 2002-10-01","Stream name: trinity river<br>Gage Number: 11526250<br>Latest Date: 2024-12-02<br>Earliest Date: 2002-10-01","Stream name: trinity river<br>Gage Number: 11526400<br>Latest Date: 2024-12-02<br>Earliest Date: 2005-03-29","Stream name: trinity river<br>Gage Number: 11527000<br>Latest Date: 2024-12-02<br>Earliest Date: 1931-10-01","Stream name: scott river<br>Gage Number: 11519500<br>Latest Date: 2024-12-02<br>Earliest Date: 1941-10-01","Stream name: shasta river<br>Gage Number: 11517000<br>Latest Date: 2024-12-02<br>Earliest Date: 1911-10-01","Stream name: shasta river<br>Gage Number: 11517500<br>Latest Date: 2024-12-02<br>Earliest Date: 1933-10-01","Stream name: shasta river<br>Gage Number: 11522500<br>Latest Date: 2024-12-02<br>Earliest Date: 1911-10-01","Stream name: sprague river<br>Gage Number: 11501000<br>Latest Date: 2024-12-02<br>Earliest Date: 1921-03-01","Stream name: indian creek<br>Gage Number: 11525670<br>Latest Date: 2024-12-02<br>Earliest Date: 2004-10-01","Stream name: indian creek<br>Gage Number: 11521500<br>Latest Date: 2024-12-02<br>Earliest Date: 1956-12-15","Stream name: other<br>Gage Number: 11509340<br>Latest Date: 2024-12-01<br>Earliest Date: 2011-10-31","Stream name: other<br>Gage Number: 11509250<br>Latest Date: 2024-12-02<br>Earliest Date: 2012-09-30","Stream name: other<br>Gage Number: 11509105<br>Latest Date: 2024-12-02<br>Earliest Date: 2012-02-29","Stream name: other<br>Gage Number: 11507500<br>Latest Date: 2024-12-02<br>Earliest Date: 1961-10-01","Stream name: other<br>Gage Number: 11502500<br>Latest Date: 2024-12-02<br>Earliest Date: 1917-10-01","Stream name: other<br>Gage Number: 11504260<br>Latest Date: 2024-12-02<br>Earliest Date: 2021-08-05","Stream name: other<br>Gage Number: 11504290<br>Latest Date: 2024-12-02<br>Earliest Date: 2017-05-04"],null,null,{"interactive":false,"permanent":false,"direction":"auto","opacity":1,"offset":[0,0],"textsize":"10px","textOnly":false,"className":"","sticky":true},null]}],"limits":{"lat":[40.64527778,42.58430556],"lng":[-123.9795164,-121.7941708]}},"evals":[],"jsHooks":[]}</script>

Save clean table

    # write.csv(kl_basin_table, "data/
