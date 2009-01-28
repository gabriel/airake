# Airake

Rake tasks and generators for Adobe AIR.

For more info see: [http://airake.rubyforge.org/](http://airake.rubyforge.org/)

## Setup

[Flex SDK](http://labs.adobe.com/technologies/flex/sdk/flex3sdk.html)

To include mxmlc and fcsh (from Flex SDK):
  export PATH="/path/to/flex_sdk_3/bin"
  
[AIR SDK](http://labs.adobe.com/downloads/airsdk.html)

To include adl and adt (from AIR SDK):
  export PATH="/path/to/air_sdk/bin:$PATH"
    
## Tasks

[Airake](http://airake.rubyforge.org/) can be used to build the swc, compile/run tests and run under ADL, etc.

View all tasks: `rake --tasks`

Compiling under AIR: `rake air:compile`

Running air debug launcher (ADL): `rake air:adl`

Start FCSHD (for faster compilation): `rake fcsh:start`

Stop FCSHD: `rake fcsh:stop`

Restart FCSHD: `rake fcsh:restart`

Running alternate MXML, (we expect src/Test-app.xml descriptor): `rake air:adl MXML=src/Test.mxml`

Run ADL with debug disabled: `rake air:adl DEBUG=false`

Testing: `rake air:test`

Package AIR file: `rake air:package`

## Adding other tasks

Add tasks to the rakefile, for example:

	# Run ADL for Catalog mxml
	task :catalog do
	  ENV["MXML"] = "src/catalog/Catalog.mxml"
	  Rake::Task["air:adl"].invoke
	end
