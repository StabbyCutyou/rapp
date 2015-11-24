# Rapp

Rapp - The Ruby App Scaffolder

## Note

Prior to this incarnation, there was an older, similar gem named Rapp which was abandoned. I have obtained the authors permission both for use of the name, as well as for use of the project on Ruby Gems.

## Installation

Rapp is meant to run as a command line tool, not as a dependency. You should install it via the command line:

```shell
    $ gem install rapp
```
## Usage

Using Rapp is incredibly simple. It's designed to work like familiar scaffolders / builders in the ruby community (think `rails new`).

Currently, Rapp is in early development, and additional features are forthcoming. There is a Roadmap at the bottom of the Readme to highlight some of the work I feel is important to prioritize before a full v1 release. In addition to features, this includes the internal organization of the code as well.

### Ethos

Rapp is not a framework for running an app. In the future, there may be additional helpers to configure very common components in the ruby community, but the overall goal is to hand you a working application with a few common niceties, then get out of your way. Once you've generated the Rapp project, it is yours to do with as you see fit - the gem itself is not a dependency of the app you create.

Rapp projects are shells to house your app, in a familiar layout, to prevent you from having to write the same boring boilerplate time and time again.

Rapp is in no way shape or form meant for building web applications. You are free to attempt this if you wish, but if thats your goal, you're much better off with Rails, Sinatra, pure Rack, or any number of alternatives.

### Creating a new Rapp project

Creating a new Rapp project is simple

```shell
rapp my_new_rapp
```

The only requirement is that the directory must not exist as a safegaurd against accidentally overwriting any existing projects. Otherwise, thats it!

If the command executed successfully, you should see a report displaying the folders and files that Rapp created for you. After that, you're ready to start building your app!

### Dependencies

Rapp projects only have 2 dependencies - bundler and rake. Optionally, it will also include rspec, as well as a suite of specs for you to run to validate that the core underpinnings of the project are working as expected, in addition to your own custom specs.

### Layout

Rapp project structure looks like the following:

* app/
* app/models/
* app/services/
* app/jobs/
* bin/
* config/
* config/environments/
* config/initializers/
* lib/
* lib/tasks/
* spec/ (optional)
* {app_name}.rb
* {app_name}_base.rb
* Gemfile
* Rakefile

### {app_name}.rb

This is the primary entry point for you application. It includes {app_name}_base to handle booting and requiring all the dependencies. The class itself is empty, and the only code that specifically resides in this file is adding the current directory to the load path, so it can more easily locate {app_name}_base. All other code for additions to the load path, requiring bundler dependencies, etc etc resides in {app_name}_base.

### {app_name}_base.rb

Most of the generated code that Rapp creates lives here, such as:

* Defining the environment
* Providing an application level logger
* Loading dependencies via Bundler
* Adding core directories to the load path
* Requiring configuration, initializers, and environment-specific settings
* Requiring the contents of the app/ directory

You're free to modify any of this code however you see fit - however, most of the code in your core app file is meant to be added to (and not removed) for the convenience of you, the developer. Be that as it may, you are still free to do whatever you want inside of this file.

### App directory

This is likely a familiar concept to any Rails developer, with a few twists. Rails famously eschews the notion of keeping business logic in services - I do not eschew this practice, and believe it is the right way to keep a distinction between the logic of the application, and the data with which the application is modeled. You are free to use, ignore, remove, or otherwise throw out this directory as you see fit.

Additionally, there is a directory for "jobs", a place for daemonized background or out of band work to go, to make working with things like Chore or Sidekiq easier out of the box.

### Bin directory

If your application were to require an executable binary, it would be placed here. Otherwise, you may feel free to remove this directory

### Config directory

Another familiar convention for Rails developers, this directory and it's structure is meant to work in the same fashion as Rails. Dependency specific configuration needs can be placed into config/, initializers for your apps boot-up can be placed into config/initializers/, and any code specific to an environment (production / development / test) can be placed into config/environments. The load order is as follows:

1. The correct environment.rb (defaults to development)
2. The contents of config/initializers/, in alphabetical order
3. The contents of config/, in alphabetical order

These are loaded after Bundler, but before anything in app/

### Lib directory

Used for the same purpose as a Rails app or Ruby gem. Any code that falls outside of the norms of app/ would be placed here. Additionally, you may place tasks in lib/tasks/, and they will be registered via the Rake integration

### Rake

Currently, Rapp comes with 2 predefined rake tasks:

* console - This will boot up irb while loading your {app_name}.rb, which will load the rest of your app. This is aliased to "c" for convenience.
* environment - This will load up the {app_name}.rb, which will load the rest of your app, for use in chaining custom rake tasks that will rely on your application code

### Specs (Optional)

You can generate specs for your app to test the underpinnings of what Rapp has created. You can do this by specifying the ```--specs``` or ```-s``` flags on the command line.

These specs aim to not be in the way of you writing your own specs, and so the spec_helper is sparse, and the generated specs attempt to not include a test for {app_name}, but rather {app_name}_base, so that you can do any {app_name} specific testing in that file yourself if you so choose.

Mainly, these are here to help you make changes to a Rapp project once it's been generated if you so need, being able to verify that the core behaviors still function.

## Roadmap

At the moment, this gem serves to fit a need that I found myself having and figured others might be as well. To that end, my main goals are to provide a simple, stable core ruby app intended to be run as a simple cli program, daemonized process, or otherwise. Currently, my primary roadmap for development is:

1. Generate increased / improved specs for the users application
2. General code cleanup. Much of the code is prototypical and is not as DRY as it could be (ex: the builder class)
3. Dotenv integration for ease of local development w/ sample file containing all env vars
4. Configurable logging level from the environment
5. Test ease of use integrating Chore / Sidekiq like job systems

## Contributing

1. Fork it ( https://github.com/StabbyCutyou/rapp/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

# Contact

Comments? Criticisms? Concerns? Open an issue on Github, or simply tweet at me. I'm @StabbyCutyou on Twitter.
