Feature: Kindle Highlights

  In order to make highlighting in ebooks more useful
  As an Amazon user who highlights content via Kindle or Kindle app
  I want to get and interact with my kindle highlights via the command line

  Scenario: Default run without parameters should show help
    Given I successfully run `kindle`
    Then the output should contain:
    """
    kindle [global options] command [command options] [arguments...]
    """

  Scenario: When calling help
    Given I successfully run `kindle help`
    Then the output should contain:
    """
    kindle [global options] command [command options] [arguments...]
    """

  Scenario: `kindle init`

  Scenario: `kindle update`

  Scenario: `kindle highlights json` should do something
    Given time is frozen
    And a database exists
    And a file named "~/.kindle/kindlerc.yml" with:
    """
    ---
    :version: false
    :help: false
    :username: me@my.email
    :password: secret
    :domain: amazon.com
    commands:
      :_doc: {}
      :initdb: {}
      :init: {}
      :highlights:
        commands:
          :update: {}
          :json: {}
          :csv: {}
          :markdown: {}
      :console: {}
    """
    When I run `kindle highlights json`
    Then the output should contain:
    """
    "Reach for enlightenment"
    """
    And the output should contain:
    """
    "Zen"
    """

  Scenario: `kindle highlights csv`

  Scenario: `kindle highlights markdown`

  Scenario: `kindle console`
