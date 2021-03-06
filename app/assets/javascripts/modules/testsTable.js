// Copyright (c) 2012-2014 Lotaris SA
//
// This file is part of ROX Center.
//
// ROX Center is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// ROX Center is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with ROX Center.  If not, see <http://www.gnu.org/licenses/>.
App.autoModule('testsTable', function() {

  var NoTestRow = Marionette.ItemView.extend({

    tagName: 'tr',
    className: 'empty',
    template: function() {
      return _.template('<td colspan="7"><%- empty %></td>', { empty: I18n.t('jst.testsTable.empty') });
    }
  });

  var TestTooltip = Marionette.LayoutView.extend({

    template: 'testsTable/tooltip',

    regions: {
      avatar: '.runnerAvatar'
    },

    serializeData: function() {
      return {
        lastRunAt: Format.datetime.short(new Date(this.model.get('lastRunAt'))),
        lastRunDuration: Format.duration(this.model.get('lastRunDuration'), { shorten: 's' })
      };
    },

    onRender: function() {
      this.avatar.show(new App.views.UserAvatar({ model: this.model.embedded('v1:lastRunner'), size: 'small', link: false }));
    }
  });

  var TestRow = Marionette.LayoutView.extend({

    tagName: 'tr',
    template: 'testsTable/row',

    regions: {
      author: '.author'
    },

    ui: {
      name: '.name',
      project: '.project',
      createdAt: '.createdAt',
      key: '.key',
      action: '.action',
      statusLink: '.action a',
      statusIcon: '.action .glyphicon'
    },

    events: {
      'click': 'toggleSelected'
    },

    appEvents: {
      'test:selector': 'updateSelection',
      'test:selected': 'updateSelection',
      'test:deprecated': 'updateDeprecation'
    },

    initialize: function() {
      App.bindEvents(this);
    },

    onRender: function() {
      this.renderName();
      this.renderKey();
      this.renderProject();
      this.author.show(new App.views.UserAvatar({ model: this.model.embedded('v1:author'), size: 'small' }));
      this.ui.createdAt.text(Format.datetime.short(new Date(this.model.get('createdAt'))));
      this.renderStatus();
      this.updateSelection();
    },

    updateSelection: function() {
      this.$el.removeClass('success warning');
      if (App.currentTestSelector) {
        this.$el.addClass(App.currentTestSelector.isSelected(this.model) ? 'success' : 'warning');
      }
    },

    updateDeprecation: function(test, deprecated, time) {
      if (this.model.link('self').get('href') == test.link('self').get('href')) {
        this.model.setDeprecated(deprecated, time);
        this.renderKey();
        this.renderStatus();
      }
    },

    renderName: function() {
      this.truncateLink(this.model.link('alternate').get('href'), this.model.get('name'), 75, this.ui.name);
    },

    renderKey: function() {

      var el = $('<span />');
      if (this.model.isDeprecated()) {
        $('<del />').text(this.model.get('key')).appendTo(el);
      } else {
        el.text(this.model.get('key'));
      }

      this.ui.key.html(el);
      Clipboard.setup(el, this.model.link('bookmark').get('href'), { title: I18n.t('jst.testsTable.keyTooltip') });
    },

    renderProject: function() {
      var project = this.model.embedded('v1:project');
      this.truncateLink(project.link('alternate').get('href'), project.get('name'), 22, this.ui.project);
    },

    truncateLink: function(href, text, max, el) {

      var link = $('<a />').attr('href', href),
          truncatedText = Format.truncate(text, { max: max });

      link.text(truncatedText);

      el.html(link);

      if (truncatedText != text) {
        link.tooltip({
          title: text
        });
      }
    },

    isSelectionModeEnabled: function() {
      return !!(App.currentTestSelector);
    },

    toggleSelected: function(e) {
      if (!this.isSelectionModeEnabled()) {
        return;
      } else {
        e.preventDefault();
      }

      var selected = !App.currentTestSelector.isSelected(this.model);
      this.model.set({ selected: selected });
      App.trigger('test:selected', this.model, selected);
    },

    renderStatus: function() {

      var lastRun = this.model.embedded('v1:lastRun'),
          linkTarget = lastRun ? lastRun : this.model;
      this.ui.statusLink.attr('href', linkTarget.link('alternate').get('href'));

      this.ui.statusIcon.removeClass('glyphicon-thumbs-up glyphicon-thumbs-down');
      this.ui.statusIcon.addClass('glyphicon-' + (this.model.get('passing') ? 'thumbs-up' : 'thumbs-down'));

      this.ui.statusLink.removeClass('btn-default btn-warning btn-success btn-danger');
      if (this.model.isDeprecated()) {
        this.ui.statusLink.addClass('btn-default');
      } else if (!this.model.get('active')) {
        this.ui.statusLink.addClass('btn-warning');
      } else {
        this.ui.statusLink.addClass('btn-' + (this.model.get('passing') ? 'success' : 'danger'));
      }

      this.ui.statusLink.popover('destroy');
      this.ui.statusLink.popover({
        html: true,
        trigger: 'hover',
        title: this.tooltipTitle(),
        content: this.tooltipContents(),
        placement: 'auto right'
      });
    },

    tooltipTitle: function() {
      return $('<strong />').text(I18n.t('jst.testsTable.lastRun'));
    },

    tooltipContents: function() {
      return new TestTooltip({ model: this.model, el: $('<div />') }).render().$el;
    }
  });

  var TestsTableView = Tableling.Bootstrap.TableView.extend({

    template: 'testsTable/table',
    childView: TestRow,
    childViewContainer: 'tbody',
    emptyView: NoTestRow,

    ui: {
      actionHeader: 'th.action',
      table: 'table'
    },

    events: {
      'click thead .selectAll': 'selectAll'
    },

    appEvents: {
      'test:selector': 'setSelectionModeEnabled renderActionHeader',
      'test:selected': 'renderActionHeader'
    },

    initializeModule: function() {
      App.bindEvents(this);
      this.listenTo(this.vent, 'table:refreshed', this.renderActionHeader);
    },

    onRender: function() {
      this.renderActionHeader();
    },

    selectAll: function() {

      var select = !this.allTestsAreSelected();

      this.collection.forEach(function(test) {
        if (App.currentTestSelector.isSelected(test) != select) {
          test.set({ selected: select });
          App.trigger('test:selected', test, select);
        }
      }, this);
    },

    allTestsAreSelected: function() {
      return this.collection.every(function(test) {
        return App.currentTestSelector.isSelected(test);
      });
    },

    setSelectionModeEnabled: function(enabled) {
      this.$el[enabled ? 'addClass' : 'removeClass']('selectionMode');
      this.ui.table[enabled ? 'removeClass' : 'addClass']('table-striped');
    },

    isSelectionModeEnabled: function() {
      return !!(App.currentTestSelector);
    },

    renderActionHeader: function() {
      if (this.isSelectionModeEnabled()) {
        this.renderSelectAll();
      } else {
        this.ui.actionHeader.text(I18n.t('jst.models.test.status'));
      }
    },

    renderSelectAll: function() {

      var selected = this.allTestsAreSelected();

      var el = $('<span class="selectAll glyphicon" />');
      this.ui.actionHeader.html(el);
      el.addClass('glyphicon-' + (selected ? 'minus' : 'plus') + '-sign');
      el.tooltip({ title: I18n.t('jst.testSelector.' + (selected ? 'unselectAll' : 'selectAll')) });
    }
  });

  var TestsTable = App.views.TableWithAdvancedSearch.extend({

    advancedSearchTemplate: 'testsTable/search',

    ui: {
      projectsFilter: '.advancedSearch form .projects',
      tagsFilter: '.advancedSearch form .tags',
      ticketsFilter: '.advancedSearch form .tickets',
      categoriesFilter: '.advancedSearch form .categories',
      authorsFilter: '.advancedSearch form .authors',
      breakersFilter: '.advancedSearch form .breakers',
      statusFilter: '.advancedSearch form .status'
    },

    events: {
      'change .advancedSearch form .status': 'updateSearch',
      'change .advancedSearch form .projects': 'updateSearch',
      'change .advancedSearch form .tags': 'updateSearch',
      'change .advancedSearch form .tickets': 'updateSearch',
      'change .advancedSearch form .categories': 'updateSearch',
      'change .advancedSearch form .authors': 'updateSearch',
      'change .advancedSearch form .breakers': 'updateSearch'
    },

    tableView: TestsTableView,
    wrapSearchData: false,
    halEmbedded: 'item',

    config: {
      sort: [ 'createdAt desc' ],
      pageSize: 15
    },

    searchFilters: [
      { name: 'projects' },
      { name: 'tags' },
      { name: 'tickets' },
      {
        name: 'categories',
        blank: true,
        blankText: I18n.t('jst.testsTable.search.categories.blank')
      },
      {
        name: 'status',
        data: 'statuses',
        optionText: function(status) { return I18n.t('jst.testsTable.search.status.' + status); },
        sort: false
      },
      {
        name: 'authors',
        optionText: function(author) { return author.name; },
        optionValue: function(author) { return author.name; },
        sort: function(a, b) { return a.name.localeCompare(b.name); }
      },
      {
        name: 'breakers',
        optionText: function(breaker) { return breaker.name; },
        optionValue: function(breaker) { return breaker.name; },
        sort: function(a, b) { return a.name.localeCompare(b.name); }
      }
    ]
  });

  this.addAutoInitializer(function(options) {
    var res = new App.models.Tests({}, _.pick(options.config, 'halUrlTemplate'));
    options.region.show(new TestsTable(_.extend(options.config, { model: res })));
  });
});

