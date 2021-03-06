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
class TestInfo < ActiveRecord::Base
  include Tableling::Model

  # Flags
  INACTIVE = 1

  attr_accessor :quick_validation

  belongs_to :author, class_name: "User"
  belongs_to :key, class_name: "TestKey"
  belongs_to :project, counter_cache: :tests_count
  belongs_to :category
  belongs_to :deprecation, class_name: "TestDeprecation"
  belongs_to :last_runner, class_name: "User"
  has_many :results, class_name: "TestResult"
  belongs_to :effective_result, class_name: "TestResult"
  has_many :custom_values, class_name: "TestValue"
  has_many :deprecations, class_name: "TestDeprecation"
  has_and_belongs_to_many :tags
  has_and_belongs_to_many :tickets

  strip_attributes
  validates :key, presence: { unless: :quick_validation }
  validates :key_id, presence: true, uniqueness: { scope: :project_id, unless: :quick_validation }
  validates :name, presence: true, length: { maximum: 255 }
  validates :author, presence: true
  validates :project, presence: true
  validates :passing, inclusion: [ true, false ]
  validates :last_run_at, presence: true
  validates :last_run_duration, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :active, inclusion: [ true, false ]

  def self.count_by_category
    standard.select('category_id, count(id) AS tests_count').group('category_id').includes(:category).to_a.collect{ |t| { category: t.category.try(:name), count: t.tests_count } }
  end

  def self.count_by_project
    standard.select('project_id, count(id) AS tests_count').group('project_id').includes(:project).to_a.collect{ |t| { project: t.project.name, count: t.tests_count } }
  end

  def self.count_by_author
    standard.select('author_id, count(id) AS tests_count').group('author_id').includes(:author).to_a.collect{ |t| { author: t.author, count: t.tests_count } }
  end

  tableling do

    default_view do

      field :name, includes: [ :tags, :tickets ]
      field :created_at, as: :createdAt
      field :last_run_at, as: :lastRunAt
      field :last_run_duration, as: :lastRunDuration
      field :passing, order: false
      field :active, order: false

      field :category, includes: :category do
        order{ |q,d| q.joins(:category).order("LOWER(categories.name) ASC") }
      end

      field :deprecated_at, includes: :deprecation do
        order{ |q,d| q.joins(:deprecation).order("test_deprecations.created_at #{d}") }
      end

      field :author, includes: :author do
        order{ |q,d| q.joins(:author).order("users.name #{d}") }
      end

      field :project, includes: :project do
        order{ |q,d| q.joins(:project).order("projects.name #{d}") }
      end

      field :key, includes: :key do
        order{ |q,d| q.joins(:key).order("test_keys.key #{d}") }
      end

      field :effective_result, includes: { effective_result: [ :project_version, :runner, { test_run: [ :runner ] } ] }, as: :effectiveResult

      quick_search do |query,term|
        term = "%#{term.downcase}%"
        query.joins(:key).joins(:author).joins(:project).where('LOWER(test_infos.name) LIKE ? OR LOWER(projects.name) LIKE ? OR LOWER(test_keys.key) LIKE ? OR LOWER(users.name) LIKE ?', term, term, term, term)
      end

      serialize_response do |res|
        TestInfosRepresenter.new OpenStruct.new(res)
      end
    end
  end

  def self.standard
    where 'deprecation_id IS NULL'
  end

  def self.outdated settings = nil
    standard.where 'last_run_at < ?', (settings || Settings.app).test_outdated_days.days.ago
  end

  def self.failing
    standard.where passing: false, active: true
  end

  def self.inactive
    standard.where active: false
  end

  def self.deprecated
    where 'deprecation_id IS NOT NULL'
  end

  def self.for_projects_and_keys keys_by_project
    conditions = ([ '(projects.api_id = ? AND test_keys.key IN (?))' ] * keys_by_project.length)
    values = keys_by_project.inject([]){ |memo,(k,v)| memo << k << v }
    where_args = values.unshift conditions.join(' OR ')
    joins(:project).joins(:key).where *where_args
  end

  def self.find_by_project_and_key project_and_key
    parts = project_and_key.split '-'
    return nil if parts.length != 2
    TestInfo.joins(:project).joins(:key).includes(:key).where(projects: { api_id: parts[0].to_s }, test_keys: { key: parts[1].to_s })
  end

  def self.find_by_project_and_key! project_and_key
    find_by_project_and_key(project_and_key).tap do |rel|
      raise ActiveRecord::RecordNotFound unless rel
    end
  end

  def breaker
    !new_record? && !passing ? effective_result.runner : nil
  end

  def to_param options = {}
    "#{project.try(:api_id)}-#{key.try(:key)}"
  end

  def deprecated?
    !!deprecation_id
  end

  def to_client_hash options = {}
    {
      key: key.key,
      name: name,
      project: project.to_client_hash(options),
      active: active,
      created_at: created_at.to_ms
    }.tap do |h|

      h[:category] = category.name if category.present?
      h[:values] = custom_values.inject({}){ |memo,v| memo[v.name] = v.contents; memo } if custom_values.any?
      h[:deprecated_at] = deprecation.created_at.to_ms if deprecation

      if options[:type] == :test_run
        h[:author] = author_id
        h[:tags] = tags.collect(&:id) if tags.any?
        h[:tickets] = tickets.collect(&:id) if tickets.any?
      else
        h[:author] = author.to_client_hash
        h[:tags] = tags.collect(&:name) if tags.any?
        h[:tickets] = tickets.collect(&:to_client_hash) if tickets.any?
      end
    end
  end
end
