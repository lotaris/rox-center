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
$(function() {

  var container = $('#documentation');
  if (container.length) {

    container.find('a[href^="doc/"][href$=".md"]').each(function() {
      
      var link = $(this);
      link.attr('href', Path.build(link.attr('href').replace('\.md', '')));
    });
    
    var header = container.find('h2');
    if (header.length) {
  
      $('<ul id="toc" />').insertBefore(header.first()).tableOfContents(null, {
        startLevel: 2,
        topLinks: I18n.t('jst.common.topLink'),
        topLinkClass: 'top'
      });
    }
  }
});
