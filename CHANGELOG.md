# Changelog

## v2.3.0 - October 2, 2014

**Upgrade Notes:**
Redis 2.6.12 or higher is now required.
The secret keys previously in `config/initializers/app_secrets.rb` must be moved to `config/secrets.yml`. See the [deployment documentation](doc/deploy.md) and the example in `config/samples/secrets.yml`.

* The information page for each test has been revamped into widgets.

* Test results payloads are now automatically purged after 30 days, test runs after 60 days. These lifetimes are configurable by administrators in the settings page. Administrators can also:

  * manually trigger a purge from the control center;

  * see the list of purged data.

## v2.2.1 - February 24, 2014

* Tests can now also be filtered by ticket in test run reports.

* Test custom values can now be up to 65535 bytes long.

* Uptime is now indicated on the status page.

* The old settings page (accessible only to administrators) has been split into settings and control center.

* Old test payloads, categories, tags and tickets can be purged from the new control center page.

* Fixed a bug where test payloads in reports would not be pretty printed by default.

* Fixed asset URLs in HAL API browser.

## v2.2.0 - February 10, 2014

**Upgrade Notes:** changes in this version require counters to be recomputed from the settings page. Now that PostgreSQL is supported, administrators must omit the unwanted database when installing gems with the `--without` option (e.g. `--without mysql`), see the [deployment documentation](doc/deploy.md).

* **NEW:** Tests can be searched by ticket.

* **NEW:** Test page permalinks come with a button to copy the link directly to the clipboard. They can also be copied from the tests table.

* **NEW:** The test selector in the Tests page allows you to collect tests for batch actions (deprecation) or to generate links.

* **NEW:** Deprecations are counted and displayed separately from new tests on the home page.

* ROX Center is now compatible with PostgreSQL. See the [deployment documentation](doc/deploy.md).

* Test payloads can be displayed at the bottom of test run reports.

* Multiple resque workers can now run in parallel without corrupting the processing of test payloads.

* Cache warmup after deployment no longer blocks report generation from the UI.

* Fixed a bug where home page test counts would not expire at the end of the day.

## v2.1.1 - January 15, 2014

**Upgrade Notes:** this upgrade can be done as a [hot deploy](doc/deploy.md#hot-deploy) with no downtime.

* Page URLs no longer include the locale.

* Test tables now include the test key. The last run date and duration have been moved to the status tooltip.

* Fixed test key generator bug where keys would overflow the box.

## v2.1.0 - January 14, 2014

* **NEW:** Test page permalinks accessible from each test page.

* The URL for the page describing a test has changed; it now also contains the project API identifier.

* Maintenance mode controllable from settings page (administrators only).

* Ugprade to Rails 4.0.2 and Bootstrap 3.

* The `secret_token.rb` initializer was replaced by the `app_secrets.rb` initializer. See the [deployment documentation](doc/deploy.md).

* Fixed sorting bug on all tables.

* Fixed test key generator bug where keys would not be displayed until the page was reloaded

## v2.0.0 - December 23, 2013

* **NEW:** Projects must now be created in ROX Center before test results can be submitted

* **NEW:** New test analytics; home page widget tracks the evolution of tests by day/week/month

* **NEW:** Hypermedia API with integrated documentation accessible from the menu

* **NEW:** LDAP or password authentication are supported with [devise](https://github.com/plataformatec/devise) (see `config/rox.yml`)

* **NEW:** Administrators can create, deactivate and modify users

* Project version is shown in test run report results

## v1.0.4 - May 24, 2013

* **NEW:** Uncategorized tests can be listed

* **NEW:** Report card tooltips show the test key, duration and result in addition to the name

* **NEW:** Tag cloud on home page only shows 50 most used tags (configurable), with link to full tag cloud

* **NEW:** The number of days before tests are marked as outdated can be configured in the settings

* Fixed unsecure warnings by downloading gravatars over HTTPS in production

* Numbers in *Metrics* page and user info pages are formatted with number separators

* Additional links to other tools are now separated from the brand link

* Test runs table shows run group (e.g. Nightly)

* Fixed a report bug where a result's details could not be filtered out after being shown manually by clicking on the card

* Fixed a report bug where the next run button would remain grayed out even after a new run was received in the same group

* Fixed a bug in the activity listing where the order would get changed after checking for updates in the background

* Fixed a bug where deprecated tests would be counted in the number of tests on the home page

* Fixed test run status to be 99% instead of 100% when over 99.5 but not 100.

### API

* **NEW:** Tag cloud can be retrieved with a max size: `/api/v1/tags/cloud?size=10`

* **NEW:** Test data (`/api/v1/status/tests`) includes the `outdated_days` property which indicates the number of days before tests are marked as outdated without activity

* The activity listing is sorted: technical users are first, then users who have run tests, then those who have never run tests. Technical users and users who have run tests are further sorted with those who have most recently run tests at the top. Users who have not run any tests are sorted alphabetically.

* Fixed a bug where sending duplicate tags or tickets in a test or payload would cause database constraints to fail. Duplicate tags are now ignored. Note that tags are case-insensitive: the **unit** and **Unit** tags are considered the same; the first one sent will be used.

### Known Issues

* Deprecating a test does not decrease the number of tests in the metrics page

* Changing the category or project of a test only increases the number of tests in the new category or project, but does not decrease it in the old

## v1.0.3 - April 3, 2013

* **NEW:** Home page links to jump to the latest test run in a group (e.g. Nightly)

* **NEW:** Home page links to jump to the latest tests of the 5 projects with the most recently created tests

* **NEW:** Administrator can add links to other tools (e.g. bug tracker) which are accessible from the brand link

* **NEW:** Test breakdown pie charts by author, project and category in *Metrics* page; test metrics can additionally be filtered by project and category

* Number of failing tests in activity listing is now a link to list the corresponding tests

* Test status tooltip in test tables with more information (breaker/runner, link to test run)

* Last 50 test run reports are now cached (configurable), older reports will be loaded asynchronously

* Test run reports have more links for easier navigation

* All tables now show a loading icon while downloading data

### API

* **BREAKING!** Payload test result message is now limited to 65535 bytes instead of 65535 characters

* **BREAKING!** API interprets test payload as UTF-8

### Upgrade

* `cache:deploy` rake task must be run instead of `cache:clear`

### Known Issues

* It is not possible to list uncategorized tests

## v1.0.2 - March 6, 2013

* **NEW:** Test run report results can now be filtered by name, key, tags or status

* **NEW:** Red Alert badge: made an all-red test run with at least 3 tests

* Activity listing only shows the latest 5 badges for each user instead of all

* Test run report data loads asynchronously to avoid freezing the UI

* Test run report summary durations now in short format (milliseconds hidden if over one second)

* Runner avatar in test report

### API

* `api.ENVIRONMENT.log` file rotated over 1MB (3 old copies are kept)

* API only answers in JSON

* API error messages now indicate erroneous data

### Upgrade

* **BREAKING!** Removed `/rox` path prefix in production environment

* Removed badge category from database (known from badge class)

* Updated gems (no major changes)

## v1.0.1 - March 4, 2013

* Fixed API log silencing (`/api/v*/activity`, `/api/v*/payload` and `/api/v*/status` only log warnings and errors, other paths log info also)

## v1.0.0 - March 4, 2013

* First stable version
