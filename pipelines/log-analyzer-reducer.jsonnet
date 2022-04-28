function(phrase, suffix)
{
    "pipeline" : {
        "name": "log-analyzer-"+suffix,
    },
    "input" : {
        "pfs" : {
            "repo" : "logs",
            "branch" : "master",
            "glob" : "/*.log"
        }
    },
    "transform" : {
        "image": "darcstarsolutions/pachyderm-log-analyzer:1.0.1",
        "cmd" : [ "bash" ],
        "stdin" : [
            "./analyze-file.sh " + phrase
            ]
    }
}
