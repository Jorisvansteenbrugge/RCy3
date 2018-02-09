# ==============================================================================
# Functions for performing VIEW operations in addition to getting and setting 
# view properties. 
# 
# Dev Notes: refer to StyleValues.R, StyleDefaults.R and StyleBypasses.R for 
# getting/setting node, edge and network visual properties via VIEW operations.
# ------------------------------------------------------------------------------
#' @export
getNetworkViews <- function(network=NULL, base.url =.defaultBaseUrl) {
    net.SUID <- getNetworkSuid(network)
    res <- cyrestGET(paste("networks", net.SUID, "views", sep="/"),base.url = base.url)
    return(res)
}

# ------------------------------------------------------------------------------
#' @export
fitContent <- function(selected.only=FALSE, network=NULL, 
                       base.url =.defaultBaseUrl) {
    net.SUID <- getNetworkSuid(network)
    if(selected.only){
        cur.SUID <- getNetworkSuid('current')
        commandsPOST(paste0('view set current network=SUID:"',net.SUID,'"'), 
                     base.url = base.url)
        commandsPOST('view fit selected', base.url = base.url)
        commandsPOST(paste0('view set current network=SUID:"',cur.SUID,'"'), 
                     base.url = base.url)
    } else {
        res <- cyrestGET(paste("apply/fit", net.SUID, sep="/"),
                         base.url = base.url)
        invisible(res)
    }
}

# ------------------------------------------------------------------------------
#' Export Image
#' 
#' @description Saves the current network view as an image file.
#' @details The image is cropped per the current view in Cytoscape. Consider
#' applying \code{\link{fitContent}} prior to export.
#' @param filename (\code{character}) Name of the image file to save. By default, the view's title 
#' is used as the file name and the last valid export path from the current session is used.
#' @param type (\code{character}) Type of image to export, e.g., JPEG, PDF, PNG, PostScript, SVG (case sensitive).
#' @param resolution (\code{numeric}) The resolution of the exported image, in DPI. Valid 
#' only for bitmap formats, when the selected width and height 'units' is inches. The 
#' possible values are: 72 (default), 100, 150, 300, 600. 
#' @param units (\code{character}) The units for the 'width' and 'height' values. Valid 
#' only for bitmap formats, such as PNG and JPEG. The possible values are: pixels (default), inches.
#' @param height (\code{numeric}) The height of the exported image. Valid only for bitmap 
#' formats, such as PNG and JPEG. 
#' @param width (\code{numeric}) The width of the exported image. Valid only for bitmap 
#' formats, such as PNG and JPEG. 
#' @param zoom (\code{numeric}) The zoom value to proportionally scale the image. The default 
#' value is 100.0. Valid only for bitmap formats, such as PNG and JPEG
#' @param base.url cyrest base url for communicating with cytoscape
#' @return server response
#' @examples
#' \donttest{
#' exportImage('/fullpath/myNetwork','PDF')
#' }
#' @export
exportImage<-function(filename=NULL, type=NULL, resolution=NULL, units=NULL, height=NULL, 
                      width=NULL, zoom=NULL, base.url=.defaultBaseUrl){
    cmd.string <- 'view export' # minimum required command
    if(!is.null(filename))
        cmd.string <- paste0(cmd.string,' OutputFile="',filename,'"')
    if(!is.null(type))
        cmd.string <- paste0(cmd.string,' options="',type,'"')
    if(!is.null(resolution))
        cmd.string <- paste0(cmd.string,' Resolution="',resolution,'"')
    if(!is.null(units))
        cmd.string <- paste0(cmd.string,' Units="',units,'"')
    if(!is.null(height))
        cmd.string <- paste0(cmd.string,' Height="',height,'"')
    if(!is.null(width))
        cmd.string <- paste0(cmd.string,' Width="',width,'"')
    if(!is.null(zoom))
        cmd.string <- paste0(cmd.string,' Zoom="',zoom,'"')
    
    commandsPOST(cmd.string)
}