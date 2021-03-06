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
class TestResult < ActiveRecord::Base
  include Tableling::Model

  belongs_to :test_info
  belongs_to :runner, class_name: 'User'
  belongs_to :test_run
  belongs_to :project_version
  belongs_to :category
  belongs_to :previous_category, class_name: 'Category'

  strip_attributes
  validates :passed, inclusion: [ true, false ]
  validates :duration, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :message, length: { maximum: 65535, tokenizer: lambda{ |s| s.bytes.to_a } } # byte length
  validates :active, inclusion: [ true, false ]
  validates :run_at, presence: true
  validates :runner, presence: true
  validates :test_info, presence: true
  validates :test_run, presence: true
  validates :project_version, presence: true

  tableling do

    default_view do

      field :id
      field :duration
      field :passed
      field :run_at, as: :runAt, includes: :test_run

      field :runner, includes: :runner do
        order{ |q,d| q.joins(:runner).order("users.name #{d}") }
      end

      field :version, includes: :project_version do
        order{ |q,d| q.joins(:project_version).order("project_versions.name #{d}") }
      end

      quick_search do |query,term|
        term = "%#{term.downcase}%"
        query.joins(:runner).joins(:project_version).where('LOWER(project_versions.name) LIKE ? OR LOWER(users.name) LIKE ?', term, term)
      end

      serialize_response do |res|
        TestResultsRepresenter.new OpenStruct.new(res)
      end
    end
  end

  def passed?
    passed
  end

  def to_client_hash options = {}
    { id: id, passed: passed, active: active, duration: duration }.tap do |h|

      h[:version] = project_version.name if project_version.present? and options[:type] != :chart
      h[:message] = message if message.present? and ![ :chart, :test ].include?(options[:type])

      if [ :chart, :test ].include?(options[:type])
        h[:run_at] = run_at.to_ms
      end

      if options[:type] == :test
        h[:runner] = runner.to_client_hash
        h[:test_run_id] = test_run_id
      end

      if options[:type] == :details
        h[:test_run_id] = test_run_id
      end

      if options[:type] == :test_run
        h[:test] = test_info.to_client_hash options
      end
    end
  end
end
