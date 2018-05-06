# Activate and configure extensions
# https://middlemanapp.com/advanced/configuration/#configuring-extensions
activate :dotenv, env: '.env'

activate :autoprefixer do |prefix|
  prefix.browsers = "last 2 versions"
end

activate :livereload

activate :contentful do |f|
  f.access_token = ENV['ACCESS_TOKEN']
  f.space = { catBlog: ENV['SPACE_ID']}
  f.rebuild_on_webhook = true
  f.cda_query     = { content_type: 'catPage', include: 1 }
  f.content_types = {catPage: 'catPage'}
end

# Prismic Settings
api = Prismic.api('https://prismiccmsparty.prismic.io/api')

response = api.query(Prismic::Predicates.at("document.type", "beardpage"))
prismicdocuments = response.results

page "/beard/index.html", locals: {documents: prismicdocuments}

# Layouts
# https://middlemanapp.com/basics/layouts/

# Per-page layout changes
page '/*.xml', layout: false
page '/*.json', layout: false
page '/*.txt', layout: false

# With alternative layout
# page '/path/to/file.html', layout: 'other_layout'

# Proxy pages
# https://middlemanapp.com/advanced/dynamic-pages/

data.catBlog.catPage.each do |page|
  proxy "/cat/#{page[1][:slug]}.html", "/template/template.html", :ignore => true, :locals => {
    :title => page[1][:title],
    :subheading => page[1][:subheading],
    :imgSrc => page[1][:main_image][:url], 
    :markdown => page[1][:text]
  }
end

prismicdocuments.each do |page|
  proxy "/beard/#{page['beardpage.slug'].as_text()}.html", "/template/template.html", :ignore => true,
  :locals => {
    :title => page['beardpage.title'].as_text(),
    :subheading => page['beardpage.subheading'].as_text(),
    :imgSrc => page['beardpage.mainimage'].url,
    :text => page['beardpage.text'].as_html(nil).html_safe
  }
end


# proxy(
#   '/this-page-has-no-template.html',
#   '/template-file.html',
#   locals: {
#     which_fake_page: 'Rendering a fake page with a local variable'
#   },
# )

# Helpers
# Methods defined in the helpers block are available in templates
# https://middlemanapp.com/basics/helper-methods/

# helpers do
#   def some_helper
#     'Helping'
#   end
# end

# Build-specific configuration
# https://middlemanapp.com/advanced/configuration/#environment-specific-settings

# configure :build do
#   activate :minify_css
#   activate :minify_javascript
# end
