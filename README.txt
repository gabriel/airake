== Setup

Flex 3 SDK: http://opensource.adobe.com/wiki/display/flexsdk/Flex+SDK

To include mxmlc, adl and adt (from Flex SDK):
  export PATH="/path/to/flex3sdk/bin:$PATH"
  
Adobe AIR SDK: http://www.adobe.com/products/air/tools/sdk/
  
To include adl and adt (from Apollo SDK):
  export PATH="/path/to/air-sdk/bin:$PATH"
  
== Creating an AIR project

  airake path/to/MyProject
  
will build a project scaffold with application name of MyProject. The project includes as3corelib and flexunit, and test scaffolding as well.  
  
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
