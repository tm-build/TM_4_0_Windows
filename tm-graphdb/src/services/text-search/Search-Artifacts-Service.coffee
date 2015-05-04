Cache_Service  = null
Import_Service = null
Article        = null
crypto         = null
cheerio        = null
async          = null

checksum = (str, algorithm, encoding)->
    crypto.createHash(algorithm || 'md5')
           .update(str, 'utf8')
           .digest(encoding || 'hex')

class Search_Artifacts_Service

  dependencies: ->
    Import_Service  = require('./../../../src/services/data/Import-Service')
    Article         = require './../../../src/graph/Article'
    Cache_Service   = require('teammentor').Cache_Service
    crypto          = require('crypto')
    cheerio         = require 'cheerio'
    async           = require 'async'

  constructor: (options)->
    @.dependencies()
    @.options         = options || {}
    @.import_Service  = @.options.import_Service || new Import_Service(name:'tm-uno')
    @.article         = new Article(@.import_Service)
    @.cache           = new Cache_Service("article_cache")
    @.cache_Search    = new Cache_Service("search_cache")


  create_Tag_Mappings :(callback)=>
    @.import_Service.graph_Find.find_Tags (tags_Data)=>
      @.cache_Search.put 'tags_mappings.json', tags_Data
      callback tags_Data

module.exports = Search_Artifacts_Service