"""
Node structure for the fixed transportation problem.
Defined by a stock and a demand
"""
mutable struct Node
    name::String
    stock::Int
    demand::Int
    type ::Char

    function Node(name::String, stock::Int, demand::Int)
        if stock < 0 || demand < 0
            throw(ArgumentError("Stock and demand must be non-negative integers."))
        end

        if !isa(name, String)
            throw(ArgumentError("Name must be a string."))
        end

        if stock >0 && demand == 0
            type = 'S'  # Supply node
        elseif stock == 0 && demand > 0
            type = 'D'  # Demand node
        else
            type = 'M'  # Mixture node
        end

        new(name, stock, demand, type)
    end

end
function Base.show(io::IO, node::Node)
    print(io, "\tNode($(node.name), stock=$(node.stock), demand=$(node.demand), type = $(node.type) )\n")
end

"""
Arc structure for the fixed transportation problem.
Defined by a stock and a demand
"""
mutable struct Arc
    origin::Node
    destination::Node
    fixed_cost::Float64
    variable_cost::Float64
end
function Base.show(io::IO, arc::Arc)
    print(io, "\tArc(origin=$(arc.origin.name), destination=$(arc.destination.name), fixed_cost=$(arc.fixed_cost), variable_cost=$(arc.variable_cost))\n")
end

"""
Network structure for the fixed transportation problem.
Contains nodes and arcs.
"""
mutable struct Network
    instance_name::String
    nodes::Dict{String,Node}
    arcs::Vector{Arc}
end
function Base.show(io::IO, network::Network)
    print(io, "------ Network from instance $(network.instance_name)------\n")

    print(io, "Nodes:\n")
    for (i,node) in network.nodes
        print(io, "\tNode $(i): stock=$(node.stock), demand=$(node.demand), type=$(node.type)\n")
    end

    print(io, "Arcs:\n")
    for arc in network.arcs
        print(io, "\tArc ($(arc.origin.name), $(arc.destination.name)): fixed_cost=$(arc.fixed_cost), variable_cost=$(arc.variable_cost)\n")
    end
    print(io, "---------------------------------\n")
end 

"""
Solution structure for the fixed transportation problem.
Contains Network, objective value, and solution vectors x and y.
"""
mutable struct FTPSolution
    network::Network
    objective_value::Float64
    x::Vector{Int}
    y::Vector{Int}
end

function Base.show(io::IO, solution::FTPSolution)
    print(io, "------ Solution of the FTP problem, for the instance $(solution.network.instance_name) ------ \n")

    print(io, "Objective value: $(solution.objective_value)\n")
    fixed_cost = sum(arc.fixed_cost * solution.y[i] for (i, arc) in enumerate(solution.network.arcs))
    variable_cost = sum(arc.variable_cost * solution.x[i] for (i, arc) in enumerate(solution.network.arcs))
    print(io, "\tfixed cost: $fixed_cost, variable cost: $variable_cost\n")

    print(io, "Arcs : \n")
    for (i, arc) in enumerate(solution.network.arcs)
        print(io, "\t$(arc.origin.name) -> $(arc.destination.name): x : $(solution.x[i]), y : $(solution.y[i])\n")
    end

    print(io, "Variables values :\n\t x:$(solution.x)\n \t y:$(solution.y)\n")

    print(io, "---------------------------------\n")
end 
