this.Translations.en =
  common:
    noData: "-"
    topLink: "Back to top"
    unexpectedModelError: "Record could not be saved"
    edit: "Edit"
    save: "Save"
    cancel: "Cancel"
    create: "Create"
    delete: "Delete"
    loading: "Loading..."
    close: "Close"
    alert:
      danger: "Oops!"
      warning: "Warning."
    "true": "yes"
    "false": "no"
    copyToClipboard: "Copy to clipboard"
    copiedToClipboard: "Copied!"
  application:
    maintenance:
      title: "Maintenance Mode."
      notice: "ROX Center is currently undergoing maintenance. You will only be able to view data until maintenance is complete."
  testWidgets:
    info:
      title: "Information"
      goToCategory: "Go to the list of all tests in the __name__ category."
      goToTag: "Go to the list of all tests with the __name__ tag."
      goToTicket: "Go to the list of all tests related to the __name__ ticket."
      goToExternalTicket: "Go to the __name__ ticket in the external ticketing system."
    permalink:
      title: "Permalink"
      instructions: "Use this permalink to link to this test from elsewhere."
    status:
      title: "Status"
      deprecate: "Deprecate"
      deprecateConfirmation: "Are you sure you want to deprecate this test?"
      undeprecate: "Undeprecate"
      undeprecateConfirmation: "Are you sure you want to reactivate this test?"
      deprecationError: "Could not change test status."
      statusDescription:
        passed: "The test <strong>passed</strong> the last time it was run."
        failed: "The test <strong>failed</strong> the last time it was run."
      inactiveDescription: "It is marked as <strong>inactive</strong> so it will not be counted as either passed or failed in test statistics."
      deprecatedDescription: "It is <strong>deprecated</strong> so it will not be counted and remain hidden unless explicitly searching for deprecated tests."
    results:
      title: "Results"
      description: "1 result found on __time__."
      description_plural: "__count__ results from __start__ to __end__."
      error: "Could not load test results."
      resultDescription:
        passed: "Passed on __time__ (version __version__)."
        failed: "Failed on __time__ (version __version__)."
    executionTime:
      title: "Execution Time"
      error: "Could not load test results."
      pointInstructions: "Click for details."
      resultStatus:
        passed: "passed"
        failed: "failed"
    gherkinScenario:
      title: "Gherkin Scenario"
    resultDetails:
      title: "Result Details"
      instructions: "Click on a result in the other widgets to display it here."
      runAtTooltip: "Click to go to the test run."
      noMessage: "No message was submitted with this result."
      expandTooltip: "Show result information in a larger window."
      messageError: "The result message could not be loaded."
      status:
        passed: "passed"
        failed: "failed"
        inactive: "inactive"
  testResultSelector:
    show: "Show last"
    resultsForVersion: "results for"
    size: "Size"
    version: "Version"
    allVersions: "all versions"
  purge:
    title: "Data Purge"
    instructions: "Data is purged to save space. Some of the data is purged only after a given time, some as soon as it's no longer referenced."
    lifetimeInstructions: "For the former, the lifetimes are defined in the"
    settingsLink: "settings."
    purge: "Purge"
    all: "All"
    none: "none"
    confirm: "Are you sure you want to purge __name__ old data? This operation cannot be canceled."
    purging: "Purging data..."
    description:
      outdated: "__n__ older than __lifespan__"
      orphan: "__n__ unused"
    info:
      payloads:
        name: "Test Payloads"
      tags:
        name: "Tags"
      tickets:
        name: "Tickets"
  statusModule:
    disconnected: "The connection to the server was lost. Data will not be refreshed anymore until you reload the page."
  linkTemplates:
    title: "Link Templates"
    instructions: "Link templates allow ROX Center to provide you with correctly formatted links for your documentation tool of choice."
    empty: "No link templates are defined."
    confirmDelete: "Are you sure you want to delete the __name__ template?"
    noTemplate:
      name: "no template"
      contents: "%{url}"
  testSelector:
    description: "The selector allows you to collect tests for batch operations or to obtain a list of links."
    instructions: "Select tests by clicking on rows in the table below."
    selectAll: "Select all"
    unselectAll: "Unselect all"
    numberSelected: "You have selected 1 test."
    numberSelected_plural: "You have selected __count__ tests."
    clearSelection: "Clear selection"
    open: "Open selector"
    title: "Test Selector"
    close: "Close selector"
    linkFormat: "Format links with"
    linkSeparator: "separated by"
    linkSeparatorBlank: "no separator"
    newLines: "new lines"
    batchActions: "Batch actions"
    deprecate: "Deprecate selected tests"
    undeprecate: "Undeprecate selected tests"
    deprecationError: "Could not deprecate or undeprecate tests."
  maintenanceControls:
    title: "Maintenance Mode"
    instructions:
      userNotice: "When in maintenance mode, users will not be able to perform the following actions:"
      userActions:
        payloads: "Send test result payloads"
        testKeys: "Generate/release test keys"
        apiKeys: "Request/disable/delete API keys"
        deprecations: "Deprecate/undeprecate tests"
      adminNotice: "These administrative actions will also be unavailable:"
      adminActions:
        projects: "Create/delete projects"
        users: "Edit/deactivate/delete users"
    activate: "Start maintenance"
    deactivate: "End maintenance"
    status: "Application Status"
    statusOn: "In maintenance"
    statusOff: "Online"
    confirmation: "Are you sure you want to start the maintenance mode?"
    time: "Maintenance Time"
    error: "Could not toggle maintenance mode."
  latestTestRuns:
    title: "Latest Test Runs"
    results: "Results"
    empty: "No tests results were received yet."
  userInfo:
    activate: "Activate"
    deactivate: "Deactivate"
    deactivatedInstructions: "This user cannot log in or use the API."
    confirmDelete: "Are you sure you want to delete this user? This operation cannot be canceled."
    activationError: "Could not activate or deactivate user."
    deletionError: "Could not delete user."
  currentTestMetrics:
    title: "Test Count"
    today: "Today"
    week: "Last 7 days"
    month: "Last 30 days"
    written: "New Tests"
    run: "Tests Run"
    tooltip:
      time:
        today: "today"
        week: "over the last week"
        month: "over the last month"
      writtenText: "__user__ wrote __n__ new tests __time__"
      runText: "__user__ ran __n__ tests __time__"
  testCountersManager:
    title: "Test Counters"
    instructions: "The number of tests written and run each day is cached in counters and updated with each new test run. This helps to quickly display information about the number of tests without having to analyze the raw data."
    status: "Status"
    statuses:
      idle: "Idle"
      preparing: "Preparing"
      computing: "Computing"
    jobs: "Pending Jobs"
    remainingResults: "Remaining Results"
    totalCounters: "Total Counters"
    recompute: "Recompute all counters"
    recomputeConfirmation: "This will clear and re-compute all test counters. It will take from minutes to hours depending on the amount of data. Are you sure you want to proceed?"
    maintenanceNotice: "The application must be in maintenance mode to start recomputing counters. The maintenance can be ended as soon as the process has started."
    recomputingStarted: "The recomputing process has started successfully. You may stop the maintenance mode at your convenience."
  projectEditor:
    namePlaceholder: "My project"
    tokenPlaceholder: "my_project"
    create: "Add a project"
    update: "Edit this project"
    createFormTitle: "New project"
    updateFormTitle: "Editing"
    urlTokenInstructions: "allowed characters: a-z, 0-9, -, _"
  breakdownChart:
    noItem:
      category: "Uncategorized"
    title:
      category: "Tests by Category"
      project: "Tests by Project"
      author: "Tests by Author"
    subtitle:
      category: "for the 12 most used categories"
      project: "for the 12 projects with the most tests"
      author: "for the 12 authors who have written the most tests"
  testResult:
    status:
      passed: "passed"
      inactive: "inactive"
      failed: "failed"
  menuLinksManager:
    title: "Menu Links"
    instructions: "Links will appear next to the menu brand as a dropdown menu."
    empty: "No links are defined"
    confirmDelete: "Are you sure you want to delete the __name__ link? This operation cannot be canceled."
  appData:
    headers:
      general: "General"
      jobs: "Jobs"
      count: "Records"
    environment: "Environment"
    uptime: "Uptime"
    users: "Users"
    databaseSize: "Database Size"
    cacheSize: "Cache RAM Size"
    resqueLink: "Resque Backend"
    localStorageSize: "Local Storage Size"
    jobs:
      workers: "Workers"
      working: "Working"
      pending: "Pending"
      processed: "Processed"
      failed: "Failed"
  testsData:
    tests: "Tests"
    testResults: "Results"
    testRuns: "Runs"
    failingTests: "Failing"
    outdatedTests: "Outdated"
    inactiveTests: "Inactive"
    outdatedInstructions: "Tests that have not been run in __days__ days"
  testRunReport:
    loadingError: "Report data could not be loaded"
    loadingTimeout: "Report generation timed out"
    noMatch: "No results matching this filter."
    statusFilter:
      passed:
        show: "Click to show passed results"
        hide: "Click to hide passed results"
      failed:
        show: "Click to show failed results"
        hide: "Click to hide failed results"
      inactive:
        show: "Click to show inactive results"
        hide: "Click to hide inactive results"
    tooltipMessage:
      passed: "Passed"
      failed: "Failed"
      inactive: "Inactive"
    payloads:
      title: "API Payloads"
      purged: "No longer available."
      listError: "Could not list test payloads."
      info: "__count__ payload"
      info_plural: "__count__ payloads"
      prettyPrint: "Pretty"
      rawPrint: "Raw"
      stats: "Queued for __queueTime__, processed in __processingTime__."
      copyToClipboard: "Copy"
      error: "Could not download test payload. It might have been purged."
  globalSettings:
    title: "General"
    reportsCacheSize: "Reports Cache Size"
    reportsCacheSizeInstructions: "maximum number of reports to cache on disk (0 for no cache)"
    tagCloudSize: "Tag Cloud Size"
    tagCloudSizeInstructions: "maximum number of tags to show on the home page (1 or more)"
    testOutdatedDays: "Tests Outdated Days"
    testOutdatedDaysInstructions: "tests will be marked as outdated after this number of days (1 or more)"
    testPayloadsLifespan: "Lifespan of Test Payloads"
    testPayloadsLifespanInstructions: "payloads will be purged after this number of days (1 or more)"
    ticketingSystemUrl: "Ticketing System URL"
    save: "Save"
    error: "Could not save settings"
    success: "Successfully saved settings"
  usersTable:
    empty: "No users found."
  apiKeysTable:
    empty: "No API keys found."
    new: "Request a new API key"
    disable: "Disable this key"
    enable: "Enable this key"
    delete: "Delete this key"
    deleteConfirmation: "Are you sure you want to delete this key?"
    keyError: "Could not update or delete API key."
    creationError: "Could not create API key."
    generalError: "An error occurred while contacting the server."
  projectsTable:
    empty: "No projects found."
  keyGenerator:
    generate: "Generate"
    release: "Release unused keys"
    releaseConfirmation: "Are you sure you want to release all unused keys? This operation cannot be canceled. If you have used these keys for tests whose results have not yet been submitted, you will have to generate and assign new keys to these tests."
    newKeys: "new keys for"
    noProject: "No project available"
    instructions: "Each test must be identified by a unique key. You can request keys for new tests here."
    errors:
      generate: "Could not generate keys."
      release: "Could not release keys."
  resultData:
    instructions: "Click on a result to see its data."
    noMessage: "This result has no message."
    error: "Could not load result data."
    tabs:
      message: "Message"
  hallOfShame:
    title: "Hall of Shame"
    loading: "Loading..."
    refresh: "Refresh"
    headers:
      user: "User"
      currentlyFailingTests: "Currently Failing"
      testsBrokenFixed: "Broken / Fixed"
  testRunsTable:
    empty: "No tests have been run."
    status: "Status"
    search:
      groups:
        placeholder: "By group"
      runners:
        placeholder: "By runner"
  tableWithAdvancedSearch:
    search:
      show: "Show Advanced Search"
      hide: "Clear Advanced Search"
  testsTable:
    empty: "No matching tests found."
    lastRun: "Last Run"
    lastRunDate: "Date"
    lastRunDuration: "Duration"
    moreInfo: "Click for more info"
    goToLastRun: "Click to go to test run"
    keyTooltip: "Copy permalink to clipboard"
    search:
      status:
        placeholder: "By status"
        failing: "Failing"
        outdated: "Outdated"
        deprecated: "Deprecated"
        inactive: "Inactive"
      tags:
        placeholder: "By tag"
      tickets:
        placeholder: "By ticket"
      authors:
        placeholder: "By author"
      categories:
        placeholder: "By category"
        blank: "Uncategorized"
      projects:
        placeholder: "By project"
      breakers:
        placeholder: "By breaker"
  models:
    linkTemplate:
      name: "Name"
      contents: "Template"
    apiKey:
      identifier: "ID"
      sharedSecret: "Shared secret"
      createdAt: "Created at"
      lastUsedAt: "Last used at"
      usageCount: "Uses"
    user:
      name: "Username"
      active: "Active"
      email: "E-mail"
      createdAt: "Registered Since"
    test:
      name: "Name"
      project: "Project"
      author: "Author"
      key: "Key"
      createdAt: "Created"
      lastRunAt: "Last run"
      lastRunDuration: "Duration"
      status: "Status"
      category: "Category"
      tags: "Tags"
      tickets: "Tickets"
      permalink: "Permalink"
      inactive: "Inactive"
      deprecated: "Deprecated"
    testRun:
      runner: "Runner"
      status: "Status"
      endedAt: "End Date"
      duration: "Duration"
      numberOfResults: "Tests"
      group: "Group"
    testResult:
      runAt: "Run at"
      duration: "Duration"
      runner: "Runner"
      version: "Version"
      status: "Status"
      test: "Test"
    project:
      name: "Name"
      activeTestsCount: "Number of tests"
      createdAt: "First tested at"
      apiId: "API identifier"
      urlToken: "URL token"
    link:
      name: "Name"
      url: "URL"
