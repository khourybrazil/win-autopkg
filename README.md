Win-AutoPkg
===========

CAUTION: This software is currently in development and is not yet functional

Win-AutoPkg is an automation framework for Windows software packaging and distribution. Even though Windows Sysadmins have the benefit of a standardized package format that is distributable at an enterprise scale (MSI), many vendors or projects don't utilize it or they require work to deploy properly. Even with a properly created MSI, it can be time consuming to download a package and prepare it for distribution in SCCM, Puppet or Group Policy. Preparing a package often involves at least some of these steps:

* Downloading an application and/or updates for it, usually via a web browser
* Extracting the package from an archive or even from an executable
* Organization specific configuration or transforms
* Locating documentation for command line switches to install silently
* Sometimes modifying the package itself using esoteric tools and methods
* Importing into a software distribution system like SCCM, Group Policy or Puppet
* Configuring the application after installation using scripts or Group Policy templates

Often these tasks follow similar patterns for each individual application, and when managing many applications this becomes a daily task full of sub-tasks that one must remember (and/or maintain documentation for) about exactly what had to be done for a successful deployment of every update for every managed piece of software.

With Win-AutoPkg, we define these steps in a "Recipe" plist-based format, run automatically instead of by hand, and shared with others.

There are several commercial vendors that offer similar functionality. Some provide the software directly while others provide their own proprietary "recipes" to download the software directly from the vendors before distributing it to other computers in the organization. Win-AutoPkg isn't intended to install software since there are already so many configuration management options out there, but is designed to create community-driven collaborative recipes that can be used by anyone for any distribution method they prefer.

AutoPkg
-------

Win-AutoPkg borrows *very* heavily from [AutoPkg](https://github.com/autopkg/autopkg/releases/latest) written for OS X, copying function names, some logic, strings, parameters, comments and even documentation. AutoPkg is Copyright Per Olofsson and is licensed under the [Apache License 2.0.](https://github.com/autopkg/autopkg/blob/master/LICENSE.txt)

Win-AutoPkg deviates from AutoPkg in several ways:

* Written in PowerShell vs. Python
* Less features at this time
* YAML recipe format rather than plists (XML-ish format espoused by Apple)

Dependencies
------------

Win-AutoPkg depends on:
 
[NuGet](https://www.nuget.org/)    
NuGet isn't strictly required, but useful for installing YamlDotNet and may be needed by some recipes

[YamlDotNet](https://github.com/aaubry/YamlDotNet)    
Yaml support in .Net-based software

[PowerYaml](https://github.com/scottmuc/PowerYaml)    
YamlDotNet support in PowerShell

Installation
------------

This software is not yet currently usable.

License
-------

See file LICENSE.txt

