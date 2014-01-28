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
App.module('models', function() {

  var TestResult = this.TestResult = Backbone.RelationalModel.extend({

    relations: [
      {
        type: Backbone.HasOne,
        key: 'runner',
        relatedModel: 'User'
      },
      {
        type: Backbone.HasOne,
        key: 'test',
        relatedModel: 'Test'
      }
    ],

    url: function() {
      return LegacyApiPath.build('results', this.get('id'));
    },

    dataPath: function() {
      return LegacyApiPath.build('results', this.get('id'));
    },

    humanRunAt: function() {
      return Format.datetime.full(new Date(this.get('run_at')));
    }
  });

  var TestResultTableCollection = this.TestResultTableCollection = Tableling.Collection.extend({
    model: TestResult
  });
});