require 'spec_helper'

describe 'dojo' do
  subject { Dojo.new }

  describe '#discount' do

    context '20% off' do
      let(:func) { ->(x) { x.to_f * 0.8 } }

      it { expect(subject.discount(20, func)).to eq(16) }
      it { expect(subject.discount(300, func)).to eq(240) }
      it { expect(subject.discount(1000, func)).to eq(800) }
    end

    context 'flat' do
      let(:func) { ->(x) { [x - 100, 0].max } }

      it { expect(subject.discount(20, func)).to eq(0) }
      it { expect(subject.discount(300, func)).to eq(200) }
      it { expect(subject.discount(1000, func)).to eq(900) }
    end
  end

  describe '#stats' do
    let(:total) { subject.stats[:raw].inject(&:+) }
    let(:sum)   { subject.stats[:groups].inject([]) { |s, e| s + [e.last[:avg]] }.inject(&:+) }

    it { expect(total).to eq(100) }
    it { expect(sum).to eq(10) }
    it { expect(subject.stats[:raw].size).to eq(subject.stats[:groups].size) }
  end

  describe '#hire' do
    it "validation in code block" do
      expect {
        subject.hire("Bob") do |team|
          team.size < 5
        end
      }.to change { subject.team.size }.by(1)

      expect {
        subject.hire("Mary") do |team|
          team.size < 2
        end
      }.not_to change { subject.team.size }

      expect {
        subject.hire("Mary") do |team|
          team.size < 5
        end
      }.to change { subject.team.size }.by(1)

      expect {
        subject.hire("Vicky")
      }.to change { subject.team.size }.by(1)
    end

    it "dynamic parameters" do
      expect {
        subject.hire("Mary", "Bob", "Vicky") do |team|
          team.size < 5
        end
      }.to change { subject.team.size }.by(3)
    end
  end

  describe "module include and extend" do
    module Foo
      def growth
        puts "growth"
      end
    end

    it "#to_current_instance" do
      expect {
        subject.to_current_instance(Foo)
      }.to change { subject.respond_to?(:growth) }.to(true)
      expect(Dojo.new.respond_to?(:growth)).to eq(false)
    end

    it "#to_klass" do
      expect {
        subject.to_klass(Foo)
      }.to change { Dojo.respond_to?(:growth) }.to(true)
      expect(Dojo.new.respond_to?(:growth)).to eq(false)
      expect(subject.respond_to?(:growth)).to eq(false)
    end

    it "#to_all_instance" do
      expect {
        subject.to_all_instance(Foo)
      }.to change { Dojo.new.respond_to?(:growth) }.to(true)
      expect(subject.respond_to?(:growth)).to eq(true)
    end
  end

  describe ".extend_number!" do

    describe "use instance_eval" do
      before { expect(Fixnum).to receive(:class_eval) }
      it { Dojo.extend_number! }
    end

    before { Dojo.extend_number! }
    it { expect(1[2, 10]).to eq(1024) }
    it { expect(2[2, 10]).to eq(2048) }
    it { expect(3[2, 10]).to eq(3072) }
    it { expect(1[10, 2]).to eq(100) }
    it { expect(2[10, 2]).to eq(200) }
    it { expect(3[10, 2]).to eq(300) }
    it { expect(10[1, 10]).to eq(10) }
    it { expect(20[1, 10]).to eq(20) }
  end
end
