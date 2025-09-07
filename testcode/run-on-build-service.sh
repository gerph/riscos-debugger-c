#!/bin/bash
##
# Run on the build service
#

set -e
set -o pipefail

quiet=false
if [[ "$1" == '--quiet' ]] ; then
    quiet=true
    shift
fi

#quiet=false

# We're running only AArch32 at the moment
arch=aarch32

# How long each job runs for
timeout=30

# Files we will archive
files=(Debugger,ffa
       bin/hello_world,ffc
       bin/debugger,ffc
       bin/debugger_thumbcode,ffc
       testdata
      )


# We want to turn all the pyro switches into things that can be run inside the Build service.
# The switches look like this:
#   --command "riscos command"
#   --config pyrosection.option=value
# We need to turn these into something like:
#   echo *** Run riscos command
#   riscos command
#
#   echo *** Configure pyrosection.option=value
#   pyromaniacconfig pyrosection.option=value
#

lines=()

tail_command=
nextarg=
while [[ $# -gt 0 ]] ; do
    #echo "Checking $1 (nextarg=$nextarg)"

    if [[ "$nextarg" == 'command' ]] ; then
        if ! $quiet ; then
            lines+=("echo *** Run $1")
        fi
        lines+=("$1")
        nextarg=
    elif [[ "$nextarg" == 'config' ]] ; then
        if ! $quiet ; then
            lines+=("echo *** Configure $1")
        fi
        lines+=("PyromaniacConfig $1")
        nextarg=
    else
        if [[ "$1" == '--command' ]] ; then
            nextarg=command
        elif [[ "$1" == '--config' ]] ; then
            nextarg=config
        elif [[ "${1:0:2}" == '--' ]] ; then
            echo "Unsupported switch '$1'" >&2
            exit 1
        else
            tail_command="$tail_command $1"
        fi
    fi
    shift
done

if [[ "$tail_command" != '' ]] ; then
    lines+=("${tail_command:1:${#tail_command}}")
fi

if [[ -x './riscos-build-online' ]] ; then
    build_tool="./riscos-build-online"
elif type -p riscos-build-online > /dev/null 2>/dev/null ; then
    build_tool=$(type -p riscos-build-online)
else
    echo "The 'riscos-build-online' tool is required to run these tests" >&2
    exit 1
fi

    # Header
cat > .robuild.yaml <<EOM
%YAML 1.0
---

# Defines a list of jobs which will be performed.
# Only 1 job will currently be executed.
jobs:
  build:
    # Env defines system variables which will be used within the environment.
    # Multiple variables may be assigned.
    env:
      "Sys\$Environment": ROBuild

    # Directory to change to before running script
    dir: "${dir}"

    # Commands which should be executed to perform the build.
    # The build will terminate if any command returns a non-0 return code or an error.
    script:
      - PyromaniacDebug traceblock
EOM

# Load the module
line="RMLoad Debugger"
if ! $quiet ; then
    echo "      - echo *** Load module" >> .robuild.yaml
    echo "      - echo ***   $line" >> .robuild.yaml
fi
echo "      - $line" >> .robuild.yaml

# Run the necessary command
for line in "${lines[@]}" ; do
    echo "      - $line" >> .robuild.yaml
done

build_args=()
if $quiet ; then
    build_args+=(-q)
fi

# Archive the files we want
zip -q9r /tmp/testrun.zip "${files[@]}" .robuild.yaml

if [[ -t 0 ]] ; then
    function tidy_output() {
        sed -E -e "s/\r\r/\r/g"
    }
else
    function tidy_output() {
        sed -E -e "s/\r//g"
    }
fi

# And send it off to the build system
if "$build_tool" "${build_args[@]}" -a off -A "$arch" -t "$timeout" -i /tmp/testrun.zip | tidy_output ; then
    rc=0
else
    rc=$?
fi

# We don't need the build file any more
rm .robuild.yaml

exit "$rc"
