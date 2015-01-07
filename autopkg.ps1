# Win-AutoPkg - simple AutoPkg-like functionality for Windows
#
# Based loosely on the AutoPkg project:
# https://github.com/autopkg
# Some functions, variables, comments, strings and logic are taken and 
# implemented in PowerShell
# AutoPkg is Copyright Per Olofsson
# AutoPkg is licensed under the Apache License 2.0, see:
# https://github.com/autopkg/autopkg/blob/master/LICENSE.txt
#
param(
    [Parameter(Position = 0)]
    [String[]]
    $SubCommand,
    [alias("id")]
    [String[]]
    $Identifier,
    [alias("cache-dir")]
    [String[]]
    $CacheDir = Join-Path $env:temp 'cache',
    [alias("recipe-dir")]
    [String[]]
    $RecipeDir
)

# Simplify yaml usage in PowerShell
Import-Module '.\PowerYaml\PowerYaml.psm1'

# SubCommands 
$SubCommands = @{
    'help'=@{
        'function'='display_help'
        'help'='Display this help'}
    'info'=@{
        'function'='get_info'
        'help'='Get info about configuration or a recipe'}
    'list-recipes'=@{
        'function'='list_recipes'
        'help'='List recipes available locally'}
    'list-processors'=@{
        'function'='list_processors'
        'help'='List available core Processors'}
    'make-override'=@{
        'function'='make_override'
        'help'='Make a recipe override'}
    'processor-info'=@{
        'function'='processor_info'
        'help'='Get informatation about a specific processor'}
    'repo-add'=@{
        'function'='repo_add'
        'help'='Add one or more recipe repo from a URL'}
    'repo-delete'=@{
        'function'='repo_delete'
        'help'='Delete a recipe repo'}
    'repo-list'=@{
        'function'='repo_list'
        'help'='List installed recipe repos'}
    'repo-update'=@{
        'function'='repo_update'
        'help'='Update one or more recipe repos'}
    'run'=@{
        'function'='run_recipes'
        'help'='Run one or more recipes'}
    'search'=@{
        'function'='search_recipes'
        'help'='Search for recipes on GitHub.'}
    'version'=@{
        'function'='print_version'
        'help'='Print the current version of autopkg'}
}

$ScriptDirectory = Split-Path $script:MyInvocation.MyCommand.Path
# Recipe search list
$SearchDirs = '.', "~\AutoPkg\Recipes", "$ScriptDirectory\Recipes"
# If defined, add custom recipe directory
if (Test-Path variable:global:RecipeDir) {
    $SearchDirs += $RecipeDir
}

# Display top-level help
Function display_help($Verb) {
    if (!$Verb -eq 'help') {
        #
    } else {
        Write-Host "Usage: $ScriptDirectory <verb> <options>, where <verb> is one of the following:"
        Write-Host " "
        # find length of longest subcommand for padding purposes
        $MaxKeyLength = ($SubCommands.Keys | Measure-Object -Maximum -Property Length).Maximum
        $SubCommands.Keys | foreach {
            $Command = $_
            $CommandLength = ($Command | Measure-Object -Maximum -Property Length).Maximum
            Write-Host "    $Command ($SubCommands.$Command.help)"
        }
        Write-Host "$ScriptDirectory <verb> --help for more help for that verb"
    }
}

# Check if a subcommand is defined or not
if (!Test-Path variable:global:SubCommand) {
    $Verb = 'help'
} else {
    $Verb = $SubCommand
}

# Check if help is called on a subcommand
if ( ($Verb -NotLike "help") -and ($args[1] -like "*help*")) {
    if ($SubCommands -NotContains $SubCommand) {
        $Verb = 'help'
    } else {
        display_help($Verb)
    }
}
if ($Verb -eq 'help') {
    display_help($Verb)
}

# Return identifier from recipe yaml using the Identifier key
Function get_identifier($RecipeYaml) {
    try {
        return $RecipeYaml.Identifier
    }
    catch {
        Write-Host $_.Exception | format-list -force
        return $null
    }
}

# Attempts to read a yaml file filename and get the identifier. Otherwise returns null
Function get_identifer_from_recipe_file($filename) {
    try {
        # Make sure we can read the file
        $RecipeYaml = Get-Yaml -FromFile (Resolve-Path $filename)
    }
    catch {
        Write-Host $_.Exception | format-list -force
        return $null
    }
    return get_identifier($RecipeYaml)
}

# Search search_dirs for a recipe with the given identifier
Function find_recipe_by_identifier($Identifier, $SearchDirs) {
    $search_dirs | foreach {
        $patterns = (Join-Path $_ '*.recipe'), (Join-Path $_ '*\*.recipe')
        $patterns | foreach {
            if ((get_identifer_from_recipe_file $_) -eq $identifier) {
                return $_
            }
        }
    }
}

# Gets the version number of autopkg
Function get_autopkg_version() {
    try {
        $VersionFile = Get-Yaml -FromFile (Resolve-Path (Join-Path ($ScriptDirectory) "version.yaml"))
    }
    catch {
        Write-Host $_.Exception | format-list -force
        return "UNKNOWN"
    }
    try {
        return $VersionFile.Version
    }
    catch {
        Write-Host $_.Exception | format-list -force
        return "UNKNOWN"
    }
}

# Instantiate and execute processors from a recipe.
Function AutoPackager($Identifier) {
    # Create cache directory if it doesn't exist
    if(!Test-Path -Path $CacheDir) {
        New-Item -Path $CacheDir -ItemType directory
    }
    # Create recipe cache directory if it doesn't exist
    if(!Test-Path -Path "$CacheDir\$Identifier") {
        New-Item -Path "$CacheDir\$Identifier" -ItemType directory
    }
    
}
