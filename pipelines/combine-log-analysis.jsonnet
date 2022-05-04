function(inputPipeline, imageTag)
{
    "pipeline" : {
        "name": "combine-log-analysis",
    },
    "description": "This pipeline combines log analysis json files from "+inputPipeline+" into a single json formatted file",
    "input" : {
        "pfs" : {
            "repo" : inputPipeline,
            "branch" : "master",
            "glob" : "/logs/"
        }
    },
    "transform" : {
        "image": imageTag,
        "cmd" : [ "bash" ],
        "stdin" : [
            "./combine-log-analysis.sh"+ " " + "/pfs/"+inputPipeline+"/logs" +" "+ "/pfs/out"
            ]
    }
}
