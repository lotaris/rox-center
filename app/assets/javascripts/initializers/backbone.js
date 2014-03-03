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
Backbone.fetchHalHref = function(refs, source, deferred) {

  var deferred = deferred || $.Deferred();

  var url;
  if (source) {

    if (!_.isObject(source._links)) {
      throw new Error('Expected source to have links in the _links property, got ' + JSON.stringify(source));
    }

    var ref = refs.shift();

    var link = source._links[ref.rel];
    if (!link) {
      throw new Error('Expected source links to have a ' + ref.rel + ' link, got ' + _.keys(source._links).join(', '));
    } else if (!link.href) {
      throw new Error('Expected source link ' + ref.rel + ' to have an href property, got ' + JSON.stringify(link));
    } else if (ref.template && !link.templated) {
      throw new Error('Template parameters were given for link ' + ref.rel + ' but it is not templated, got ' + JSON.stringify(link));
    }

    url = link.href;
    if (ref.template) {
      url = new UriTemplate(url);
      url = url.fillFromObject(ref.template);
    }
  } else {
    url = ApiPath.build();
  }

  if (!refs.length) {
    App.debug('HAL link is ' + url);
    deferred.resolve(url);
    return deferred;
  }

  App.debug('Fetching HAL link ' + refs[0].rel + ' from ' + url);

  $.ajax({
    url: url,
    type: 'GET',
    dataType: 'json'
  }).done(function(response) {
    Backbone.fetchHalHref(refs, response, deferred);
  }).fail(function() {
    deferred.reject('Could not GET ' + url);
  });

  return deferred;
};

Backbone.originalSync = Backbone.sync;
Backbone.sync = function(method, model, options) {
  options = _.clone(options) || {};

  var url = null;

  try {
    url = options.url || _.result(model, 'url');
  } catch (e) {
    // nothing to do
  }

  var cachedUrl = _.result(model, 'halCachedUrl')
  if (!cachedUrl && !model.halUrl) {
    cachedUrl = _.result(model.collection, 'halCachedUrl');
  }

  if (!url && cachedUrl) {
    url = cachedUrl;
    options.url = cachedUrl;
  }

  if (url) {
    return Backbone.originalSync.apply(Backbone, Array.prototype.slice.call(arguments));
  }

  var halUrl = _.result(model, 'halUrl'),
      halUrlSource = model;

  if (!halUrl) {
    halUrl = _.result(model.collection, 'halUrl');
    halUrlSource = model.collection;
  }

  if (!halUrl) {
    throw new Error('Model/collection must have url or halUrl.');
  }

  // WTF: fix for weird backbone behavior.
  // Fore some reason, when creating a model, backbone resets empty attributes
  // right after starting to sync with the server. Since the actual sync happens
  // later (after the HAL URL has been fetched), we need to make sure the
  // attributes are passed in the options instead.
  if (!options.attrs) {
    options.attrs = model.toJSON(options);
  }

  var args = Array.prototype.slice.call(arguments),
      deferred = $.Deferred();

  Backbone.fetchHalHref(halUrl.slice()).fail(_.bind(deferred.reject, deferred)).done(function(url) {
    options.url = url;
    halUrlSource.halCachedUrl = url;
    Backbone.originalSync.apply(Backbone, args).done(_.bind(deferred.resolve, deferred)).fail(_.bind(deferred.reject, deferred));
  });

  return deferred;
};
