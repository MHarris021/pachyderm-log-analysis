function(pipeline1, pipeline2, imageTag)
{
    "pipeline" : {
        "name": "log-analyzer-reducer"

    },
    "description":"This pipeline reduces the log analysis json data into a single file from pipelines: "+pipeline1 + " and " + pipeline2,
    "input" : {
        "join":[
        {
            "pfs" : {
                "repo" : pipeline1,
                "branch" : "master",
                "glob" : "/logs/(*)-analysis.json",
                "join_on": "$1"
                }
        },
        {
            "pfs" : {
                "repo" : pipeline2,
                "branch" : "master",
                "glob" : "/logs/(*)-analysis.json",
                "join_on": "$1"
            },
        }
        ],
    },
    "transform" : {
        "image": imageTag,
        "cmd" : [ "bash" ],
        "stdin" : [
            "./reduce-analysis-files.sh" + " " + "/pfs/"+pipeline1+"/logs" + " " + "/pfs/"+pipeline2+"/logs" + " " + "/pfs/out"
            ]
    }
}
