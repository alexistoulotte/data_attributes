class Article < Content

  extend ActiveModel::Naming

  attr_accessor :category, :created_at, :published_on, :title

  def published=(value)
    @published = value
  end

  private

  def published
    @published
  end

end
