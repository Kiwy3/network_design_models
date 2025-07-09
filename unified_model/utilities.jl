using JSON

""" read any JSON file and return a parsed object """
function read_json(file :: String) :: Dict
    open(file,"r") do f
        return JSON.parse(f)
    end
end

function load_instance(instance_name::String, problem :: McndProblem )::McndInstance
    # Load the JSON file
    json_data = read_json(instance_name)

    # Extract nodes and arcs from the JSON data
    nodes = [McndNode("node_$(i)") for i in 1:json_data["number_of_nodes"]]

    arcs = [McndArc(arc[7],nodes[arc[1]], nodes[arc[2]],arc[5], arc[3], arc[4]) 
        for arc in json_data["arcs"]]

    commodities = [McndCommodity(nodes[commodity[1]], nodes[commodity[2]], commodity[3]) 
        for commodity in json_data["commodities"]]

    instance = McndInstance(instance_name,nodes, arcs, commodities)
    # Create and return the network object
    return instance
end


function load_instance(instance_name::String, problem :: FtpProblem )::FtpInstance
    # Load the JSON file
    json_data = read_json(instance_name)

    # Extract nodes and arcs from the JSON data
    nodes = Dict(node[1] => FtpNode(node[1], node[2],node[3])
        for node in json_data["nodes"])

    arcs = [FtpArc(nodes[arc[1]], nodes[arc[2]],arc[3], arc[4]) 
        for arc in json_data["arcs"]]

    instance = FtpInstance(instance_name,nodes, arcs)
    # Create and return the network object
    return instance
end