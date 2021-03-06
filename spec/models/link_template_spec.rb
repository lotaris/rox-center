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
require 'spec_helper'

describe LinkTemplate, rox: { tags: :unit } do

  describe "#to_client_hash" do

    it "should return a hash with the id, name and contents", rox: { key: '726e6f056c1e' } do
      template = create :link_template
      expect(template.to_client_hash).to eq({ id: template.id, name: template.name, contents: template.contents })
    end
  end

  describe "validations" do
    it(nil, rox: { key: '2ca03a223a08' }){ should validate_presence_of(:name) }
    it(nil, rox: { key: 'f3cc163d43d6' }){ should ensure_length_of(:name).is_at_most(50) }
    it(nil, rox: { key: '80c791e117ec' }){ should validate_presence_of(:contents) }
    it(nil, rox: { key: '61b345142b94' }){ should ensure_length_of(:contents).is_at_most(255) }

    describe "with an existing template" do
      let!(:link_template){ create :link_template }
      it(nil, rox: { key: 'c200ab4049f0' }){ should validate_uniqueness_of(:name).case_insensitive }
    end
  end

  describe "database table" do
    it(nil, rox: { key: 'ced833afe0c1' }){ should have_db_column(:id).of_type(:integer).with_options(null: false) }
    it(nil, rox: { key: '6c21c13f5cc7' }){ should have_db_column(:name).of_type(:string).with_options(null: false, limit: 50) }
    it(nil, rox: { key: '98f12458684c' }){ should have_db_column(:contents).of_type(:string).with_options(null: false, limit: 255) }
    it(nil, rox: { key: 'babb8d1ccdbe' }){ should have_db_column(:created_at).of_type(:datetime).with_options(null: false) }
    it(nil, rox: { key: 'e192da04813e' }){ should have_db_column(:updated_at).of_type(:datetime).with_options(null: false) }
    it(nil, rox: { key: 'b5563ff30798' }){ should have_db_index(:name).unique(true) }
  end
end
