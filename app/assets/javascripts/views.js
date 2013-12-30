// Copyright (c) 2012-2013 Lotaris SA
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
App.module('views', function() {

  var FadeRegion = this.FadeRegion = Backbone.Marionette.Region.extend({

    open : function(view) {
      this.$el.hide();
      this.$el.html(view.el);
      this.$el.hide();
      async.nextTick(_.bind(function() {
        this.$el.fadeIn('normal', _.bind(function() {
          this.trigger('faded:in');
        }, this));
      }, this));
    }
  });

  var UserAvatar = this.UserAvatar = Backbone.Marionette.ItemView.extend({

    template : 'userAvatar',
    ui : {
      avatar : '.avatar',
      name : '.name'
    },

    initialize : function(options) {
      this.avatarSize = options.size;
      this.link = typeof(options.link) == 'undefined' || options.link;
      this.label = options.label !== false ? this.model.get('name') : undefined;
      this.tooltip = options.tooltip;
    },

    onRender : function() {

      this.$el.addClass(this.avatarSizeClass());
      this.renderAvatar();

      if (this.label) {
        this.renderLabel();
      } else {
        this.ui.name.remove();
      }

      if (this.tooltip) {
        this.ui.avatar.tooltip(_.isObject(this.tooltip) ? this.tooltip : { title: this.tooltip });
      }
    },

    renderLabel : function() {
      this.link ? this.ui.name.html($('<a />').attr('href', this.model.path()).text(this.label)) : this.ui.name.text(this.label);
    },

    renderAvatar : function() {
      var email = this.model.get('email') || 'example@lotaris.com';
      var img = $.gravatar(email, { size: this.avatarSizeValue(), secure: App.secure }).attr('alt', this.model.get('name'))
      this.ui.avatar.html(this.link ? $('<a />').attr('href', this.model.path()).append(img) : img);
    },

    avatarSizeValue : function() {
      if (this.avatarSize == 'small') {
        return 25;
      } else if (this.avatarSize == 'large') {
        return 40;
      } else {
        return 50;
      }
    },

    avatarSizeClass : function() {
      if (this.avatarSize == 'small') {
        return 'smallAvatar';
      } else if (this.avatarSize == 'large') {
        return 'mediumAvatar';
      } else {
        return 'largeAvatar';
      }
    }
  });

  var Table = this.Table = Tableling.Bootstrap.Table.extend({

    tableUi : {
      header : '.header'
    },

    initialize : function(options) {

      Tableling.Bootstrap.Table.prototype.initialize.call(this, options);

      this.completeConfig('ui', 'table');
      this.listenTo(this.vent, 'table:refreshed', _.bind(this.showLoading, this, false));

      if (this.collection) {
        this.collection.on('destroy', this.refresh, this);
      }
    },

    refresh : function() {
      var args = Array.prototype.slice.call(arguments);
      this.showLoading(true).load(_.bind(function() {
        Tableling.Bootstrap.Table.prototype.refresh.apply(this, args);
      }, this));
    },

    completeConfig : function(config, source) {

      if (!this[config]) {
        this[config] = {};
      }

      var sourceName = source + config.charAt(0).toUpperCase() + config.slice(1);
      if (!this[sourceName]) {
        throw new Error('Expected table to have "' + sourceName + '" property');
      }

      _.each(this[sourceName], function(selector, key) {
        if (!this[config][key]) {
          this[config][key] = selector;
        }
      }, this);
    },

    showLoading : function(loading) {
      if (loading) {
        return Status.loading().appendTo(this.ui.header);
      } else {
        return this.ui.header.find('.status').remove();
      }
    }
  });

  var TableWithAdvancedSearch = this.TableWithAdvancedSearch = Table.extend({

    template : 'tableWithAdvancedSearch',

    advancedSearchUi : {
      advancedSearch : '.advancedSearch',
      advancedSearchButton : '.advancedSearchControls button',
      clearButton : '.advancedSearch .clear'
    },

    advancedSearchEvents : {
      'submit .advancedSearch form' : 'refresh',
      'click .advancedSearch .clear' : 'clearAdvancedSearch',
      'click .advancedSearchControls button' : 'toggleAdvancedSearch'
    },

    searchFilters : [],

    initialize : function(options) {

      options.autoUpdate = false;
      Table.prototype.initialize.call(this, options);

      this.completeConfig('ui', 'advancedSearch');
      this.completeConfig('events', 'advancedSearch');

      this.searchData = options && options.search && options.search.data ? options.search.data : {};
      this.currentSearch = options && options.search && options.search.current ? options.search.current : {};

      this.listenTo(this, 'item:rendered', this.launch);
      this.listenTo(this.vent, 'table:update', this.updateClearButton);
    },

    serializeData : function() {
      var data = Tableling.Bootstrap.Table.prototype.serializeData.apply(this, Array.prototype.slice.call(arguments))
      data.advancedSearchTemplate = this.advancedSearchTemplate;
      return data;
    },

    onRender : function() {

      _.each(this.searchFilters, this.fillFilter, this);

      if (!_.isEmpty(this.currentSearch)) {
        this.delayLaunch = true;
        this.setupSelect2();
        this.udpateAdvancedSearchButton(true);
      } else {
        this.ui.advancedSearch.hide();
        this.udpateAdvancedSearchButton(false);
      }
    },

    launch : function() {
      if (!this.delayLaunch) {
        this.update();
      }
    },

    clearAdvancedSearch : function() {

      // Do not do anything if no search filter is set.
      if (_.isEmpty(this.requestSearchData())) {
        return;
      }

      _.each(this.searchFilters, function(filter) {
        this.getFilterElement(filter).select2('data', null);
      }, this);

      this.updateSearch();
    },

    updateSearch : function() {
      this.update({ page : 1 });
    },

    updateClearButton : function() {
      this.ui.clearButton.attr('disabled', _.isEmpty(this.requestSearchData()));
    },

    fillFilter : function(filter) {

      var el = this.getFilterElement(filter);

      var data = this.searchData[filter.data || filter.name];
      if (!data) {
        return el.hide();
      }

      if (filter.sort !== false) {
        data = data.sort(filter.sort);
      }

      if (filter.blank && filter.blankText) {
        el.append($('<option />').val(' ').text(filter.blankText));
      }

      _.each(data, function(val) {
        el.append($('<option />').val(filter.optionValue ? filter.optionValue(val) : val).text(filter.optionText ? filter.optionText(val) : val));
      });
    },

    toggleAdvancedSearch : function() {
      var visible = this.ui.advancedSearch.is(':visible');
      this.ui.advancedSearch[visible ? 'hide' : 'show']();
      this.udpateAdvancedSearchButton(!visible);
      this.setupSelect2();
      if (visible) {
        this.clearAdvancedSearch();
      }
    },

    udpateAdvancedSearchButton : function(visible) {
      this.ui.advancedSearchButton.text(I18n.t('jst.tableWithAdvancedSearch.search.' + (visible ? 'hide' : 'show')));
    },

    setupSelect2 : function() {
      if (this.select2) {
        return;
      }
      this.select2 = true;

      async.parallel(_.map(this.searchFilters, function(filter) {
        return _.bind(function(callback) {
          this.setupFilter(filter, callback);
        }, this);
      }, this), _.bind(function() {
        if (this.delayLaunch) {
          this.delayLaunch = false;
          this.launch();
        }
      }, this));
    },

    setupFilter : function(filter, callback) {

      var el = this.getFilterElement(filter);
      if (!this.searchData[filter.data || filter.name]) {
        return callback();
      }

      async.nextTick(_.bind(function() {
        el.select2({ allowClear : true });
        if (this.currentSearch[filter.name]) {
          el.select2('val', this.currentSearch[filter.name]);
        }
        callback();
      }, this));
    },

    requestData : function() {

      var data = Tableling.Bootstrap.Table.prototype.requestData.apply(this);

      data.search = this.requestSearchData();
      if (_.isEmpty(data.search)) {
        delete data.search;
      }

      return data;
    },

    requestSearchData : function() {
      return _.inject(this.searchFilters, function(memo, filter) {
        var el = this.getFilterElement(filter);
        if (el.val()) {
          memo[filter.name] = el.val();
        }
        return memo;
      }, {}, this);
    },

    getFilterElement : function(filter) {
      return this.ui[filter.name + 'Filter'];
    }
  });
});
