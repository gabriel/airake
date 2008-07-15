== Setup

To include mxmlc, adl and adt (from Flex Builder):
  export PATH="/Applications/Adobe Flex Builder 3/sdks/moxie/bin:$PATH"
  
To include adl and adt (from Apollo SDK):
  export PATH="/Applications/ApolloSDK/bin:$PATH"
  
== Creating an AIR project

  airake path/to/MyProject com.company.MyProject
  
will build a project scaffold with application name of MyProject and application id (used for AIR descriptor) of com.company.MyProject

The project includes as3corelib and flexunit, and test scaffolding as well.  
  
== Tasks

  Run: rake --tasks 

  # Compiling
  rake compile 

  # Running air debug launcher (ADL)
  rake adl 
  
  # Start FCSHD (for faster compilation)
  rake fcsh:start

  # Stop FCSHD
  rake fcsh:stop

  # Restart FCSHD
  rake fcsh:restart

  # Running alternate MXML, (the following expects src/Test-app.xml descriptor file)
  rake adl MXML=src/Test.mxml

  # Testing
  rake test

  # Package AIR file
  rake package
