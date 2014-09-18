# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "http://www.example.com"

SitemapGenerator::Sitemap.create do
  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically for you.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host
  #
  # Examples:
  #
  # Add '/articles'
  #
  #   add articles_path, :priority => 0.7, :changefreq => 'daily'
  #
  # Add all articles:
  #
  #   Article.find_each do |article|
  #     add article_path(article), :lastmod => article.updated_at
  #   end

  # TODO open lines for content pages when pages subsystem ready
  # exclude_from_content_pages = ["/"]

  add news_index_path
  #exclude_from_content_pages << news_index_path

  News.visibles.ordered.each do |news|
    add news_path(news.slug), changefreq: 'yearly', lastmod: news.updated_at
  end

  # ContentPage.visibles.each do |content_page|
  #   unless exclude_from_content_pages.include? content_page.page_path
  #     add content_page.page_path, { lastmod: content_page.updated_at,
  #                                   changefreq: 'monthly' }
  #   end
  # end
end
