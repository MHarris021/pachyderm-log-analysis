function(inputPipeline, imageVersion)
{
    "pipeline" : {
        "name": "combine-log-analysis",
    },
    "description": "Combine log analysis json files into a single json formatted file",
    "input" : {
        "pfs" : {
            "repo" : inputPipeline,
            "branch" : "master",
            "glob" : "/logs/"
        }
    },
    "transform" : {
        "image": "darcstarsolutions/pachyderm-log-analyzer:"+imageVersion,
        "cmd" : [ "bash" ],
        "stdin" : [
            "./combine-log-analysis.sh"+ " " + "/pfs/"+inputPipeline+"/logs" +" "+ "/pfs/out"
            ]
    }
}
