# Home
https://developers.google.com/speed/pagespeed/insights/

My technology radar
# 6 R's of a Cloud Migration
The [“6 Rs”](https://spr.com/6-rs-of-a-cloud-migration/) are:
* Remove
* Retain
* Replatform
* Rehost
* Repurchase
* Refactor

# [12 Factor App](https://12factor.net)

# [Reactive Manifesto](https://www.reactivemanifesto.org/)

# dotnet
    - https://dotnet.microsoft.com/download/dotnet-core
    - https://devblogs.microsoft.com/dotnet/net-core-tooling-update-for-visual-studio-2017-version-15-9/
        - Options -> Projects and Solutions -> .NET Core -> Uncheck "Use Preview of the .NET Core SDK"
    
1. https://github.com/natemcmaster/dotnet-tools
  1. docker-watch : A command line utility to notify docker mounted volumes about changes on Windows.
  2. dotnet-ignore : Sync global git ignore .gitignore file downloaded from GitHub
  3. dotnet-lambda : Tools to deploy AWS Lambda functions. Global tool started at version 3.0.0.
  4. dotnet-format : Enforce coding style solution-wide
  5. dotnet-gitversion : Easy Semantic Versioning (http://semver.org) for projects using Git.
  6. dotnet-hash : A simple dotnet tool to calculate hashes for the given file.
  7. dotnet-migrate-2017 : Tool for converting a MSBuild project file (`csproj`) to VS2017 format and beyond.
  8. dotnet-property : .NET Core command-line (CLI) tool to update project properties and version numbers on build.
  9. dotnet-retire : A dotnet CLI extension to check your project for known vulnerabilities.  (It fetches the packages listed in the corresponding packages repo in this GitHub organization (link), and checks your projects obj\project.assets.json or project.lock.json file for any match (direct, or transient).)
  10. dotnet-runas : Allows to run a dotnet process under a specified user account.
  11. dotnet-warp : A .NET Core global tool to pack project into single executable using Warp.
  12. efg : .NET Core command-line (CLI) tool to generate Entity Framework Core model from an existing database.
  13. certes : CLI tool for acquire certificates via the Automated Certificate Management Environment (ACME) protocol. (example: LetsEncrypt.org)
  14. docs : Search docs.microsoft.com using the command line.
  15. dotnet-encrypto : A tool to encrypt/decrypt folder or files using AES 256 Encryption Algorithm
  16. dmd5 : Just generate MD5 hash value in CLI.
2. https://github.com/RSuter/DNT

# API Development Tools
1. https://rapidapi.com/developers
2. https://konghq.com/cloud/ - whitepaper: [GigaOm: API Management Benchmark Report: Product Profile and Evaluation: Kong Enterprise and Apigee Edge](https://konghq.com/wp-content/uploads/2019/01/GigaOm-API-Platform-Benchmark-Kong-Apigee-1-25-19-1.pdf)
3. https://docs.apigee.com/ - Apigee was acquired by [Alphabet's Google Cloud for $625M on September 8, 2016](https://en.wikipedia.org/wiki/List_of_mergers_and_acquisitions_by_Alphabet)
4. https://apiary.io/ - Apiary was acquired by [Oracle for undisclosed amount on January 19, 2017](https://en.wikipedia.org/wiki/List_of_acquisitions_by_Oracle)
5. AWS API Gateway
6. Azure API Management
7. Moesif -  https://www.moesif.com/solutions/api-product-management

# Chat
1. https://rocket.chat/
2. https://gitlab.com/gitlab-org/gitter

# SysInternals Alternatives

[ProcessHacker](https://github.com/processhacker/processhacker)
[Dependencies](https://github.com/lucasg/Dependencies)

# Hashing functions
https://github.com/Cyan4973/xxHash

| GitHub | NuGet | Description | Radar Positioning |
| ------ | ----- | ----------- | ----------------- |
| [Data.HashFunction](https://github.com/brandondahler/Data.HashFunction/) | [System.Data.HashFunction.Core](https://www.nuget.org/packages/System.Data.HashFunction.Core/) | C# library to create a common interface to non-cryptographic hash functions (http://en.wikipedia.org/wiki/List_of_hash_functions#Non-cryptographic_hash_functions) and provide implementations of public hash functions.  Includes wrapper for HashAlgorithm-based hash functions. | Assessing |
| [Data.HashFunction](https://github.com/brandondahler/Data.HashFunction/) | [System.Data.HashFunction.Interfaces](https://www.nuget.org/packages/System.Data.HashFunction.Interfaces/) | C# library to create a common interface to non-cryptographic hash functions (http://en.wikipedia.org/wiki/List_of_hash_functions#Non-cryptographic_hash_functions). | Assessing |
| [Data.HashFunction](https://github.com/brandondahler/Data.HashFunction/) | [System.Data.HashFunction.xxHash](https://www.nuget.org/packages/System.Data.HashFunction.xxHash/) | Data.HashFunction implementation of xxHash (https://code.google.com/p/xxhash/).| Assessing |
| [Data.HashFunction](https://github.com/brandondahler/Data.HashFunction/) | [System.Data.HashFunction.MurmurHash](https://www.nuget.org/packages/System.Data.HashFunction.MurmurHash/) | Data.HashFunction implementation of MurMurHash (https://code.google.com/p/smhasher/wiki/MurmurHash). | Assessing |
| [Data.HashFunction](https://github.com/brandondahler/Data.HashFunction/) | [System.Data.HashFunction.CityHash](https://www.nuget.org/packages/System.Data.HashFunction.CityHash/) | Data.HashFunction implementation of CityHash (https://code.google.com/p/cityhash/). | Assessing |
| [Data.HashFunction](https://github.com/brandondahler/Data.HashFunction/) | [System.Data.HashFunction.CRC](https://www.nuget.org/packages/System.Data.HashFunction.CRC/) | Data.HashFunction implementation of the cyclic redundancy check (CRC) error-detecting code (http://en.wikipedia.org/wiki/Cyclic_redundancy_check). Implementation is generalized to encompass all possible CRC parameters from 1 to 64 bits. | Assessing |
| [Data.HashFunction](https://github.com/brandondahler/Data.HashFunction/) | [System.Data.HashFunction.FNV](https://www.nuget.org/packages/System.Data.HashFunction.FNV/) | Data.HashFunction implementation of Fowler–Noll–Vo hash function (http://www.isthe.com/chongo/tech/comp/fnv/index.html) https://en.wikipedia.org/wiki/Fowler%E2%80%93Noll%E2%80%93Vo_hash_function | Assessing |
| [Data.HashFunction](https://github.com/brandondahler/Data.HashFunction/) | [System.Data.HashFunction.FarmHash](https://www.nuget.org/packages/System.Data.HashFunction.FarmHash/) | Data.HashFunction implementation of FarmHash (https://github.com/google/farmhash). | Assessing |

# Screenshot manipulation
[paint.net](https://forums.getpaint.net/)
[Paint.Net plugin: CodeLab](https://boltbait.com/pdn/codelab/)

# Networking
| GitHub | NuGet | Description | Radar Positioning |
| ------ | ----- | ----------- | ----------------- |
| [RSocket.Net](https://github.com/rsocket/rsocket-net) | [RSocket.Net](https://www.nuget.org/packages/RSocket.Core/) | Reactive Streams socket programming, See [motivations](https://github.com/rsocket/rsocket/blob/master/Motivations.md) | Assessing |


# Parsing

| GitHub | NuGet | Description | Radar Positioning |
| ------ | ----- | ----------- | ----------------- |
| [Verex](https://github.com/MohammadHamdyGhanem/Verex) | [Verex](https://www.nuget.org/packages/Verex/) | Verex: The Verbal Regex Builder | Assessing |

# Inversion of Control / Dependency Injection
## Frameworks
[Using Scrutor to automatically register your services with the ASP.NET Core DI container](https://andrewlock.net/using-scrutor-to-automatically-register-your-services-with-the-asp-net-core-di-container/)

## Function Detouring / Function Hooking
| GitHub | NuGet | Description | Radar Positioning |
| ------ | ----- | ----------- | ----------------- |
| [Detours.net](https://github.com/citronneur/detours.net) | n/a | Hook native API with C# | Assessing |
| [Detourium](https://github.com/atillabyte/Detourium/) | [Detourium](https://www.nuget.org/packages/Detourium/) | A library to assist with detours using the .NET CLR in (un-)managed processes. | Assessing |
| [Prig](https://github.com/urasandesu/Prig) | [Prig](https://www.nuget.org/packages/Prig/) | Prig is a lightweight framework for test indirections in .NET Framework. | Assessing |
| [Juno](https://github.com/Akaion/Juno) | [Juno](https://www.nuget.org/packages/Juno/) | A Windows managed function detouring library written in C# that supports both x86 and x64 detours. | Assessing |
| n/a | [DotNetDetour](https://www.nuget.org/packages/DotNetDetour/) | dotnet hook lib | Assessing | 
| [Harmony](https://github.com/pardeike/Harmony) | [Lib.Harmony](https://www.nuget.org/packages/Lib.Harmony/) | A general non-destructive patch library for .NET and Mono modules | Assessing |
| [Reloaded.Hooks](https://github.com/Reloaded-Project/Reloaded.Hooks) | [Reloaded.Hooks](https://www.nuget.org/packages/Reloaded.Hooks/) | Advanced native function hooks for x86, x64. Welcome to the next level! (Tagline: WTF You can unit test function hooks!?) | Assessing |
| [EasyHook](https://easyhook.github.io/) | [EasyHook](https://www.nuget.org/packages/EasyHook/) | The reinvention of Windows API Hooking. <br />EasyHook makes it possible to extend (via hooking) unmanaged code APIs with pure managed functions, from within a fully managed environment on 32- or 64-bit Windows XP SP2, Windows Vista x64, Windows Server 2008 x64, Windows 7, Windows 8.1, and Windows 10. | Assessing |

## Benchmarks
1. https://github.com/danielpalme/IocPerformance
2. https://github.com/drewnoakes/string-theory
3. Frans Bouma's https://github.com/FransBouma/RawDataAccessBencher - contains EFCore vs. EF Classic vs. NHibernate vs Dapper
3. BenchmarkDotNet
4. https://github.com/rickstrahl/WestwindWebSurge 

## Debugging
1. https://github.com/BlueMountainCapital/DotNetStackPrinter - An app that prints the stack traces of a target .NET process

# Static Analysis
| GitHub | NuGet | Description | Radar Positioning |
| ------ | ----- | ----------- | ----------------- |
| [Roslinq](https://github.com/benetkiewicz/Roslinq) | [Roslinq](https://www.nuget.org/packages/Roslinq/) | With Roslinq it's possible to use Linq to browse through source code and modify it. | Assessing |

# Network Port Mapping
NirSoft CurrPorts utility

# Testing

## Code Coverage
https://github.com/axodox/AxoCover

## Test Framework
| GitHub | NuGet | Description | Radar Positioning |
| ------ | ----- | ----------- | ----------------- |
| [Xunit.SkippableFact](https://github.com/AArnott/Xunit.SkippableFact) | [Xunit.SkippableFact](https://www.nuget.org/packages/Xunit.SkippableFact/) | Make your Xunit test methods self-determine to report a "skipped" result. Useful for such cases as "not supported on this platform" results or other environmental inputs. | Stable |

## Test Data
| GitHub | NuGet | Description | Radar Positioning |
| ------ | ----- | ----------- | ----------------- |
  | [ObjectHydrator](https://github.com/PrintsCharming/ObjectHydrator) <br />[Foundation.ObjectHydrator.Core](https://github.com/rukai-kooboo/ObjectHydrator) | [ObjectHydrator](https://www.nuget.org/packages/objecthydrator/) <br />[Foundation.ObjectHydrator.Core](https://www.nuget.org/packages/Foundation.ObjectHydrator.Core/) | NuGet package ObjectHydrator Hasn't been updated since 2015. GitHub activity February 2018. | - |
| [Faker.NET.Portable](https://github.com/WormieCorp/Faker.NET.Portable) | [Faker.Net.Portable](https://www.nuget.org/packages/Faker.Net.Portable) | C# port of the Ruby Faker gem (http://faker.rubyforge.org/) and is used to easily generate fake data: names, addresses, phone numbers, etc. | n/a |
| [AutoFixture](https://github.com/AutoFixture/AutoFixture) | [AutoFixture](https://www.nuget.org/packages/AutoFixture/) | AutoFixture is an open source library for .NET designed to minimize the 'Arrange' phase of your unit tests in order to maximize maintainability. Its primary goal is to allow developers to focus on what is being tested rather than how to setup the test scenario, by making it easier to create object graphs containing test data. | n/a |
| [GenFu](https://github.com/MisterJames/GenFu) | [GenFu](https://www.nuget.org/packages/GenFu/) | http://genfu.io/ - GenFu is a library you can use to generate realistic test data. - see also: https://dev.to/praneetnadkar/generating-a-fake-data-in-net-core-api-3kba | n/a |
| [GenFu]() | [GenFu.HtmlHelpers.Wireframes](https://www.nuget.org/packages/GenFu.HtmlHelpers.Wireframes/) | http://genfu.io/wireframe - The ultimate code first UI/UX prototyping tool for ASP.NET Core. The GenFu Wireframes is a package that provides a fluent API that creates placeholder HTML and images at runtime using simple helper extension methods. GenFu Wireframes is specifically for reducing prototyping markup. Since GenFu injects placeholder content at runtime, your markup remains untouched and your source code remains clean.| n/a |
| [NBuilder](https://github.com/nbuilder/nbuilder) | [NBuilder](https://www.nuget.org/packages/nbuilder/) | Through a fluent, extensible interface, NBuilder allows you to rapidly create test data, automatically assigning values to properties and public fields that are one of the built in .NET data types (e.g. ints and strings). NBuilder allows you to override for properties you are interested in using lambda expressions. | n/a |

## Mocking
| GitHub | NuGet | Description | Radar Positioning |
| ------ | ----- | ----------- | ----------------- |
| [JustMockLite](https://github.com/telerik/JustMockLite) | [JustMock](https://www.nuget.org/packages/JustMock/) | The most powerful free mocking library available for .NET developers. | Assessing |
| [Prig](https://github.com/urasandesu/Prig) | [Prig](https://www.nuget.org/packages/Prig/) | Prig(PRototyping jIG) is a framework that generates a Test Double like Microsoft Fakes/Typemock Isolator/Telerik JustMock based on Unmanaged Profiler APIs. This framework enables that any methods are replaced with mocks. For example, a static property, a private method, a non-virtual member and so on. | Assessing |
| [Moq](https://github.com/moq/moq4) | [Moq](https://www.nuget.org/packages/Moq/) | Moq is the most popular and friendly mocking framework for .NET<br />Moq also is the first and only framework so far to provide Linq to Mocks | Stable |
| [NSubstitute](https://github.com/nsubstitute/NSubstitute) | [NSubstitute](https://www.nuget.org/packages/NSubstitute) | A friendly substitute for .NET mocking libraries. http://nsubstitute.github.com | Stable |

## Fuzz Testing
| GitHub | NuGet | Description | Radar Positioning |
| ------ | ----- | ----------- | ----------------- |
| [SharpFuzz](https://github.com/Metalnem/sharpfuzz) | [SharpFuzz](https://www.nuget.org/packages/SharpFuzz/) <br/> [SharpFuzz.CommandLine](https://www.nuget.org/packages/SharpFuzz.CommandLine/) | SharpFuzz is a tool that brings the power of [afl-fuzz](http://lcamtuf.coredump.cx/afl/) to .NET platform. If you want to learn more about fuzzing, my motivation for writing SharpFuzz, the types of bugs it can find, or the technical details about how the integration with afl-fuzz works, read my blog post [SharpFuzz: Bringing the power of afl-fuzz to .NET platform](https://mijailovic.net/2019/01/03/sharpfuzz/). | Incoming |

## Convention Tests
| GitHub | NuGet | Description | Radar Positioning |
| ------ | ----- | ----------- | ----------------- |
| [TestStack.ConventionTests](https://github.com/TestStack/TestStack.ConventionTests) | [TestStack.ConventionTests](https://www.nuget.org/packages/TestStack.ConventionTests/) | ConventionTests help you go beyond the compiler with conventions! | Assessing |

# Documentation
| GitHub | NuGet | Description | Radar Positioning |
| ------ | ----- | ----------- | ----------------- |
| Apistry | | | Outgoing |
| [Swashbuckle](https://github.com/domaindrivendev/Swashbuckle) | [Swashbuckle.AspNetCore](https://www.nuget.org/packages/Swashbuckle.AspNetCore/) | Swagger UI<br />Swagger tools for documenting APIs built on ASP.NET Core | Incoming |
| [postman-app-support](https://github.com/postmanlabs/postman-app-support) | n/a | [GetPostman.Com](https://www.getpostman.com/) | Outgoing |

Dropping Postman due to performance concerns. See https://github.com/postmanlabs/postman-app-support/issues?utf8=%E2%9C%93&q=is%3Aissue+is%3Aopen+label%3APerformance


See also: https://app.quicktype.io/ for automatic inference of JSON contracts from an API call

# Application Package Management
## Versioning
| GitHub | NuGet | Description | Radar Positioning |
| ------ | ----- | ---------- | ----------------- |
| [GitVersion](https://github.com/GitTools/GitVersion) | [GitVersion](https://nuget.org/GitVersion) | Easy Semantic Versioning (http://semver.org) for projects using Git | Incoming |

## Packaging and Deploying
| GitHub | NuGet | Description | Radar Positioning |
| ------ | ----- | ---------- | ----------------- |
| [Squirrel](https://github.com/Squirrel/) | [Squirrel.Windows](https://github.com/Squirrel/Squirrel.Windows)<br>[Squirrel.Mac](https://github.com/Squirrel/Squirrel.Mac)<br>[Squirrel.Server](https://github.com/Squirrel/Squirrel.Server) | An installation and update framework for Windows desktop apps<br>Cocoa framework for updating OS X apps<br>Implements the server side of the Squirrel client frameworks | Incoming |

## Plugin Management
| GitHub | NuGet | Description | Radar Positioning |
| ------ | ----- | ---------- | ----------------- |
| [DotNetCorePlugins](https://github.com/natemcmaster/DotNetCorePlugins) | n/a  | .NET Core library for loading assemblies as a plugin | Incoming |
| [Dapplo.Addons](https://github.com/dapplo/Dapplo.Addons) | [Dapplo.Addons](https://www.nuget.org/packages/Dapplo.Addons/)| Interfaces for addons loaded by Dapplo.Addons.Bootstrapper<br/> Dapplo.Addons is the plugin architecture for Greenshot screen capture utility. | Incoming |

# Command Line

## Command Line Parsing
| GitHub | NuGet | Description | Radar Positioning |
| ------ | ----- | ----------- | ----------------- |
| [FluentCommandLineParser](https://github.com/fclp/fluent-command-line-parser) | [FluentCommandLineParser](https://www.nuget.org/packages/FluentCommandLineParser/1.5.0.20-commands) | A simple, strongly typed .NET C# command line parser library using a fluent easy to use interface | Last updated 12/3/2017 :( |
| [Mono.Options]() | [Mono.Options](https://www.nuget.org/packages/Mono.Options/) | A Getopt::Long-inspired option parsing library for C#. | last updated 6/2/2017  |

## General Parsing
| GitHub | NuGet | Description | Radar Positioning |
| ------ | ----- | ----------- | ----------------- |
| [Sprache](https://github.com/sprache/Sprache) | [Sprache](https://www.nuget.org/packages/Sprache/) | Sprache is a simple, lightweight library for constructing parsers directly in C# code. | Incoming |

## Command Line Curses
| GitHub | NuGet | Description | Radar Positioning |
| ------ | ----- | ----------- | ----------------- |
| [CursesSharp](https://github.com/sushihangover/CursesSharp) | | | |

# Event Sourcing
1. https://www.nuget.org/packages/Equinox/ by jet.com, written by Erik Tsarpalis

# Data
## Data Access Layer
| GitHub | NuGet | Description | Radar Positioning |
| ------ | ----- | ----------- | ----------------- |
| [EntityFrameworkCore](https://github.com/aspnet/EntityFrameworkCore) | [Microsoft.EntityFrameworkCore](https://www.nuget.org/packages/Microsoft.EntityFrameworkCore/) | Entity Framework Core is a lightweight and extensible version of the popular Entity Framework data access technology. | Incoming |
| [EntityFrameworkCore](https://github.com/aspnet/EntityFrameworkCore) | [Microsoft.EntityFrameworkCore.SqlServer](https://www.nuget.org/packages/Microsoft.EntityFrameworkCore.SqlServer/) | Microsoft SQL Server database provider for Entity Framework Core. | Incoming |
| [NHibernate-Core](https://github.com/nhibernate/nhibernate-core) | [NHibernate](https://www.nuget.org/packages/NHibernate/) | NHibernate is a mature, open source object-relational mapper for the .NET framework. It is actively developed, fully featured and used in thousands of successful projects. | Stable |
| [Relinq](https://github.com/re-motion/Relinq) | [Remotion.Linq](https://www.nuget.org/packages/Remotion.Linq/) | re-linq Frontend: A foundation for parsing LINQ expression trees and generating queries in SQL or other languages.<br />
Key features:<br />
- Transforms expression trees into abstract syntax trees resemblying LINQ query expressions (from ... select syntax)<br />
- Simplifies many aspects of this tree (sub queries, transparent identifieres, pre-evaluation ...)<br />
- Provides basic infrastructure for backend development (e.g. SQL generation) <br />
- Provides a framework for user-defined query extensions and transformations | Assessing |

### Benchmarks
[Frans Bouma's RawDataAccessBencher](https://github.com/FransBouma/RawDataAccessBencher) provides benchmarks for:
- Dapper
- RepoDB
- Tortuga Chain
- Entity Framework Core
- LINQ to DB
- Other frameworks

### Entity Framework-specific helpers
| GitHub | NuGet | Description | Radar Positioning |
| ------ | ----- | ----------- | ----------------- |
| [EntityFramework.Guardian](https://github.com/arkoc/EntityFramework.Guardian) | [EntityFramework.Guardian](https://www.nuget.org/packages/EntityFramework.Guardian/) | EntityFramework plugin for implementing database security. | Incoming |


## Data <-> Entity Mapping
| GitHub | NuGet | Description | Radar Positioning |
| ------ | ----- | ----------- | ----------------- |
| [ValueInjecter](https://github.com/omuleanu/ValueInjecter) | [ValueInjecter](https://www.nuget.org/packages/ValueInjecter/) | convention based mapper | Stable |

## Data Migration
| GitHub | NuGet | Description | Radar Positioning |
| ------ | ----- | ----------- | ----------------- |
| [FluentMigrator](https://github.com/fluentmigrator/fluentmigrator) | [FluentMigrator](https://www.nuget.org/packages/FluentMigrator/) | Developer-centric database migrations | Stable |
| [EasyMigrator](https://bitbucket.org/quentin-starin/easymigrator/wiki/Home) | [EasyMigrator](https://www.nuget.org/packages/EasyMigrator/) | A migration and data generation tool for .NET core for working with MySql databases. | Assessing |
| [Migrator.NET](https://github.com/migratordotnet/Migrator.NET) | [MigratorDotNet](https://www.nuget.org/packages/MigratorDotNet/) | Database migrations for .NET. Based on the idea of Rails ActiveRecord Migrations. | Assessing |
| RoundHousE | | | Outgoing |

## Data Import / Export
### CSV
| GitHub | NuGet | Description | Radar Positioning |
| ------ | ----- | ----------- | ----------------- |
| [CsvHelper](https://github.com/JoshClose/CsvHelper) | [CsvHelper](https://www.nuget.org/packages/CsvHelper/) | Library to help reading and writing CSV files | Stable |

### Office (Excel)
| GitHub | NuGet | Description | Radar Positioning |
| ------ | ----- | ----------- | ----------------- |
| [NPOI](https://github.com/tonyqus/npoi) | [NPOI](https://www.nuget.org/packages/NPOI) | a .NET library that can read/write Office formats without Microsoft Office installed. No COM+, no interop. | Assessing |
| [EPPlus](https://github.com/JanKallman/EPPlus) | [EPPplus](https://www.nuget.org/packages/EPPlus/) | Create advanced Excel spreadsheets using .NET | Assessing |
| [OpenSpreadsheet](https://github.com/FolkCoder/OpenSpreadsheet) | [OpenSpreadsheet](https://www.nuget.org/packages/OpenSpreadsheet/) | A fast and efficient wrapper around the OpenXml Excel library - VERY similar to CsvHelper but for Excel | Assessing |

### Office Plug-ins (Excel)
| GitHub | NuGet | Description | Radar Positioning |
| ------ | ----- | ----------- | ----------------- |
| [excel-requests](https://github.com/ZoomerAnalytics/excel-requests) | n/a | Excel Requests is the only HTTP Addin for Excel, safe for human consumption.<br />Excel Requests is heavily inspired by Kenneth Reitz' popular Python Requests. | Assessing |
| [Excel-DNA](https://github.com/Excel-DNA/ExcelDna) | [Excel-DNA](https://www.nuget.org/packages/ExcelDna.Addin) | Excel-DNA eases the development of Excel add-ins using .NET. | Assessing |

### Data Cleansing
[OpenRefine](http://openrefine.org/) (formerly Google Refine)

### Data - OLAP
[Pentaho Mondrian](https://community.hitachivantara.com/docs/DOC-1009853)

# Serialization

## Third-party Benchmarks
### JSON
https://github.com/ngs-doo/json-benchmark

## POCO Serialization
| GitHub | NuGet | Description | Radar Positioning |
| ------ | ----- | ----------- | ----------------- |
| [MessagePack](https://github.com/neuecc/MessagePack-CSharp/) | [MessagePack](https://www.nuget.org/packages/MessagePack/) | Extremely Fast MessagePack(MsgPack) Serializer for C#(.NET, .NET Core, Unity, Xamarin). | Incoming |
| [Microsoft/Bond](https://github.com/Microsoft/bond) | [Bond.CSharp](https://www.nuget.org/packages/Bond.CSharp/) | Bond is an open source, cross-platform framework for working with schematized data. It supports cross-language serialization/deserialization and powerful generic mechanisms for efficiently manipulating data. | Incoming |
| [Ceras](https://github.com/rikimaru0345/Ceras) | Ceras | Universal binary serializer for a wide variety of scenarios https://discord.gg/FGaCX4c https://rikidev.com/ | Incoming |

## JSON Serialization
| GitHub | NuGet | Description | Radar Positioning |
| ------ | ----- | ----------- | ----------------- |
| [Utf8Json](https://github.com/neuecc/Utf8Json) | [Utf8Json](https://www.nuget.org/packages/Utf8Json/) | Fastest JSON serialization library | Incoming |
| [Newtonsoft.Json](https://github.com/JamesNK/Newtonsoft.Json) | [NewtonSoft.Json](https://www.nuget.org/packages/Newtonsoft.Json/) | Slowest but most widely supported JSON serialization library | Outgoing |

# DateTime Manipulation
| GitHub | NuGet | Description | Radar Positioning |
| ------ | ----- | ----------- | ----------------- |
| [NodaTime](https://github.com/nodatime/nodatime) | [NodaTime](https://www.nuget.org/packages/NodaTime/) | Noda Time is an alternative date and time API for .NET. It helps you to think about your data more clearly, and express operations on that data more precisely. | Incoming |

# Batch Jobs
| GitHub | NuGet | Description | Radar Positioning |
| ------ | ----- | ----------- | ----------------- |
| [Shift](https://github.com/hhalim/Shift) | [Shift](https://www.nuget.org/packages/Shift) | Durable and reliable long running and background jobs processing. Features: Detailed progress tracking. Stop, reset, and restart jobs. Scale out with multiple Shift servers. Encryption for serialized data. Run in most .NET apps, Windows services, Azure WebJobs. Auto removal of completed jobs. Can use either Redis, MongoDB, Azure DocumentDB, or Microsoft SQL Server for main storage. Free for personal and commercial use, no limit. | Incoming |

# Service Discovery
| GitHub | NuGet | Description | Radar Positioning |
| ------ | ---- | ----------- | ----------------- |
| [Consul.Net](https://github.com/PlayFab/consuldotnet) | [Consul.Net](https://www.nuget.org/packages/Consul/) | The problems Consul solves are varied, but each individual feature has been solved by many different systems. Although there is no single system that provides all the features of Consul, there are other options available to solve some of these problems. | Incoming |

See also: https://mssqlwiki.com/2012/05/04/copy-database-wizard-or-replication-setup-might-fail-due-to-broken-dependency/ for Karthick P.K - karthick krishnamurthy's script to detect invalid object references/missing dependencies. While he uses it to address replication issues, it can also be useful to run after a large database upgrade or when you first come into a company as a consultant.

# Remote Administration
| GitHub | NuGet | Description | Radar Positioning |
| ------ | ---- | ----------- | ----------------- |
| [QuasarRAT](https://github.com/quasar/QuasarRAT) | | **Free, Open-Source Remote Administration Tool for Windows**<br />
Quasar is a fast and light-weight remote administration tool coded in C#. The usage ranges from user support through day-to-day administrative work to employee monitoring. Providing high stability and an easy-to-use user interface, Quasar is the perfect remote administration solution for you.| |

# eMail
| GitHub | NuGet | Description | Radar Positioning |
| ------ | ----- | ----------- | ----------------- |
| [PreMailer.Net](https://github.com/milkshakesoftware/PreMailer.Net) | [PreMailer.Net](https://www.nuget.org/packages/PreMailer.Net/) | PreMailer.Net is a C# utility for moving CSS to inline style attributes, to gain maximum E-mail client compatibility. | Stable |
| [Papercut](https://github.com/ChangemakerStudios/Papercut) | n/a | Papercut - built on .NET. Ever need to test emails from an application, but don't necessarily want it sending them out? Don't want to hassle with pointing it to a physical SMTP server? All you want to is verify it can send email, and take a look at the message. Papercut is your answer.  | Stable |
| [MimeKit](https://github.com/jstedfast/MimeKit) | [Mimekit](https://www.nuget.org/packages/MimeKit/) | **World Class**. Not only is MimeKit's parser more robust than other .NET MIME parsers, but it's also orders of magnitude faster. Parse gigabytes of mail in seconds. | Stable |
| [MailKit](https://github.com/jstedfast/MailKit) | [MailKit](https://www.nuget.org/packages/MailKit/) | MailKit is an Open Source cross-platform .NET mail-client library that is based on MimeKit and optimized for mobile devices.<br />Microsoft recommended: https://github.com/dotnet/platform-compat/blob/master/docs/DE0005.md | Stable |

# Logging

## Better Stack Traces
- https://github.com/benaadams/Ben.Demystifier
    - Transforms a .NET Core stack trace into a C# 7.0 friendly syntax

## Just Logging

| GitHub | NuGet | Description | Radar Positioning |
| ------ | ----- | ----------- | ----------------- |
| [NLog](https://github.com/NLog/NLog) | [NLog](https://www.nuget.org/packages/NLog/) | Logs and metrics are one! | Stable |

NOTE: Some people use Serilog, but because it tries to serialize whole exception objects, this can cause nasty serialization bugs, like this one: https://github.com/aspnet/EntityFrameworkCore/issues/15214

## Just Metrics

| GitHub | NuGet | Description | Radar Positioning |
| ------ | ----- | ----------- | ----------------- |
| [Metrics.NET](https://github.com/Recognos/Metrics.NET) | [Metrics.NET](https://www.nuget.org/packages/Metrics.NET/) | Logs and metrics are one! | Incoming |


## Logging AND Metrics
| GitHub | NuGet | Description | Radar Positioning |
| ------ | ----- | ----------- | ----------------- |
| [logary](https://github.com/logary/logary) | [logary](https://www.nuget.org/packages/Logary) | Logs and metrics are one! | Incoming |
| [Its.Log](https://github.com/jonsequitur/its.log) | [Its.Log](https://www.nuget.org/packages/Its.Log/) | Get information out of your code at runtime to send it to log files, perf counters, consoles, services, sensors. Maximum flexibility and maintainability, minimum code. | Stable |

# Performance
## Tracing / Trace Analysis
| GitHub | NuGet | Description | Radar Positioning |
| ------ | ----- | ----------- | ----------------- |
| [PerfView](https://github.com/Microsoft/perfview/)  | [Microsoft.Diagnostics.Tracing.TraceEvent](https://www.nuget.org/packages/Microsoft.Diagnostics.Tracing.TraceEvent/) | Event Tracing for Windows (ETW) is a powerful logging mechanism built into the Windows OS and is used extensively in Windows. See  https://github.com/Microsoft/perfview/blob/master/documentation/TraceEvent/TraceEventLibrary.md for more. | Stable |

## Tips - Troubleshooting Slow Disk I/O in SQL Server 
https://blogs.msdn.microsoft.com/askjay/2011/07/08/troubleshooting-slow-disk-io-in-sql-server/

## Unit Testing Performance
| GitHub | NuGet | Description | Radar Positioning |
| ------ | ----- | ----------- | ----------------- |
| [xunit-performance](https://github.com/Microsoft/xunit-performance) | | | Incoming |

# Web Programming

## HTML5 Controls
| GitHub | NodeJS Module | Description | Radar Positioning |
| ------ | ------------- | ----------- | ----------------- |
| React.js | | Functional UI | Incoming |
| [learning-react](https://github.com/MoonHighway/learning-react/) | n/a | Free O'Reilly ebook: Learning React | Stable |
| [atlassian/react-beautiful-dnd](https://github.com/atlassian/react-beautiful-dnd) | [react-beautiful-dnd](https://www.npmjs.com/package/react-beautiful-dnd)| Beautiful and accessible drag and drop for lists with React | Incoming |
| [bulma](https://github.com/jgthms/bulma) | [bulma](https://www.npmjs.com/package/bulma) | Bulma is a modern CSS framework based on Flexbox. | Incoming |
| [ProseMirror](https://github.com/prosemirror) | [Monolithic ProseMirror](https://www.npmjs.com/package/prosemirror) | https://prosemirror.net/: An ideal content editor produces structured, semantically meaningful documents, but does so in a way that is easy for users to understand. ProseMirror tries to bridge the gap between Markdown text editing and classical WYSIWYG editors.<br/>It does this by implementing a WYSIWYG-style editing interface for documents more constrained and structured than plain HTML. You can customize the shape and structure of the documents your editor creates, and tailor them to your application's needs. | Assessing |
| [MetricsGraphicsJs](https://metricsgraphicsjs.org/examples.htm) | [metrics-graphics](https://www.npmjs.com/package/metrics-graphics) | MetricsGraphics.js is a library optimized for visualizing and laying out time-series data. At under 80KB (minified), it provides a simple way to produce common types of graphics in a principled and consistent way. The library currently supports line charts, scatterplots, histograms, bar charts and data tables, as well as features like rug plots and basic linear regression. | Assessing |
| [highcharts](https://www.highcharts.com/) | [highcharts](https://www.npmjs.com/package/highcharts) | Highcharts is a JavaScript charting library based on SVG, with fallbacks to VML and canvas for old browsers. This package also contains Highstock, the financial charting package, and Highmaps for geo maps. | Stable |
| [fusioncharts](https://www.fusioncharts.com/) | [fusioncharts](https://www.npmjs.com/package/fusioncharts) | FusionCharts is a JavaScript charting library providing 95+ charts and 1,400+ maps for your web and mobile applications. All the visualizations are interactive and animated, which are rendered in SVG and VML (for IE 6/7/8). | Stable |
| [kendo UI](https://www.telerik.com/kendo-ui) | [kendo](https://www.npmjs.com/package/kendo) | **Package out of date/legacy** | Stable |
 

See also: https://developers.google.com/web/updates/

## HTML5 Specifications
[HTML5 Speech Recognition](http://stephenwalther.com/archive/2015/01/05/using-html5-speech-recognition-and-text-to-speech)

## HTML Archive/Replay
| GitHub | NodeJS Module | Description | Radar Positioning |
| ------ | ------------- | ----------- | ----------------- |
| [HarSharp](https://github.com/giacomelli/HarSharp) | [HarSharp](https://www.nuget.org/packages/HarSharp/) | A small and easy-to-use library to parse HTTP Archive (HAR) format to .NET objects. | Stable |

Cerebral, MobX, Redux, atom-react, Redux-saga

# SQL

## SQL Server Reporting Services
| GitHub | PSGallery | Description | Radar Positioning |
| ------ | ---- | ----------- | ----------------- |
| [ReportingServicesTools](https://github.com/Microsoft/ReportingServicesTools/) | [ReportingServicesTools](https://www.powershellgallery.com/packages/ReportingServicesTools/) | Provides extra functionality for SSRS (SQL Server Reporting Services). | Incoming |

## Administrative Scripts
| GitHub | Blog | Description | Radar Positioning |
| ------ | ---- | ----------- | ----------------- |
| [sql-server-maintenance-solution](https://github.com/olahallengren/sql-server-maintenance-solution) | https://ola.hallengren.com/ | The SQL Server Maintenance Solution comprises scripts for running backups, integrity checks, and index and statistics maintenance on all editions of Microsoft SQL Server 2005, SQL Server 2008, SQL Server 2008 R2, SQL Server 2012, SQL Server 2014, SQL Server 2016, and SQL Server 2017. | Stable |
| [CISL](https://github.com/NikoNeugebauer/CISL) | na | Microsoft SQL Server Columnstore Indexes Scripts Library | Incoming |
| [sqlserver-kit](https://github.com/ktaranov/sqlserver-kit) | na | Useful links, scripts, tools and best practice for Microsoft SQL Server Database http://sqlserver-kit.org | Incoming |
| [dbachecks](https://github.com/sqlcollaborative/dbachecks) | https://dbachecks.io | SQL Server Environmental Validation | Incoming |
See also: http://www.sqlservercentral.com/scripts/change+index+name/70054/ for Michael Søndergaard's SQLServerCentral.com article _Fix Index Naming_ from 2010/10/11.
See also https://github.com/sqlcollaborative/dbachecks

## Maintenance Tools
Data Migration Assistant https://docs.microsoft.com/en-us/sql/dma/dma-overview?view=sql-server-2017
https://www.microsoft.com/en-us/download/details.aspx?id=53595

```
EXECUTE dbautils.spFixIndexNaming
```

# Software Licensing
| GitHub | NuGet | Description | Radar Positioning |
| ------ | ------------- | ----------- | ----------------- |
| [Portable.Licensing](https://github.com/dnauck/Portable.Licensing) | [Portable.Licensing](https://www.nuget.org/packages/Portable.Licensing/) | Portable.Licensing is a cross platform software licensing framework which allows you to implement licensing into your application or library. It provides you all tools to create and validate licenses for your software.<br/>Portable.Licensing is using the latest military strength, state-of-the-art cryptographic algorithm to ensure that your software and thus your intellectual property is protected. | Stable |

# Color / ANSI Escape Codes
| GitHub | NuGet | Description | Radar Positioning |
| ------ | ------------- | ----------- | ----------------- |
| [Colourful](https://github.com/tompazourek/Colourful) | | Open source .NET library for working with color spaces. | Incoming |
| [Pastel](https://github.com/silkfire/Pastel) | | Snazz up your console output! | Incoming |
| [crayon](https://github.com/riezebosch/crayon) | | An easy peasy tiny library for coloring console output in inline strings using ANSI escape codes. | Incoming |


# Backup Software
| GitHub | NuGet | Description | Radar Positioning |
| ------ | ------------- | ----------- | ----------------- |
| [AlphaVSS](https://github.com/alphaleonis/AlphaVSS/) | [AlphaVSS](https://www.nuget.org/packages/AlphaVSS/) | Windows only. Wrapper for COM Volume Shadow Copy service API. See also: https://alphavss.alphaleonis.com/ | Stable |

# R / Python  Statistics Projects
| GitHub | Project Page | Description | Radar Positioning |
| ------ | ------------- | ----------- | ----------------- |
| [stylo](https://github.com/computationalstylistics/stylo) | [computationalstylistics](https://computationalstylistics.github.io/) | R package for stylometric analyses | Assessing |
| [PyStyl](https://github.com/mikekestemont/pystyl) | ? | Python package for stylometry | Assessing |
| BeautifulSoup | ? | ? | ? |

# PowerShell

## Basic Utilities

| GitHub | PSGallery | Description | Radar Positioning |
| ------ | ------------- | ----------- | ----------------- |
| [WFTools](https://github.com/RamblingCookieMonster/PowerShell) | [WFTools](https://www.powershellgallery.com/packages/WFTools/0.1.58) | Various PowerShell functions and scripts<br>* Import-PSCredential<br>* Export-PSCredential | Stable |
| [PPoShTools](https://github.com/PPOSHGROUP/PPoShTools) | [PPoShTools](https://www.powershellgallery.com/packages/PPoShTools) | Various PowerShell functions and scripts<br>* Write-ErrorRecord | Incoming |
| [BAMCIS.CredentialManager](https://github.com/bamcisnetworks/BAMCIS.CredentialManager) | [BAMCIS.CredentialManager](https://www.powershellgallery.com/packages/BAMCIS.CredentialManager/1.0.0.0) | Provides a wrapper around the Credential Manager Win32 API. | Stable |
| [PSSE](https://github.com/ahhh/PSSE) | - | PowerShell Scripting Expert repository, contains template code for security and administrative scripting, largely derived through taking the SecurityTube PowerShell for Pentesters course | Incoming |
| [nishang](https://github.com/samratashok/nishang) | - | Nishang - Offensive PowerShell for penetration testing and offensive security. | Incoming |
| [PSScriptAnalyzer](https://github.com/PowerShell/PSScriptAnalyzer) | [PSScriptAnalyzer](https://www.powershellgallery.com/packages/PSScriptAnalyzer/1.17.1) | | |
| [PowerBolt](https://github.com/marckassay/PowerBolt) | [PowerBolt](https://www.powershellgallery.com/packages/PowerBolt) | PowerBolt is to quickly create, develop, test, document and publish modules | Assessing |

See also: https://www.shelltools.net/

# Certifications

| Certificate Owner | Certificate Name | Description | Website |
| ----------------- | ---------------- | ----------- | ------- |
| Microsoft | Exam 70-741 | Networking with Windows Server 2016 | https://www.microsoft.com/en-us/learning/exam-70-741.aspx |

# Performance

http://techgenix.com/Key-Performance-Monitor-Counters/

# Security

## Group MSA (gMSA) Accounts
Group MSA Accounts are a great way to avoid using passwords for service accounts. However, they can be:
  a) Painful to set-up.
  b) Painful to change or undo.
  c) Even more pain when changing SQL Server to run as a gMSA. - Use SQL Server Configuration Manager rather than directly changing Windows Local Services!

## Identity Management

| GitHub | NA | Description | Radar Positioning |
| ------ | -- | ----------- | ----------------- |
| [ritterim/stuntman](https://github.com/ritterim/stuntman) | NA | Mock ASP.NET Identity Management live in the browser. Like Glimpse for identity. | Incoming |


# kdb

## Libraries
| GitHub | NA | Description | Radar Positioning |
| ------ | -- | ----------- | ----------------- |
| [AquaQAnalytics/TorQ](https://github.com/AquaQAnalytics/TorQ) | NA | - | Incoming |

## C# Client
| GitHub | NA | Description | Radar Positioning |
| ------ | -- | ----------- | ----------------- |
| [exxeleron/qSharp](https://github.com/exxeleron/qSharp) | NA | - | Incoming |

# Quick PowerShell Snippets
## Fusion logging
### .NET Framework (Legacy)
```powershell
Set-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Fusion\ -Name EnableLog -Value 1
```
### .NET Core (New)
Note: See issue I logged for problems with .NET Core tracing https://github.com/dotnet/coreclr/issues/24035
```powershell
setx CORE_HOSTTRACE 1
```

## ASP.NET Core Host Environment
https://andrewlock.net/how-to-set-the-hosting-environment-in-asp-net-core/
```powershell
setx ASPNETCORE_ENVIRONMENT "Development"
```


# Build Server Plug-ins
| GitHub | Description | Radar Positioning |
| ------ | ----------- | ----------------- |
| [teamcity-runas-plugin](https://github.com/JetBrains/teamcity-runas-plugin) | The teamcity-runas plugin to run TeamCity build steps under a specified user account on Windows or Linux. | Stable |
| [FluentTc](https://github.com/QualiSystems/FluentTc) | Integrate with TeamCity fluently | Assessing |

https://blogs.technet.microsoft.com/mist/2018/02/14/windows-authentication-http-request-flow-in-iis/

# Duplicate File Finder
https://github.com/adrianlopezroche/fdupes
https://github.com/jbruchon/jdupes

# Productivity Power Packs
https://github.com/digitalcreations/MaxTo/issues - for multi monitor displays

# Amazon RDS
https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Appendix.SQLServer.CommonDBATasks.html
