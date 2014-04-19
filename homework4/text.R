require(tm)        # corpus
require(SnowballC) 

get_text <- function(filename){
  text_source <- DirSource(
    # indicate directory
    directory = file.path(filename),
    encoding = "UTF-8",     # encoding
    pattern = "*.txt",      # filename pattern
    recursive = FALSE,      # visit subdirectories?
    ignore.case = FALSE)    # ignore case in pattern?
  
  text_corpus <- Corpus(
    text_source, 
    readerControl = list(
      reader = readPlain, # read as plain text
      language = "en"))   # language is english
  
  
  
  text_corpus <- tm_map(text_corpus, tolower)
  
  text_corpus <- tm_map(
    text_corpus, 
    removePunctuation,
    preserve_intra_word_dashes = TRUE)
  
  text_corpus <- tm_map(
    text_corpus, 
    removeWords, 
    stopwords("english"))
  
  # getStemLanguages()
  text_corpus <- tm_map(
    text_corpus, 
    stemDocument,
    lang = "porter") # try porter or english
  
  text_corpus <- tm_map(
    text_corpus, 
    stripWhitespace)
  
  # Remove specific words
  text_corpus <- tm_map(
    text_corpus, 
    removeWords, 
    c("will", "can", "get", "that", "let", 'longbourn', 'your', 
      'int', 'went', 'like', 'gui', 'know', 'sai', 'got', 'dont', 
      'didnt', 'said', 'jean'))
  
  # print(sotu_corpus[["sotu2013.txt"]][3])
  
  # Calculate Frequencies
  text_tdm <- TermDocumentMatrix(text_corpus)
  
  # Inspect Frequencies
  # print(sotu_tdm)
  # inspect(sotu_tdm[40:44,])
  # findFreqTerms(sotu_tdm, 20)
  # inspect(sotu_tdm[findFreqTerms(sotu_tdm, 20),])
  
  # Convert to term/frequency format
  text_matrix <- as.matrix(text_tdm)
  text_df <- data.frame(
    word = rownames(text_matrix), 
    # necessary to call rowSums if have more than 1 document
    screenplay = text_matrix[, c('screenplay.txt')],
    book = text_matrix[, c('book.txt')],
    #freq2 = text_matrix[, c('beyonce.txt')], 
    stringsAsFactors = FALSE) 
  
  melted <- melt(text_df, id.vars = c('word'), values = c('screenplay', 'book'))
  
  # Sort by frequency
  text_df <- melted[with(
    melted, 
    order(value, decreasing = TRUE)), ]
  
  # Do not need the row names anymore
  rownames(text_df) <- NULL
  
  # Check out final data frame
  # View(sotu_df)
  return(text_df)
}

text_p <- get_text('prideandprej')
text_n <- get_text('nocountry')
text_f <- get_text('fightclub')
