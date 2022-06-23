# IdpSdkRuby

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/idp_sdk_ruby`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add idp_sdk_ruby

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install idp_sdk_ruby

## Usage

### 1. To Extract Fields in Synchronous Way
If you just need to do one file at a time

    require 'idp_sdk_ruby'
    c=IdpSdkRuby::Client.new(region:"test", token:'your-token-here')
    task_result=c.extraction_task.run_simple_task(file:File.new('path-to-the-file',"rb"), file_type:IdpSdkRuby::FileType.new().full_name_of_the_file_type)

### 2. To Extract Fields in Asynchronous Way
If you need to do a batch of files

    require 'idp_sdk_ruby'
    c=IdpSdkRuby::Client.new(region:"test", token:'your-token-here')
    task=c.extraction_task.create(file:File.new('path-to-the-file',"rb"), file_type:IdpSdkRuby::FileType.new().full_name_of_the_file_type)
    task_result = result(task.task_id)
    while(task_result.status=='Doing' or task_result.status=='Init')
        sleep(3)
        task_result = result(task.task_id)
    end

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/idp_sdk_ruby.
