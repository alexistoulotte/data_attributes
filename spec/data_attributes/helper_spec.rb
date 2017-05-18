require 'spec_helper'

describe DataAttributes::Helper do

  let(:view) { ActionView::Base.new }

  before :each do
    Article.data_attribute(:id, :body, :category)
    Category.data_attribute(:id, :title)
  end

  let(:article) do
    Article.new.tap do |article|
      article.body = 'This is the body'
      article.id = 28
    end
  end

  let(:category) do
    Category.new.tap do |category|
      category.id = 20
      category.title = 'Books'
    end
  end

  describe '#content_tag_for_single_record' do

    it 'renders correct HTML' do
      expect(view.content_tag_for_single_record(:div, article, nil, {}) { 'Hey!' }).to eq('<div data-body="This is the body" data-id="28" class="article">Hey!</div>')
    end

    it 'is correct when :data option is given' do
      expect(view.content_tag_for_single_record(:div, article, nil, data: { foo: 'bar' }) { 'Hey!' }).to eq('<div data-foo="bar" data-body="This is the body" data-id="28" class="article">Hey!</div>')
    end

    it 'is correct when :data option is a DataAttributes::Model' do
      expect(view.content_tag_for_single_record(:div, article, nil, data: category) { 'Hey!' }).to eq('<div data-id="20" data-title="Books" data-body="This is the body" class="article">Hey!</div>')
    end

    it 'is correct when :data option contains a DataAttributes::Model' do
      expect(view.content_tag_for_single_record(:div, article, nil, data: { category: category }) { 'Hey!' }).to eq('<div data-category="{&quot;id&quot;:20,&quot;title&quot;:&quot;Books&quot;}" data-body="This is the body" data-id="28" class="article">Hey!</div>')
    end

  end

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

    context 'with a date' do

      it 'returns date formatted' do
        expect(view.data_attribute_value(Date.new(2017, 4, 27))).to eq('2017/04/27')
      end

    end

    context 'with a data attributes model' do

      it 'returns hash of attributes as JSON' do
        expect(view.data_attribute_value(article)).to eq('{"body":"This is the body","category":null,"id":28}')
      end

      it 'accepts :prefix_strings option' do
        expect(view.data_attribute_value(article, prefix_strings: true)).to eq('{"body":"string:This is the body","category":null,"id":28}')
      end

      it 'is correct with a nested data attributes object' do
        article.category = category
        expect(view.data_attribute_value(article)).to eq('{"body":"This is the body","category":{"id":20,"title":"Books"},"id":28}')
      end

    end

  end

end
