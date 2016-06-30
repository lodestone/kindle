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
    Given an empty file named "~/.kindle/kindlerc.yml"
    And an empty file named "~/.kindle/database.yml"
    When I run `kindle --username=me@my.email --password=secret init`
    Then the output should contain:
    """
    blah
    """
    Then the file named "~/.kindle/kindlerc.yml" should contain:
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
    # And the file named "~/.kindle/database.yml" should contain:
    # """
    # """

  Scenario: `kindle update`
    # Given an empty file named "~/.kindle/settings.json"

  Scenario: `kindle highlights` should do something
    Given an empty file named "~/.kindle/settings.json"
    When I run `kindle highlights`
    And I type "hello, world"
    And I type "quit"
    Then the output should contain:
    """
    dog
    """

  Scenario: `kindle highlights json`

  Scenario: `kindle highlights csv`

  Scenario: `kindle highlights markdown`

  Scenario: `kindle console`
