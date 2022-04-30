function(pipeline1, pipeline2, imageVersion)
{
    "pipeline" : {
        "name": "log-analyzer-reducer",
    },
    "input" : {
        "join":[
        {
            "pfs" : {
                "repo" : pipeline1,
                "branch" : "master",
                "glob" : "/*-analysis.json",
                "join_on": "$1"
                }
        },
        {
            "pfs" : {
                "repo" : pipeline2,
                "branch" : "master",
                "glob" : "/*-analysis.json",
                "join_on": "$1"
            },
        }
        ],
    },
    "transform" : {
        "image": "darcstarsolutions/pachyderm-log-analyzer:"+imageVersion,
        "cmd" : [ "bash" ],
        "stdin" : [
            "./reduce-analysis-files.sh " + "/pfs/"+pipeline1 + " " + "/pfs/"+pipeline2 + " " + "/pfs/out"
            ]
    }
}
