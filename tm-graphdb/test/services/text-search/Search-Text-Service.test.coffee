Search_Text_Service = require './../../../src/services/text-search/Search-Text-Service'

describe '| services | text-search | Search-Text-Service', ->

  search_Text = null

  before (done)->
    search_Text = new Search_Text_Service()
    done()

  it 'folder_Search_Data', ()->
    search_Text.folder_Search_Data().assert_Folder_Exists()

  it 'search_Mappings', (done)->
    @timeout 10000
    search_Text.search_Mappings (data)->
      data.assert_Is_Object()
      done()

  it 'tag_Mappings', (done)->
    search_Text.tag_Mappings (data)->
      data.assert_Is_Object()
      done()

  it 'word_Data', (done)->
    search_Text.word_Data 'injection', (results)->
      results.keys().assert_Not_Empty()
      done()

  it 'word_Score', (done)->
    @.timeout 5000
    search_Text.word_Score 'injection', (results)->
    #search_Text.word_Score 'wcf 3.5', (results)->
      results.assert_Not_Empty()
      result = results.first()
      result.id.assert_Contains 'article-'
      result.score.assert_Is_Number()
      result.why.keys().assert_Not_Empty()
      done()

  it 'words_Score', (done)->
    search_Text.words_Score 'sQL   injection', (results)->
    #search_Text.words_Score 'wcf 3.5', (results)->
      results.assert_Not_Empty()
      done()

  it 'words_List ', (done)->
    search_Text.words_List (words)->
      words.assert_Bigger_Than 100
      "there are #{words.size()} unique words".log()
      done()

  it 'top 100 words', (done)->
    @.timeout 10000
    max = 100 #change to -1 to see data of all
    all_Data = []
    skip_Words = ['the','to','that','a', 'and', 'is', 'of', 'for', 'in','your','use','are','how','if','all'
                  'or','you','an','be','this','not','what','as','it','by','on','when','can','from','with','='
                  'each','add','may','will','have','more','sure']
    search_Text.search_Mappings (mappings)->
      search_Text.words_List (words)->
        #"Unique word count: #{words.size()}".log()
        for word in words.take(max)
          if skip_Words.not_Contains word
            search_Text.word_Score word, (result)->
              score = (item.score for item in result).reduce (previous, next)-> previous+next
              data = { word: word, articles: result.size(), score: score }
              all_Data.push data

        #uncomment to see stats
        #log '\n**** top100_By_Score ***\n'

        #results_By_Score    = all_Data.sort (a,b)-> a.score - b.score
        #results_By_Score.reverse()
        #top100_By_Score    = results_By_Score.slice(0,100)
        #log (item.word for item in top100_By_Score).join(', ')

        #log top100_By_Score
        #log '\n**** top100_By_Article ***\n'

        #results_By_Articles = all_Data.sort (a,b)-> a.articles - b.articles
        #results_By_Articles.reverse()
        #top100_By_Articles = results_By_Articles.slice(0,100)
        #log top100_By_Articles
        #log (item.word for item in top100_By_Articles).join(', ')

        done()

  #it 'tags_List ', (done)->
  #  search_Text.tags_List (tags)->
  #    #log tags
  #    #words.assert_Bigger_Than 100
  #    "there are #{tags.size()} unique tags".log()
  #    done()