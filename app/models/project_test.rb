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
class ProjectTest < ActiveRecord::Base
  include QuickValidation

  belongs_to :key, class_name: 'TestKey'
  belongs_to :project, counter_cache: :tests_count
  has_many :descriptions, class_name: 'TestDescription', foreign_key: 'test_id'

  validates :name, presence: true, length: { maximum: 255, allow_blank: true }
  validates :project, presence: true
  validates :key, presence: { unless: :quick_validation }
  validates :key_id, presence: true, uniqueness: { scope: :project_id, unless: :quick_validation }
end