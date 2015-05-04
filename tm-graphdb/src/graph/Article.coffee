Import_Service   = require '../services/data/Import-Service'

loaded_Raw_Articles_Html      = null

class Article

  constructor: (importService)->
    @.importService  = importService || new Import_Service(name:'tm-uno')

  folder_Articles_Html: ()=>
    __dirname.path_Combine "../../.tmCache/Lib_UNO-json/Articles_Html"

  article_Id_To_Guid: (article_Id, callback)=>
    @.importService.graph_Find.get_Subject_Data article_Id, (article_Data)=>
      callback article_Data?.guid

  html: (article_id,callback)=>
    @.article_Id_To_Guid article_id, (guid)=>
      #console.log "getting html for:" + article_id
      if(guid)
        json_File = @.folder_Articles_Html().path_Combine guid + ".json"
        if json_File.file_Exists()
          return callback json_File.load_Json()?.html

      callback null

  #raw_Articles_Html: (callback)=>
  #  if loaded_Raw_Articles_Html
  #    return callback loaded_Raw_Articles_Html
  #
  #  key = @.folder_Search_Data().path_Combine 'raw_articles_html.json'

  #  if key.file_Exists()
  #    articles_Data  = key.load_Json()
  #    loaded_Raw_Articles_Html = {}
  #    for article_Data in articles_Data
  #      loaded_Raw_Articles_Html[article_Data.id] = article_Data
  #    return callback loaded_Raw_Articles_Html
  #  callback {}

module.exports = Article