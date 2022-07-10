# 6Estates idp-ruby

A Ruby SDK for communicating with the 6Estates Intelligent Document Processing(IDP) Platform.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add idp_sdk_ruby

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install idp_sdk_ruby

## Documentation
The documentation for the 6Estates IDP API can be found via https://idp-sea.6estates.com/docs


## Usage

### 1. To Extract Fields in Synchronous Way
If you just need to do one file at a time

```ruby
    require 'idp_sdk_ruby'
    c=IdpSdkRuby::Client.new(region:"test", token:'your-token-here')
    task_result=c.extraction_task.run_simple_task(file:File.new('path-to-the-file',"rb"), file_type:IdpSdkRuby::FileType.new().full_name_of_the_file_type)
```

### 2. To Extract Fields in Asynchronous Way
If you need to do a batch of files

```ruby
    require 'idp_sdk_ruby'
    c=IdpSdkRuby::Client.new(region:"test", token:'your-token-here')
    task=c.extraction_task.create(file:File.new('path-to-the-file',"rb"), file_type:IdpSdkRuby::FileType.new().full_name_of_the_file_type)
    task_result = result(task.task_id)
    while(task_result.status=='Doing' or task_result.status=='Init')
        sleep(3)
        task_result = result(task.task_id)
    end
```
