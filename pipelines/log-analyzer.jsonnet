function(searchTerm, suffix, imageVersion)
{
    "pipeline" : {
        "name": "log-analyzer-"+suffix,
    },
    "description": "Log analyzer for "+searchTerm,
    "input" : {
        "pfs" : {
            "repo" : "logs",
            "branch" : "master",
            "glob" : "/*.log"
        }
    },
    "transform" : {
        "image": "darcstarsolutions/pachyderm-log-analyzer:"+imageVersion,
        "cmd" : [ "bash" ],
        "stdin" : [
            "./analyze-file.sh"+ " " + searchTerm + " "+ "/pfs/logs" +" "+ "/pfs/out"
            ]
    }
}
