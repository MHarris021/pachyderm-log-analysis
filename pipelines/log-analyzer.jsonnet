function(searchTerm, suffix, imageTag)
{
    "pipeline" : {
        "name": "log-analyzer-"+suffix,
    },
    "description": "This is the pipeline to search a log file for "+searchTerm +" and return the number of times it appears",
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
