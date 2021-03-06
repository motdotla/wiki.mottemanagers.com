require 'rubygems'
require 'sinatra'
require 'couchrest'
require 'haml'
require 'maruku'

class WeakyApp < Sinatra::Application
  
  SERVER = CouchRest.new
  DB = SERVER.database!('mottemanagers_wiki')


  class Item < CouchRest::ExtendedDocument
    use_database DB
  
    property :name
    property :body
    view_by :name

    WIKI_LINK_REGEX = /\[\[[A-Za-z0-9_\- ]+\]\]/
    ESCAPE_FOR_MARUKU = /[\[\]]/

    def escape(markdown)
      markdown.gsub(ESCAPE_FOR_MARUKU) { |s| '\\' + s }
    end

    def linkify(html)
      html.gsub(WIKI_LINK_REGEX) do |name_with_brackets|
        name = name_with_brackets[2..-3]
        items = Item.by_name(:key => name)
        cls = items.size == 0 && 'missing' || ''
        "<a href=\"/#{ name }\" class=\"#{ cls }\">#{ name }</a>"
      end
    end

    def body_html
      linkify(Maruku.new(escape(body)).to_html)
    end

    def new_url
      '/new/' + name
    end

    def url
      '/' + name
    end

    def id_url(rev = nil)
      "/id/#{id}" + (rev ? "/#{rev}" : "")
    end

    def revs_url
      "/revs/#{id}"
    end

    def edit_url
      '/edit/' + id
    end

    def delete_url
      id && '/delete/' + id
    end
  end

  # # helpers
  # def id_url(id, rev=nil)
  #   "/id/#{id}" + (rev ? "/#{rev}" : "")
  # end

  get '/stylesheet.css' do
    header 'Content-Type' => 'text/css; charset=utf-8'
    sass :stylesheet
  end

  get '/' do
    redirect '/home'
  end

  get '/new/:name' do
    @item = Item.new(:name => params[:name])
    @action = '/save'
    haml :edit
  end

  post '/save' do
    item = Item.new(:name => params[:name], :body => params[:body])
    item.save
    redirect item.url
  end

  get '/:name' do
    items = Item.by_name(:key => params[:name])
    if items.size == 1 then
      @item = items.first
      haml :show
    elsif items.size == 0 then
      @item = Item.new(:name => params[:name])
      redirect @item.new_url
    else
      @items = items
      @title = "disambiguation"
      haml :disambiguation
    end
  end

  get '/id/:id' do
    @item = Item.get(params[:id])
    haml :show
  end

  # get '/id/:id/:rev' do
  #   # @item = Item.get(params[:id], params[:rev]) # latest couchrest doesn't support passing in a revision param. the paramify_url method ignores it
  #   @item = CouchRest.get("#{DB.server.uri}/#{DB.name}/#{params[:id]}?rev=#{params[:rev]}")
  #   haml :show
  # end
  # 
  # get '/revs/:id' do
  #   # @item = Item.get(params[:id])
  #   @item = CouchRest.get("#{DB.server.uri}/#{DB.name}/#{params[:id]}?revs=true")
  #   haml :revisions
  # end

  get '/edit/:id' do
    @item = Item.get(params[:id])
    @action = @item.id_url
    haml :edit
  end

  post '/id/:id' do
    item = Item.get(params[:id])
    item.name = params[:name]
    item.body = params[:body]
    item.save
    redirect item.url
  end

  post '/delete/:id' do
    item = Item.get(params[:id])
    url = item.url
    item.destroy
    redirect url
  end
end
