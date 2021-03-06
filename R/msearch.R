#' @title Multi-search
#'
#' @description Performs multiple searches, defined in a file
#'
#' @export
#' @param x (character) A file path
#' @param raw (logical) Get raw JSON back or not.
#' @param asdf (logical) If `TRUE`, use [jsonlite::fromJSON()]
#' to parse JSON directly to a data.frame. If `FALSE` (Default), list 
#' output is given.
#' @param ... Curl args passed on to [httr::POST()]
#'
#' @details This function behaves similarly to [docs_bulk()] - 
#' performs searches based on queries defined in a file.
#' @seealso [Search_uri()] [Search()]
#' @examples \dontrun{
#' connect()
#' msearch1 <- system.file("examples", "msearch_eg1.json", package = "elastic")
#' readLines(msearch1)
#' msearch(msearch1)
#'
#' cat('{"index" : "shakespeare"}', file = "~/mysearch.json", sep = "\n")
#' cat('{"query" : {"match_all" : {}}, "from" : 0, "size" : 5}',  sep = "\n",
#'    file = "~/mysearch.json", append = TRUE)
#' msearch("~/mysearch.json")
#' }
msearch <- function(x, raw = FALSE, asdf = FALSE, ...) {
  if (!file.exists(x)) stop("file ", x, " does not exist", call. = FALSE)
  url <- paste0(make_url(es_get_auth()), '/_msearch')
  tt <- POST(url, make_up(), es_env$headers, ..., 
             body = upload_file(x, type = "application/json"), encode = "json")
  geterror(tt)
  res <- cont_utf8(tt)
  if (raw) res else jsonlite::fromJSON(res, asdf)
}
