require_relative '../lib/treat'

describe Treat::Entities::Phrase do

  describe "Processors" do

    describe "#tokenize" do

      it "splits a phrase/sentence into tokens and adds them as children of the phrase" do
        Treat::Languages::English::Processors[:tokenizers].each do |t|
          @phrase = Treat::Entities::Phrase.new('a phrase to tokenize')
          @phrase.tokenize(t)
          @phrase.children.should eql @phrase.tokens
          @phrase.tokens.map { |t| t.to_s }.should
          eql ['A', 'sentence', 'to', 'tokenize']
        end
      end

    end

    describe "#parse" do

      it "parses a phrase/sentence into its syntax tree, " +
      "adding nested phrases and tokens as children of the phrase/sentence" do
        Treat::Languages::English::Processors[:parsers].each do |p|
          next # if p == :enju # slow?
          @sentence = Treat::Entities::
          Sentence.new('A sentence to tokenize.')
          @sentence.parse(p)
          @sentence.phrases.map { |t| t.to_s }.should
          eql ["A sentence to tokenize.",
            "A sentence to tokenize.",
            "A sentence", "to tokenize",
          "tokenize"]
        end
      end

    end

  end

  describe "Lexicalizers" do

    before do
      @taggers = Treat::Languages::English::Lexicalizers[:tag]
    end

    describe "#tag" do

      context "when called on an untokenized phrase" do
        it "returns the tag 'P'" do
          @taggers.each do |t|
            p = 'a phrase'
            p.tag(t)
            p.tag(t).should eql 'P'
          end
        end
      end

      context "when called on an untokenized sentence" do
        it "returns the tag 'S'" do
          @taggers.each do |t|
            s = 'This is a sentence.'
            s.tag(t)
            s.tag.should eql 'S'
          end
        end
      end

      context "when called a tokenized phrase" do
        it "returns the tag 'P' and tags all the phrase's tokens" do
          @taggers.each do |t|
            p = 'a phrase'.to_entity
            p.tokenize
            p.tag(t).should eql 'P'
            p.tokens.map { |t| t.tag }.should
            eql ["DT", "NN"]
          end
        end
      end

      context "when called on a tokenized sentence" do
        it "returns the tag 'S' and tags all the sentence's tokens" do
          @taggers.each do |t|
            s = 'This is a sentence.'.to_entity
            s.tokenize
            s.tag(t).should eql 'S'
            s.tokens.map { |t| t.tag }.should
            eql ["DT", "VBZ", "DT", "NN", "."]
          end
        end
      end

    end

  end

end
