require 'spec_helper'

describe DataAttributes::Model do

  describe '.data_attribute' do

    it 'adds given attributes to data attributes' do
      expect {
        Article.data_attribute(:id)
      }.to change { Article.data_attributes }.from([]).to([:id])
    end

    it 'removes doubloons' do
      Article.data_attribute(:id)
      expect {
        Article.data_attribute(:id)
      }.not_to change { Article.data_attributes }
      expect(Article.send(:__data_attributes)).to eq([:id])
    end

    it 'removes doubloons (if given as string)' do
      Article.data_attribute(:id)
      expect {
        Article.data_attribute('id')
      }.not_to change { Article.data_attributes }
      expect(Article.send(:__data_attributes)).to eq([:id])
    end

    it 'converts attributes to symbols' do
      Article.data_attribute('id')
      expect(Article.data_attributes).to eq([:id])
    end

    it 'accepts arrays' do
      Article.data_attribute(['id', ['category']], :body)
      expect(Article.data_attributes).to eq([:body, :category, :id])
    end

  end

  describe '.__data_attributes' do

    it 'is a private method' do
      expect(Article.respond_to?(:__data_attributes)).to be(false)
      expect(Article.respond_to?(:__data_attributes, true)).to be(true)
    end

    it 'is a private method even after a call to .data_attribute' do
      Article.data_attribute(:id)
      expect(Article.respond_to?(:__data_attributes)).to be(false)
      expect(Article.respond_to?(:__data_attributes, true)).to be(true)
    end

  end

  describe '.data_attributes' do

    it 'is an empty array by default' do
      expect(Article.data_attributes).to eq([])
    end

    it "can't be changed" do
      Article.data_attribute(:id)
      expect {
        Article.data_attributes.clear
      }.not_to change { Article.data_attribute }
    end

    it 'is correct with subclasses' do
      Content.data_attribute(:body, :id)
      expect(Content.data_attributes).to eq([:body, :id])
      expect(Article.data_attributes).to eq([:body, :id])

      Article.data_attribute(:title)
      expect(Content.data_attributes).to eq([:body, :id])
      expect(Article.data_attributes).to eq([:body, :id, :title])
    end

    it 'removes doubloons with subclasses' do
      Content.data_attribute(:body, :id)
      expect(Article.data_attributes).to eq([:body, :id])
      Article.data_attribute(:title, :id, :body)
      expect(Article.data_attributes).to eq([:body, :id, :title])
    end

    it 'is sorted' do
      Article.data_attribute(:id, :body)
      expect(Article.data_attributes).to eq([:body, :id])
    end

    it 'is sorted with subclasses' do
      Content.data_attribute(:bar, :foo)
      Article.data_attribute(:body)
      expect(Article.data_attributes).to eq([:bar, :body, :foo])
    end

  end

  describe '#data_attributes' do

    it 'returns an hash of instance data attributes' do
      Article.data_attribute(:id, :body)
      article = Article.new
      article.body = 'This is the body'
      article.id = 42
      expect(article.data_attributes).to eq({ body: 'This is the body', id: 42 })
    end

    it 'does not fail if method does not exist' do
      Article.data_attribute(:id, :foo)
      article = Article.new
      article.id = 42
      expect(article.data_attributes).to eq({ id: 42 })
    end

    it 'does not fail if method is private' do
      Article.data_attribute(:published)
      article = Article.new
      article.published = true
      expect(article.data_attributes).to eq({ published: true })
    end

  end

end
