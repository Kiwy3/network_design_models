using JSON

""" read any JSON file and return a parsed object """
function read_json(file)
    open(file,"r") do f
        return JSON.parse(f)
    end
end

function load_ftp_instance(instance_name::String)
    # Load the JSON file
    json_data = read_json(instance_name)

    # Extract nodes and arcs from the JSON data
    nodes = Dict(node[1] => Node(node[1], node[2],node[3])
        for node in json_data["nodes"])

    arcs = [Arc(nodes[arc[1]], nodes[arc[2]],arc[3], arc[4]) 
        for arc in json_data["arcs"]]

    instance = Network(instance_name,nodes, arcs)
    # Create and return the network object
    return instance
end
