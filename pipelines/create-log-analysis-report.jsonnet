function(inputPipeline, imageTag)
{
    "pipeline" : {
        "name": "create-log-analysis-report",
    },
    "description": "Create human readable combined log analysis report file from a single json formatted file",
    "input" : {
        "pfs" : {
            "repo" : inputPipeline,
            "branch" : "master",
            "glob" : "/"
        }
    },
    "transform" : {
        "image": imageTag,
        "cmd" : [ "bash" ],
        "stdin" : [
            "./create-log-analysis-report.sh"+ " " + "/pfs/"+inputPipeline +" "+ "/pfs/out"
            ]
    }
}
