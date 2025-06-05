function remGenericmapper()
  
  --sysInstallPackage
  -- remove generic_mapper

  --Check if the generic_mapper package is installed and if so uninstall it
  if table.contains(getPackages(),"generic_mapper") then
    tempTimer(1, [[ uninstallPackage("generic_mapper") ]])
    cecho("<red>[sysInstallPackage: Removing generic_mapper...]\n")
    tempTimer(2, [[initNyyMAP()]])
    return
  end

  -- generic_mapper not installed, call map setup function
  initNyyMAP()
end
