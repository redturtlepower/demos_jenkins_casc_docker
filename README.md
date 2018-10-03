Multiple ways how to run a dockerized jenkins

- v1
Standalone jenkins, at path /jenkins

- v2
v1 + install plugins from configuration file plugins.txt 

- v3 
v2 + added configuration-as-code (casc) plugin with environment variable for config file finding

- v4
v3 + build agent configuration via casc (Mac mini in local network)

- v5 (TBD)
v + load job/pipeline definition from config file and build a hello world app on build agent

- v (TBD)
v + load job/pipeline definition from config file and build/test/package a hello world app on build agent

- v (TBD)
v + load job/pipeline definition from config file and build/test/package a complex app on build agent

- v (TBD)
v + remove initial unlock screen and plugin configuration page at initial jenkins start

ideas for the future

- v (usable for a development machine or maybe small scale production?)
v + deployed custom app, using vault credential manager

- v (for big scale production?)
v + deployed custom app, via kubernetes on gce
