# Copyright (c) 2012-2014 Lotaris SA
#
# This file is part of ROX Center.
#
# ROX Center is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# ROX Center is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with ROX Center.  If not, see <http://www.gnu.org/licenses/>.
# encoding: UTF-8
require 'spec_helper'

describe TestResult, rox: { tags: :unit } do

  context "message byte length validation" do

    let(:one_byte_char){ "\u0061" }
    let(:two_byte_char){ "\u0233" }
    let(:three_byte_char){ "\u3086" }

    before :each do
      user = create :user
      key = create :key, user: user
      @run = create :run, runner: user
      @test = create :test, key: key, test_run: @run
    end

    it "should not allow more than 65535 one-byte characters", rox: { key: '5e28426e7f22' } do
      msg = one_byte_char * 65535
      expect(build_result(msg).valid?).to be(true)
      msg << one_byte_char
      expect(build_result(msg).valid?).to be(false)
    end

    it "should not allow more than 32767 two-byte characters", rox: { key: '5236fc0cb454' } do
      msg = two_byte_char * 32767
      expect(build_result(msg).valid?).to be(true)
      msg << two_byte_char
      expect(build_result(msg).valid?).to be(false)
    end

    it "should not allow more than 21845 three-byte characters", rox: { key: '24588d82defd' } do
      msg = three_byte_char * 21845
      expect(build_result(msg).valid?).to be(true)
      msg << three_byte_char
      expect(build_result(msg).valid?).to be(false)
    end

    def build_result message
      build :result, runner: @run.runner, test_info: @test, test_run: @run, message: message
    end
  end

  context "validations" do
    it(nil, rox: { key: 'ab57dcb4d8c3' }){ should allow_value(true, false).for(:passed) }
    it(nil, rox: { key: '9ba0a4f7cba9' }){ should_not allow_value(nil, 'abc', 123).for(:passed) }
    it(nil, rox: { key: 'a736baaeb6c5' }){ should validate_presence_of(:project_version) }
    it(nil, rox: { key: '07a3e2a83e69' }){ should validate_presence_of(:duration) }
    it(nil, rox: { key: '2c24629f7508' }){ should validate_numericality_of(:duration).only_integer }
    it(nil, rox: { key: 'e30d02a9bf0b' }){ should allow_value(0, 10000, 3600000).for(:duration) }
    it(nil, rox: { key: 'ad86f100aa50' }){ should_not allow_value(-1, -42, -66).for(:duration) }
    it(nil, rox: { key: '2acec8d868b3' }){ should ensure_length_of(:message).is_at_most(65535) }
    it(nil, rox: { key: 'eb74444c0250' }){ should validate_presence_of(:run_at) }
    it(nil, rox: { key: '512d38de3e73' }){ should validate_presence_of(:runner) }
    it(nil, rox: { key: 'ffa2bc12ab4a' }){ should validate_presence_of(:test_info) }
    it(nil, rox: { key: '437888444049' }){ should validate_presence_of(:test_run) }
    it(nil, rox: { key: '655398ed00bc' }){ should allow_value(true, false).for(:active) }
    it(nil, rox: { key: '3108c4643221' }){ should_not allow_value(nil, 'abc', 123).for(:active) }
  end

  context "associations" do
    it(nil, rox: { key: 'a0f0857cf4a2' }){ should belong_to(:runner).class_name('User') }
    it(nil, rox: { key: 'ecb3ec9ae70a' }){ should belong_to(:test_info) }
    it(nil, rox: { key: 'd6c73fc4ea8c' }){ should belong_to(:test_run) }
    it(nil, rox: { key: '98276100d0b6' }){ should belong_to(:category) }
    it(nil, rox: { key: 'ead8d81ff4aa' }){ should belong_to(:previous_category).class_name('Category') }
  end

  context "database table" do
    it(nil, rox: { key: '8deb8afbca16' }){ should have_db_column(:id).of_type(:integer).with_options(null: false) }
    it(nil, rox: { key: '099c43427c69' }){ should have_db_column(:passed).of_type(:boolean).with_options(null: false) }
    it(nil, rox: { key: '558aec64f22d' }){ should have_db_column(:duration).of_type(:integer).with_options(null: false) }
    it(nil, rox: { key: '516ef9ba84ea' }){ should have_db_column(:message).of_type(:text) }
    it(nil, rox: { key: 'e9f576c1cc45' }){ should have_db_column(:active).of_type(:boolean).with_options(null: false, default: true) }
    it(nil, rox: { key: '0ffbb1a73cb7' }){ should have_db_column(:new_test).of_type(:boolean).with_options(null: false, default: false) }
    it(nil, rox: { key: '9710cf05abe6' }){ should have_db_column(:previous_passed).of_type(:boolean).with_options(null: true) }
    it(nil, rox: { key: '8a0071498fd5' }){ should have_db_column(:previous_active).of_type(:boolean).with_options(null: true) }
    it(nil, rox: { key: 'f27560967967' }){ should have_db_column(:runner_id).of_type(:integer).with_options(null: false) }
    it(nil, rox: { key: '93d491c4e31f' }){ should have_db_column(:test_info_id).of_type(:integer).with_options(null: false) }
    it(nil, rox: { key: '556726a1c0cc' }){ should have_db_column(:test_run_id).of_type(:integer).with_options(null: false) }
    it(nil, rox: { key: 'c5fa090e339b' }){ should have_db_column(:project_version_id).of_type(:integer).with_options(null: false) }
    it(nil, rox: { key: '7c2f23a0d69f' }){ should have_db_column(:category_id).of_type(:integer).with_options(null: true) }
    it(nil, rox: { key: '256a05413800' }){ should have_db_column(:previous_category_id).of_type(:integer).with_options(null: true) }
    it(nil, rox: { key: '8e2d652a897e' }){ should have_db_column(:created_at).of_type(:datetime).with_options(null: false) }
    it(nil, rox: { key: '9383fe626ffc' }){ should have_db_column(:run_at).of_type(:datetime).with_options(null: false) }
    it(nil, rox: { key: 'b77b7a9a99db' }){ should have_db_index([ :test_run_id, :test_info_id ]).unique(true) }
  end
end
