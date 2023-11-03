NuGet Local Package Feed
========================

Here is a local snapshot of the [NuGet](https://www.nuget.org) packages
necessary to build [.Net](https://dotnet.microsoft.com) applications
using the **Linux Simple I/O Library** or the **Remote I/O Protocol
Library** without Internet access.

In order to use this local package feed, you will need to manually add
an entry to the **`packageSources`** block in the file
**`NuGet.Config`** (found at **`$HOME/.config/NuGet/NuGet.Config`** on
Linux or **`%HOMEDRIVE%%HOMEPATH%\AppData\Roaming\NuGet\NuGet.Config`**
on Windows). You should also comment out the entry for **`nuget.org`**,
especially if you need to build .Net applications offline from the
Internet.

Windows Example NuGet.Config:
-----------------------------

    ...
      <packageSources>
        <!-- <add key="nuget.org" value="https://api.nuget.org/v3/index.json" protocolVersion="3" /> -->
        <add key="libsimpleio local feed" value="C:\Users\fred\libsimpleio\nuget\" />
      </packageSources>
    ...

Linux Example NuGet.Config:
---------------------------

    ...
      <packageSources>
        <!-- <add key="nuget.org" value="https://api.nuget.org/v3/index.json" protocolVersion="3" /> -->
        <add key="libsimpleio local feed" value="/usr/local/share/libsimpleio/nuget/" />
      </packageSources>
    ...

------------------------------------------------------------------------

Questions or comments to Philip Munts <phil@munts.net>
