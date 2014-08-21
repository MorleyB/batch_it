### System Requirements
============
  > Bash commands are indicated using the $ symbol. To execute the commands and continue the installation, you must be on the command line and in the project directory
    ```
    $ cd path/to/project/directory
    ```

  * Ruby 2.1.1
    * Verify system version of Ruby with RVM, ([]),. From the command line enter:
    ```
    $ ruby -v
    ```

    If the version does not match Ruby 2.1.1, list the available versions of Ruby and specify the correct version:

    ```
    $ rvm list
    $ rvm use ruby-2.1.1

    Upgrading Ruby: Follow the link, ([https://rvm.io/rubies/upgrading]), and complete the first example. As soon as installation has been completed, start at the top of System Requirements and execute the bash commands.

  * Bundler
    * To install Bundler, navigate to ([http://bundler.io/]) and follow the first Getting Started example.
    ```
    $ gem install bundler
    ```


### Gems
============
  * This program is using bundler to install gems. To install gems from the project directory, using the command line:

    ```
    $ bundle install
    ```

    If bundler is not installed, follow the first Getting Started example, ([http://bundler.io/]).



### Run Application
============
  ## From the project directory:
  ```
  $ ./bin/batch_it xml_file_path xml_file_path your_out_put_path
  ```

  ### Run processor from the command line example

  ```
  $ ./bin/batch_it data/destinations.xml data/taxonomy.xml tmp
  ```


### Application Help
============
  ## From the project directory:
  ```
  $ ./bin/batch_it --h
  ```
  ## Or

  ```
  $ ./bin/batch_it --help
  ```
