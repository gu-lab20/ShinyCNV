#CNViewer
#Author: Zhaohui Gu
#Email: gzhmat@gmail.com
#URL: https://github.com/gzhmat/CNViewer

#ui.R is running----
print("Run ui.R")

#init the app
source("./init.R")

fluidPage(
  theme = "style.css",
  title = 'CNViewer', #webpage title
  h3('Copy Number Variaion Viewer'), #top-left title
  fluidRow(
    column(3, 
           fileInput("cnvFile", "Choose CNV File", accept = c('text/csv') ), # browse cnv file
           column(5, verbatimTextOutput("inputFileText") )
    )#cnv file input status
  ),
  hr(),
  conditionalPanel("output.fileUploaded == true",
    sidebarLayout(
      #sidebarPanel----
      sidebarPanel(width =4,
                   DT::dataTableOutput('cnvTbl'),
                   actionButton("getSNPdata", "Read in SNP data"),
                   actionButton("prevCNV", "Prev CNV"),
                   actionButton("nextCNV", "Next CNV"),
                   verbatimTextOutput("SNPdataStatus", placeholder = TRUE),
                   actionButton("addCNV", "Add CNV"),
                   actionButton("setGermCNV", "Germ CNV"),
                   actionButton("setCoveredCNV", "Covered CNV"),
                   actionButton("setFalseCNV", "False CNV"),
                   actionButton("setTrueCNV", "True CNV"),
                   splitLayout(
                     cellWidths = c(85, 80),
                     actionButton("setChr", "Set Chr"),
                     textInput("chr", "", placeholder = ""),
                     actionButton("setCN", "Set CN"),
                     textInput("copyNum", "", placeholder = ""),
                     actionButton("setNormRate", "Set NR"),
                     textInput("normRate", "", placeholder = "")
                   ),
                   #delete, set dup and clear SNP data----
                   actionButton("delCNV", "Delete CNV"),
                   #actionButton("setDupCNV", "Dup CNV"),
                   actionButton("clearSNPdata", "Clear SNPdata")
      ),
      conditionalPanel("output.SNPloaded == true",
        #mainPanel----
        mainPanel(width=8,
                  fluidRow(
                    #BAF, LRR and gene list plot----
                    column(12, plotOutput('caseBAF', height = bafLrrHeight, click = "caseBAF_click",
                                          brush = brushOpts("caseBAF_brush", delay = 500, delayType ="debounce", resetOnNew = T))),
                    column(12, plotOutput('ctrlBAF', height = bafLrrHeight )),
                    column(12, plotOutput('caseLRR', height = bafLrrHeight, click = "caseLRR_click",
                                          brush = brushOpts("caseLRR_brush", delay = 500, delayType ="debounce", resetOnNew = T))),
                    column(12, plotOutput('ctrlLRR', height = bafLrrHeight )),
                    column(12, plotOutput('genePlot', height = genePlotHeight , click = "genePlot_click")),
                    
                    #set position by selecting near point----
                    column(2, selectInput("getChrPos", "Chr:", c("NA", 'start', 'end'))),
                    column(2, textInput("position", "Pos:", placeholder = "", width = "200")),
                    column(1, actionButton("setStart", "Set Start")),
                    column(1, actionButton("setEnd", "Set End")),
                    
                    #zoon out----
                    column(1, actionButton("zoomOut2X", "Zoom out 2X")),
                    column(1, actionButton("zoomOut5X", "Zoom out 5X")),
                    column(1, actionButton("zoomOut10X", "Zoom out 10X"))
                  ),
                  column(2, tableOutput('geneTbl') )
                  
        )
      )
    ),
    conditionalPanel("output.SNPloaded == true",
      hr(),
      splitLayout(
            cellWidths = c(100, 200, 300, 120, 120, 120, 120),
            actionButton("setChrGene", "Chr/Gene"),
            textInput("chrGeneName", "", placeholder = ""),
            verbatimTextOutput("spectPos", placeholder = TRUE),
            actionButton("zoomOut2XSpect", "Zoom out 2X"),
            actionButton("zoomOut5XSpect", "Zoom out 5X"),
            actionButton("zoomOut10XSpect", "Zoom out 10X")
      ),
      plotOutput('spectrumPlot',
                 brush = brushOpts("spect_brush", delay = 500, delayType ="debounce", resetOnNew = T))
    )
  ),
  #allow read in cnv file again----
  tags$script('$( "#cnvFile" ).on( "click", function() { this.value = null; });')
)