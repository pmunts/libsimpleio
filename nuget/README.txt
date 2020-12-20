                            NuGet Local Package Feed

   Here is a local snapshot of the [1]NuGet packages necessary to build
   [2].Net applications using the Linux Simple I/O Library or the Remote
   I/O Protocol Library without Internet access.

   In order to use this local package feed, you will need to manually add
   an entry to the packageSources block in the file NuGet.Config (found at
   $HOME/.config/NuGet/NuGet.Config on Linux or
   %HOMEDRIVE%%HOMEPATH%\AppData\Roaming\NuGet\NuGet.Config on Windows).
   You should also comment out the entry for nuget.org, especially if you
   need to build .Net applications offline from the Internet.

Windows Example NuGet.Config:

...
  <packageSources>
    <!-- <add key="nuget.org" value="https://api.nuget.org/v3/index.json" protocolVersion="3" /> -->
    <add key="libsimpleio local feed" value="C:\Users\fred\libsimpleio\nuget\" />
  </packageSources>
...

Linux Example NuGet.Config:

...
  <packageSources>
    <!-- <add key="nuget.org" value="https://api.nuget.org/v3/index.json" protocolVersion="3" /> -->
    <add key="libsimpleio local feed" value="/usr/local/share/libsimpleio/nuget/" />
  </packageSources>
...
   _______________________________________________________________________

   Questions or comments to Philip Munts [3]phil@munts.net

   I am available for custom system development (hardware and software) of
   products using ARM Linux or other microcomputers.

References

   1. https://www.nuget.org/
   2. https://dotnet.microsoft.com/
   3. mailto:phil@munts.net
