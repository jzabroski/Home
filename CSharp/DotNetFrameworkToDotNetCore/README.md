https://www.cafe-encounter.net/p2380/migrating-net-framework-to-netcore

https://www.paraesthesia.com/archive/2018/06/20/microsoft-extensions-configuration-deep-dive/
- Be careful of xml configuration elements with the `Name` keyword.
- Make sure you validate your configuration values.
- You can specify configuration as environment variables! Since `:` doesn’t work well in environment variables in all systems, you use `__` in the actual environment variable and it will get converted.
