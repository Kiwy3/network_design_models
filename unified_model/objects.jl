#ANCHOR - MCND objects
"""
Node structure for the Multi-commodity Fixed-charge Capacitated Network Design Problem.
Defined by a name
"""
struct McndNode
    name::String
end
function Base.show(io::IO, node::McndNode)
    print(io, "Node $(node.name)")
end

"""
Arc structure for the Multi-commodity Fixed-charge Capacitated Network Design Problem.
Defined by 
"""
struct McndArc
    index::Int
    origin::McndNode
    destination::McndNode
    fixed_cost::Float64
    variable_cost::Float64
    capacity::Int
end
function Base.show(io::IO, arc::McndArc)
    print(io, "\tArc(origin=$(arc.origin.name), destination=$(arc.destination.name), fixed_cost=$(arc.fixed_cost), variable_cost=$(arc.variable_cost))\n")
end

"""
Commodity structure for the Multi-commodity Fixed-charge Capacitated Network Design Problem.\n
Defined by origin and destination nodes, and demand.
"""
struct McndCommodity 
    origin::McndNode
    destination::McndNode
    demand::Int
end

function Base.show(io::IO, commodity::McndCommodity)
    print(io, "Commodity from $(commodity.origin.name) to $(commodity.destination.name) with demand $(commodity.demand)\n")
end


"""Instance structure for the Multi-commodity Fixed-charge Capacitated Network Design Problem.
Contains instance name, nodes, arcs, and commodities.
"""
struct McndInstance
    name::String
    nodes::Vector{McndNode}
    arcs::Vector{McndArc}
    commodities::Vector{McndCommodity}
end
function Base.show(io::IO, instance::McndInstance)
    print(io, "------ Network from instance $(instance.name)------\n")

    print(io, "Nodes: $(instance.nodes)\n")

    print(io, "Arcs:\n")
    for arc in instance.arcs
        print(io, "\tArc ($(arc.origin.name), $(arc.destination.name)): f_cost=$(arc.fixed_cost), v_cost=$(arc.variable_cost), capa=$(arc.capacity)\n")
    end

    print(io, "Commodities:\n")
    for commodity in instance.commodities
        print(io, "\tCommodity : o/d=($(commodity.origin.name), $(commodity.destination.name)), quantity=$(commodity.demand)\n")
    end


    print(io, "---------------------------------\n")
end 


"""
Solution structure for the Multi-commodity Fixed-charge Capacitated Network Design Problem.
Contains Network, objective value, and solution vectors x and y.
"""
struct McndSolution
    instance::McndInstance
    objective_value::Float64
    x::Matrix{Float64}
    y::Vector{Int}
end

function Base.show(io::IO, solution::McndSolution)
    print(io, "------ Solution of the FTP problem, for the instance $(solution.instance.name) ------ \n")

    print(io, "Objective value: $(solution.objective_value)\n")
    fixed_cost = sum(arc.fixed_cost * solution.y[i] for (i, arc) in enumerate(solution.instance.arcs))
    variable_cost = sum(arc.variable_cost * solution.x[i] for (i, arc) in enumerate(solution.instance.arcs) for k in solution.instance.commodities)
    print(io, "\tfixed cost: $fixed_cost, variable cost: $variable_cost\n")

    print(io, "Arcs : \n")
    for (i, arc) in enumerate(solution.instance.arcs)
        print(io, "\t$(arc.origin.name) -> $(arc.destination.name): x : $(solution.x[i]), y : $(solution.y[i])\n")
    end

    # print(io, "Variables values :\n\t x:$(solution.x)\n \t y:$(solution.y)\n")

    print(io, "---------------------------------\n")
end 



#ANCHOR - FTP objects

"""
Node structure for the fixed transportation problem.
Defined by a stock and a demand
"""
struct FtpNode
    name::String
    stock::Int
    demand::Int
    type ::Char

    function FtpNode(name::String, stock::Int, demand::Int)
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
function Base.show(io::IO, node::FtpNode)
    print(io, "\tNode($(node.name), stock=$(node.stock), demand=$(node.demand), type = $(node.type) )\n")
end

"""
Arc structure for the fixed transportation problem.
Defined by a stock and a demand
"""
struct FtpArc
    origin::FtpNode
    destination::FtpNode
    fixed_cost::Float64
    variable_cost::Float64
end
function Base.show(io::IO, arc::FtpArc)
    print(io, "\tArc(origin=$(arc.origin.name), destination=$(arc.destination.name), fixed_cost=$(arc.fixed_cost), variable_cost=$(arc.variable_cost))\n")
end

"""
Network structure for the fixed transportation problem.
Contains nodes and arcs.
"""
struct FtpInstance
    name::String
    nodes::Dict{String,FtpNode}
    arcs::Vector{FtpArc}
end
function Base.show(io::IO, network::FtpInstance)
    print(io, "------ Network from instance $(network.name)------\n")

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
mutable struct FtpSolution
    network::FtpInstance
    objective_value::Float64
    x::Vector{Int}
    y::Vector{Int}
end

function Base.show(io::IO, solution::FtpSolution)
    print(io, "------ Solution of the FTP problem, for the instance $(solution.network.name) ------ \n")

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
