function(searchTerm, suffix, imageTag)
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
        "image": imageTag,
        "cmd" : [ "bash" ],
        "stdin" : [
            "./analyze-file.sh"+ " " + searchTerm + " "+ "/pfs/logs" +" "+ "/pfs/out"
            ]
    }
}
