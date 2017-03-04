require 'spec_helper'

describe DataAttributes::View do

  let(:view) { View.new }

  describe '#data_attribute_value' do

    it 'raise an error if given object is not supported' do
      expect {
        view.data_attribute_value(Object.new)
      }.to raise_error("Can't convert object of class Object in data attributes")
    end

    context 'with string' do

      it 'returns given value' do
        expect(view.data_attribute_value('hello world')).to eq('hello world')
      end

      it 'accepts :prefix_strings option' do
        expect(view.data_attribute_value('hello world', prefix_strings: true)).to eq('string:hello world')
        expect(view.data_attribute_value('hello world', prefix_strings: false)).to eq('hello world')
      end

    end

    context 'with symbol' do

      it 'returns given value' do
        expect(view.data_attribute_value(:hello)).to eq('hello')
      end

      it 'accepts :prefix_strings option' do
        expect(view.data_attribute_value(:hello, prefix_strings: true)).to eq('string:hello')
        expect(view.data_attribute_value(:hello, prefix_strings: false)).to eq('hello')
      end

    end

    context 'with integer' do

      it 'returns given value' do
        expect(view.data_attribute_value(42)).to eq(42)
      end

    end

    context 'with float' do

      it 'returns given value' do
        expect(view.data_attribute_value(42.28)).to eq(42.28)
      end

    end

    context 'with nil' do

      it 'returns nil' do
        expect(view.data_attribute_value(nil)).to be(nil)
      end

    end

    context 'with Time' do

      it 'returns time as integer' do
        expect(view.data_attribute_value(Time.new(2017, 2, 10, 4, 1, 2))).to eq(1486659662)
      end

    end

    context 'with true' do

      it 'returns "true"' do
        expect(view.data_attribute_value(true)).to eq('true')
      end

      it 'accepts :raw option' do
        expect(view.data_attribute_value(true, raw: true)).to eq(true)
      end

    end

    context 'with false' do

      it 'returns "false"' do
        expect(view.data_attribute_value(false)).to eq('false')
      end

      it 'accepts :raw option' do
        expect(view.data_attribute_value(false, raw: true)).to eq(false)
      end

    end

    context 'with array' do

      it 'returns array as JSON' do
        expect(view.data_attribute_value([42, :bam, true, Time.new(2017, 2, 10, 4, 1, 2)])).to eq('[42,"bam",true,1486659662]')
      end

      it 'accepts :prefix_strings option' do
        expect(view.data_attribute_value([42, :bam, true, Time.new(2017, 2, 10, 4, 1, 2)], prefix_strings: true)).to eq('[42,"string:bam",true,1486659662]')
      end

      it 'is correct with arrays of arrays' do
        expect(view.data_attribute_value([42, [:bam, true]])).to eq('[42,["bam",true]]')
      end

      it 'is correct with arrays of hashes' do
        expect(view.data_attribute_value([44, { '_category_id?' => 28 }])).to eq('[44,{"categoryId":28}]')
      end

    end

    context 'with hash' do

      it 'returns hash as JSON' do
        expect(view.data_attribute_value({ id: 42, 'message' => :bam, date: Time.new(2017, 2, 10, 4, 1, 2), valid: true })).to eq('{"id":42,"message":"bam","date":1486659662,"valid":true}')
      end

      it 'accepts :prefix_strings option' do
        expect(view.data_attribute_value({ id: 42, 'message' => :bam, date: Time.new(2017, 2, 10, 4, 1, 2), valid: true }, prefix_strings: true)).to eq('{"id":42,"message":"string:bam","date":1486659662,"valid":true}')
      end

      it 'converts keys correctly' do
        expect(view.data_attribute_value({ '_category_id?' => 28 })).to eq('{"categoryId":28}')
      end

    end

    context 'with a data attributes model' do

      it 'returns hash of attributes as JSON' do
        Article.data_attribute(:id, :body)
        article = Article.new
        article.body = 'This is the body'
        article.id = 28
        expect(view.data_attribute_value(article)).to eq('{"body":"This is the body","id":28}')
      end

      it 'accepts :prefix_strings option' do
        Article.data_attribute(:id, :body)
        article = Article.new
        article.body = 'This is the body'
        article.id = 28
        expect(view.data_attribute_value(article, prefix_strings: true)).to eq('{"body":"string:This is the body","id":28}')
      end

      it 'is correct with a nested data attributes object' do
        Article.data_attribute(:id, :body, :category)
        Category.data_attribute(:id, :title)

        category = Category.new
        category.id = 20
        category.title = 'Books'

        article = Article.new
        article.body = 'This is the body'
        article.category = category

        expect(view.data_attribute_value(article)).to eq('{"body":"This is the body","category":{"id":20,"title":"Books"},"id":null}')
      end

    end

  end

end
